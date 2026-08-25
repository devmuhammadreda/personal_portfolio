# Personal Portfolio — Flutter Web + Supabase

A responsive single-page developer portfolio built with **Flutter Web** and a
**separate admin flavor** backed by **Supabase** (Auth / Postgres / Storage).
Content is edited at runtime through the admin console — no redeploy needed.

| | |
|---|---|
| State management | `flutter_bloc` (Cubits) |
| Architecture | Feature-first Clean Architecture (`data` / `domain` / `presentation`) |
| DI | `get_it` |
| Routing | `go_router`; admin guard lives only in the admin flavor |
| Flavors | `flutter_flavor` — separate entry points & dependency graphs |

## Flavors

| Flavor | Entry point | What it ships |
|---|---|---|
| **portfolio** | `lib/main_portfolio.dart` (default via `main.dart`) | Public site only. No auth, no admin routes, no admin DI — release builds tree-shake all admin code away. |
| **admin** | `lib/main_admin.dart` | Guarded admin console (login → dashboard). Boots at `/admin`; public site stays reachable for preview. The discreet footer “Admin” shortcut exists only here. |

The `FlavorBanner` shows a label in debug mode and is hidden in release.

### Per-flavor configuration (`FlavorConfig.variables`)

Entry points can pass settings that features read via the typed
`core/flavor/flavor_settings.dart`. Built-in keys:

| Variable | Type | Default | Purpose |
|---|---|---|---|
| `flavor` | `String` | `'portfolio'` | Flavor identity |
| `tablePrefix` | `String` | `''` | Prefix for Supabase tables — set `'staging_'` to point a build at isolated staging tables |

```dart
FlavorConfig(
  name: kDebugMode ? 'PORTFOLIO' : '',
  variables: {'flavor': 'portfolio', 'collectionPrefix': 'staging_'},
);
```

## Localization (EN / AR)

- **Sources:** `assets/translations/app_en.arb` + `app_ar.arb` (bundled as assets)
- **Generated code:** `lib/l10n/` via `l10n.yaml` → run `flutter gen-l10n` after editing
- **Locale state:** `LocaleCubit` (`core/localizations_cubit/`) — starts from the system locale, toggled by the `ع`/`EN` pill in the navbar / admin shell; Arabic flips the whole app to RTL automatically
- Access strings anywhere below MaterialApp with `context.loc.someKey`
- After editing ARBs: `flutter gen-l10n`, then restart the app

## Project structure

```
lib/
  core/                     theme, routers, DI core, mixin, services, flavor config
    di/injector.dart        service locator + platform-level registrations
    router/                 portfolio_router.dart · auth_gate.dart
    mixin/                  CubitLifecycleMixin (safeEmit, retry, debounce)
    services/               AppBlocObserver (debug state-change logging)
    flavor/                 FlavorSettings — typed FlavorConfig.variables access
  features/
    portfolio/
      data/                 models, Supabase datasources, repository impls
      domain/               entities (Profile, Project) + repository interfaces
      presentation/         cubit, page, section widgets
      di/                   portfolio_dependencies.dart (data + public router)
    admin/
      routing/              admin_router.dart (guard + all /admin routes)
      di/                   admin_dependencies.dart (composes feature registrars)
      auth/di/              auth_injection.dart (Auth SDK, repo, cubit, gate)
      media/di/             media_injection.dart (Storage SDK, upload repo)
      auth/                 login feature (cubit + page)
      media/                Storage upload/delete repository
      profile_management/   profile editor + live preview
      project_management/   project list (reorder) + create/edit form
      presentation/         dashboard, AdminShell, footer shortcut chip
  core/config/              SupabaseConfig (URL + anon key)
  core/supabase/            bootstrapper
  main.dart                 shared bootstrap: all init + app config
  main_portfolio.dart       portfolio flavor — FlavorConfig only
  main_admin.dart           admin flavor — FlavorConfig only
```

All Supabase access goes through the repository layer — the UI never
touches the backend SDK directly. Every async action surfaces loading / success /
error states via Cubits.

---

## Setup

### 1. Prerequisites

