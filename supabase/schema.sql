create extension if not exists pgcrypto;

create table if not exists public.inspectors(id uuid primary key default gen_random_uuid(),user_id uuid not null unique references auth.users(id) on delete cascade,full_name text not null,badge_number text,rank text,department text,position text,phone text,photo_url text,is_active boolean not null default true,created_at timestamptz not null default now(),updated_at timestamptz not null default now());

create table if not exists public.gibdd_stops(id text primary key,inspector_id uuid not null references public.inspectors(id) on delete cascade,reason text not null,make text not null,color text not null,plate text not null,owner text not null,passport text not null,license text not null,game_date text not null,note text not null default '',created_at timestamptz not null default now(),updated_at timestamptz not null default now());

create table if not exists public.gibdd_actions(id text primary key,stop_id text not null references public.gibdd_stops(id) on delete cascade,inspector_id uuid not null references public.inspectors(id) on delete cascade,type text not null check(type in ('fine','warning','arrest','revocation')),article text not null,resolution text not null default '',resolution_number text not null default '',note text not null default '',game_date text not null,created_at timestamptz not null default now());

create index if not exists gibdd_stops_inspector_idx on public.gibdd_stops(inspector_id);
create index if not exists gibdd_stops_passport_idx on public.gibdd_stops(passport);
create index if not exists gibdd_actions_stop_idx on public.gibdd_actions(stop_id);
create index if not exists gibdd_actions_inspector_idx on public.gibdd_actions(inspector_id);

alter table public.inspectors enable row level security;
alter table public.gibdd_stops enable row level security;
alter table public.gibdd_actions enable row level security;

drop policy if exists inspectors_select_own on public.inspectors;
create policy inspectors_select_own on public.inspectors for select to authenticated using(user_id=auth.uid());
drop policy if exists inspectors_update_own on public.inspectors;
create policy inspectors_update_own on public.inspectors for update to authenticated using(user_id=auth.uid()) with check(user_id=auth.uid());

drop policy if exists stops_select_own on public.gibdd_stops;
create policy stops_select_own on public.gibdd_stops for select to authenticated using(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));
drop policy if exists stops_insert_own on public.gibdd_stops;
create policy stops_insert_own on public.gibdd_stops for insert to authenticated with check(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));
drop policy if exists stops_update_own on public.gibdd_stops;
create policy stops_update_own on public.gibdd_stops for update to authenticated using(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active)) with check(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));
drop policy if exists stops_delete_own on public.gibdd_stops;
create policy stops_delete_own on public.gibdd_stops for delete to authenticated using(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));

drop policy if exists actions_select_own on public.gibdd_actions;
create policy actions_select_own on public.gibdd_actions for select to authenticated using(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));
drop policy if exists actions_insert_own on public.gibdd_actions;
create policy actions_insert_own on public.gibdd_actions for insert to authenticated with check(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));
drop policy if exists actions_update_own on public.gibdd_actions;
create policy actions_update_own on public.gibdd_actions for update to authenticated using(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active)) with check(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));
drop policy if exists actions_delete_own on public.gibdd_actions;
create policy actions_delete_own on public.gibdd_actions for delete to authenticated using(inspector_id in(select id from public.inspectors where user_id=auth.uid() and is_active));