-- Contact messages submitted through the public portfolio form.
-- Apply in Supabase Dashboard → SQL Editor, or via the CLI:
--   supabase db push   (after linking the project)
create table if not exists public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null check (char_length(name) between 1 and 120),
  email text not null check (char_length(email) <= 254),
  message text not null check (char_length(message) between 1 and 5000),
  is_read boolean not null default false
);

create index if not exists contact_messages_created_at_idx
  on public.contact_messages (created_at desc);

alter table public.contact_messages enable row level security;

-- Visitors (anon) may only submit new messages — no reads, ever.
create policy "anon can submit contact messages"
  on public.contact_messages for insert
  to anon
  with check (true);

-- The signed-in admin can read and manage every message.
create policy "admin can read contact messages"
  on public.contact_messages for select
  to authenticated
  using (true);

create policy "admin can update contact messages"
  on public.contact_messages for update
  to authenticated
  using (true)
  with check (true);

create policy "admin can delete contact messages"
  on public.contact_messages for delete
  to authenticated
  using (true);