- Flutter (stable channel) with web enabled: `flutter devices` should list Chrome
- A free [Supabase](https://supabase.com) account

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Connect a Supabase project

1. Create a project at <https://supabase.com/dashboard> (any region close to you).
2. Open **Project Settings › API**, copy the **Project URL** and **anon /
   publishable key**, then create a `.env` file at the repo root (copy
   `.env.example`) with:

   ```dotenv
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```

   Secrets are compiled in via [`envied`](https://pub.dev/packages/envied)
   (obfuscated, git-ignored). After editing `.env`, regenerate:
   `dart run build_runner build --delete-conflicting-outputs`. Never put the
   database password or service-role key in `.env`.
3. Open **SQL Editor › New query**, paste the contents of
   [`supabase_setup.sql`](supabase_setup.sql) and run it. This creates:
   - `profile` + `projects` tables (camelCase columns mirroring the Dart models)
   - Row Level Security: **public read, admin-only writes**
   - Realtime enabled on both tables
   - The public `portfolio-media` storage bucket with admin-only upload policies
4. Enable **Authentication › Providers › Email**.
5. Create your admin login: **Authentication › Users › Add user**
   (email + password, auto-confirm).
6. Authorize that user for writes — in SQL Editor run:

```sql
insert into public.admins (user_id, email)
values ('<user-uuid-from-auth-table>', 'you@example.com');
```

Until step 3 is done the app still boots in UI-only mode and surfaces
graceful error states.

### 4. Run locally

### 4. Run locally

```bash
flutter run -d chrome                            # portfolio flavor
flutter run -d chrome -t lib/main_admin.dart     # admin flavor
```

Portfolio: `http://localhost:…/#/` — there is **no** way into the admin panel
from this build. Admin: boots at `/admin` (login first); the footer “Admin”
shortcut also appears on the public preview.

VS Code users: `.vscode/launch.json` ships with a launch config per flavor.

---

## Deploy (any static host)

Supabase is backend-only — it does not host websites. The `build/web`
output deploys to any static host. The repo ships a `web/_redirects` file
(SPA fallback: every route → `/index.html`) that Flutter copies into the
build automatically; it works on Netlify, Cloudflare Pages and Vercel.

Deploy each flavor to its **own site/domain** — the admin console should
never be reachable from the public domain.

```bash
# Public site (portfolio flavor)
flutter build web --target lib/main_portfolio.dart --release

# Admin console (admin flavor)
flutter build web --target lib/main_admin.dart --release
```

Then publish `build/web` with whichever flow you prefer:

| Host | How |
|---|---|
| **Netlify** | drag `build/web` onto <https://app.netlify.com/drop>, or `npx netlify-cli deploy --dir build/web --prod` |
| **Cloudflare Pages** | `npx wrangler pages deploy build/web --project-name portfolio` |
| **Vercel** | `npx vercel deploy build/web --prod` |
| **GitHub Pages** | push `build/web` to a `gh-pages` branch (`peaceiris/actions-gh-pages` for CI) |

> Security note: anyone can *open* the admin URL, but Supabase RLS makes
> every read/write fail without an authenticated user listed in
> `public.admins` — nothing sensitive is exposed.

---

## Editing content (after deployment)

Sign in at the admin site (`/admin/login` on the admin hosting URL):

- **Profile** — name, title, tagline, bio, years of experience, availability,
  skills (name + level), social links, profile photo, PDF resume. A live
  preview mirrors the public hero while you type. Press **Save changes**.
- **Projects** — create/edit/delete, mark as *featured*, drag rows to reorder
  (order applies to the public site instantly). The first screenshot becomes
  the card cover.

Changes appear on the public site immediately (fresh fetch per visit).

## Troubleshooting

| Symptom | Fix |
|---|---|
| `UnsupportedError: firebase_options.dart has not been generated` | Run `flutterfire configure` (step 3). |
| Login says “Invalid email or password” | Check the user exists; claims aren’t needed for sign-in itself. |
| Writes fail with row-level-security / permission errors | Your user is not in `public.admins` — run the insert from Setup step 3.6, then sign out/in. |
| Uploads fail but Firestore works | Redeploy storage rules; check you’re on the right bucket/project. |
