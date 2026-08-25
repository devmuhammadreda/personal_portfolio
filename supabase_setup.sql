-- =============================================================================
-- Personal Portfolio — Supabase schema + security
-- Run once in Supabase Dashboard › SQL Editor (New query → paste → Run).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Tables
--    Columns use camelCase to mirror the Dart models 1:1 (quoted identifiers).
-- -----------------------------------------------------------------------------

-- Single-row profile (id is always 1).
create table if not exists public.profile (
  id int primary key default 1 check (id = 1),
  name text not null default '',
  title text not null default '',
  tagline text not null default '',
  "aboutMe" text not null default '',
  skills jsonb not null default '[]'::jsonb,
  "socialLinks" jsonb not null default '{}'::jsonb,
  "resumeUrl" text,
  "profileImageUrl" text,
  "yearsOfExperience" int not null default 0,
  "availableForWork" boolean not null default false,
  updated_at timestamptz not null default now()
);

-- Seed the empty profile row so the first save is an update.
insert into public.profile (id) values (1) on conflict (id) do nothing;

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null default '',
  description text not null default '',
  "longDescription" text not null default '',
  "techStack" jsonb not null default '[]'::jsonb,
  role text not null default 'Solo developer',
  "imageUrls" jsonb not null default '[]'::jsonb,
  category text not null default 'mobile',
  featured boolean not null default false,
  "order" int not null default 0,
  "createdAt" timestamptz not null default now(),
  "updatedAt" timestamptz not null default now()
);

-- -----------------------------------------------------------------------------
-- 2. Admin gate
--    Sign up your admin user in Dashboard › Authentication first, then:
--      insert into public.admins (user_id, email)
--      values ('<auth-user-uuid>', 'you@example.com');
--    (select the uuid from Authentication › Users table)
-- -----------------------------------------------------------------------------

create table if not exists public.admins (
  user_id uuid primary key references auth.users (id) on delete cascade,
  email text not null unique
);

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

-- -----------------------------------------------------------------------------
-- 3. Row Level Security — public read, admin-only writes
-- -----------------------------------------------------------------------------

alter table public.profile  enable row level security;
alter table public.projects enable row level security;
alter table public.admins   enable row level security;

drop policy if exists "public read profile" on public.profile;
create policy "public read profile"
  on public.profile for select using (true);

drop policy if exists "admin write profile" on public.profile;
create policy "admin write profile"
  on public.profile for all
  using (public.is_admin()) with check (public.is_admin());

drop policy if exists "public read projects" on public.projects;
create policy "public read projects"
  on public.projects for select using (true);

drop policy if exists "admin write projects" on public.projects;
create policy "admin write projects"
  on public.projects for all
  using (public.is_admin()) with check (public.is_admin());

-- admins table: no policies → only the service role / SQL editor touches it.

-- -----------------------------------------------------------------------------
-- 4. Realtime — live updates for both tables
-- -----------------------------------------------------------------------------

do $$
begin
  begin
    alter publication supabase_realtime add table public.profile;
  exception when duplicate_object then null; -- already added
  end;
  begin
    alter publication supabase_realtime add table public.projects;
  exception when duplicate_object then null;
  end;
end $$;

-- -----------------------------------------------------------------------------
-- 5. Storage — public `portfolio-media` bucket + admin-only writes
--    (Run after creating the bucket, see README step 3.)
-- -----------------------------------------------------------------------------

insert into storage.buckets (id, name, public)
values ('portfolio-media', 'portfolio-media', true)
on conflict (id) do update set public = true;

drop policy if exists "public read media" on storage.objects;
create policy "public read media"
  on storage.objects for select
  using (bucket_id = 'portfolio-media');

drop policy if exists "admin upload media" on storage.objects;
create policy "admin upload media"
  on storage.objects for insert
  with check (bucket_id = 'portfolio-media' and public.is_admin());

drop policy if exists "admin update media" on storage.objects;
create policy "admin update media"
  on storage.objects for update
  using (bucket_id = 'portfolio-media' and public.is_admin());

drop policy if exists "admin delete media" on storage.objects;
create policy "admin delete media"
  on storage.objects for delete
  using (bucket_id = 'portfolio-media' and public.is_admin());
