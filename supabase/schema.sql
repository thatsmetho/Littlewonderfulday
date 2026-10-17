-- Little Wonderful Day: one private settings document per authenticated parent.
-- Run in Supabase SQL Editor. Row Level Security is mandatory.
create table if not exists public.family_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.family_settings enable row level security;

drop policy if exists "Parents can read their own family settings" on public.family_settings;
create policy "Parents can read their own family settings"
  on public.family_settings for select
  to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Parents can insert their own family settings" on public.family_settings;
create policy "Parents can insert their own family settings"
  on public.family_settings for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Parents can update their own family settings" on public.family_settings;
create policy "Parents can update their own family settings"
  on public.family_settings for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- No anonymous access policy is created. Do not add a service-role key to the website.
