create extension if not exists pgcrypto;

create table if not exists public.inspectors (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null unique references auth.users(id) on delete cascade,
 full_name text not null,
 badge_number text,
 rank text,
 department text,
 position text,
 phone text,
 photo_url text,
 is_active boolean not null default true,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);

create table if not exists public.vehicles (
 id uuid primary key default gen_random_uuid(), inspector_id uuid not null references public.inspectors(id), plate text not null, vin text, brand text not null, model text not null, color text, year integer, owner_name text, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.drivers (
 id uuid primary key default gen_random_uuid(), inspector_id uuid not null references public.inspectors(id), full_name text not null, birth_date date, license_number text not null, license_category text, phone text, address text, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.protocols (
 id uuid primary key default gen_random_uuid(), inspector_id uuid not null references public.inspectors(id), number text not null, violation_date timestamptz not null, driver_name text not null, plate text not null, article text not null, description text, amount numeric(12,2) default 0, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table if not exists public.fines (
 id uuid primary key default gen_random_uuid(), inspector_id uuid not null references public.inspectors(id), number text not null, issued_at timestamptz not null, driver_name text not null, plate text not null, article text not null, amount numeric(12,2) not null default 0, status text not null default 'Не оплачен' check (status in ('Не оплачен','Оплачен','Отменён')), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create index if not exists vehicles_inspector_idx on public.vehicles(inspector_id);
create index if not exists drivers_inspector_idx on public.drivers(inspector_id);
create index if not exists protocols_inspector_idx on public.protocols(inspector_id);
create index if not exists fines_inspector_idx on public.fines(inspector_id);

alter table public.inspectors enable row level security;
alter table public.vehicles enable row level security;
alter table public.drivers enable row level security;
alter table public.protocols enable row level security;
alter table public.fines enable row level security;

create policy "inspectors own profile" on public.inspectors for select to authenticated using (user_id = auth.uid());
create policy "inspectors update own profile" on public.inspectors for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "vehicles own records" on public.vehicles for all to authenticated using (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active)) with check (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active));
create policy "drivers own records" on public.drivers for all to authenticated using (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active)) with check (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active));
create policy "protocols own records" on public.protocols for all to authenticated using (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active)) with check (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active));
create policy "fines own records" on public.fines for all to authenticated using (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active)) with check (inspector_id in (select id from public.inspectors where user_id = auth.uid() and is_active));

-- After creating the first user in Authentication -> Users, insert its UUID here:
-- insert into public.inspectors(user_id,full_name,badge_number,rank,department,position) values ('AUTH_USER_UUID','ФИО инспектора','0001','Инспектор','ГИБДД','Инспектор ДПС');
