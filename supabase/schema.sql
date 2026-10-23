-- Nama: Dewa Putu Bagus Mahadinata
-- NIM: 2415051023
-- supabase/schema.sql
-- Skema tabel courses untuk praktikum. Policy permisif hanya untuk laboratorium.

create table public.courses (
  id         bigint generated always as identity primary key,
  code       text   not null,
  title      text   not null,
  credits    int    not null check (credits > 0),
  status     text   not null default 'planned'
             check (status in ('planned', 'active', 'done')),
  created_at timestamptz not null default now()
);

alter table public.courses enable row level security;

create policy "lab anon select" on public.courses for select to anon using (true);
create policy "lab anon insert" on public.courses for insert to anon with check (true);
create policy "lab anon update" on public.courses for update to anon using (true) with check (true);
create policy "lab anon delete" on public.courses for delete to anon using (true);