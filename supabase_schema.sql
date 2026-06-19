-- ═══════════════════════════════════════════════════════════
-- ESQUEMA SUPABASE — Árbol Genealógico
-- Ejecutar en: Supabase Dashboard → SQL Editor → New query
-- ═══════════════════════════════════════════════════════════

-- Un árbol por usuario (se crea automáticamente al primer login)
create table public.trees (
  id uuid primary key default gen_random_uuid(),
  owner uuid references auth.users(id) on delete cascade not null,
  name text not null default 'Mi árbol',
  created_at timestamptz default now()
);

-- Personas: ancestros directos Y hermanos de ancestros.
-- lineage_id: '0' = probando, '0p' padre, '0m' madre, '0pm' abuela paterna...
-- Hermanos: lineage_id '0mm#1', '0mm#2'... con sibling_of = '0mm'
-- data: jsonb con todo el payload del perfil (flexible, fiel al JSON de la app)
create table public.persons (
  id uuid primary key default gen_random_uuid(),
  tree_id uuid references public.trees(id) on delete cascade not null,
  lineage_id text not null,
  sibling_of text,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now(),
  unique (tree_id, lineage_id)
);

create index persons_tree_idx on public.persons(tree_id);
create index persons_sibling_idx on public.persons(tree_id, sibling_of);

-- ═══ SEGURIDAD: cada usuario solo ve/edita lo suyo ═══
alter table public.trees enable row level security;
alter table public.persons enable row level security;

create policy "trees_own" on public.trees
  for all using (owner = auth.uid()) with check (owner = auth.uid());

create policy "persons_own" on public.persons
  for all using (
    exists (select 1 from public.trees t where t.id = tree_id and t.owner = auth.uid())
  ) with check (
    exists (select 1 from public.trees t where t.id = tree_id and t.owner = auth.uid())
  );

-- Trigger para updated_at
create or replace function public.touch_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger persons_touch before update on public.persons
  for each row execute function public.touch_updated_at();
