-- Rode no Supabase: SQL Editor -> New query -> cole tudo -> Run
-- TROQUE o e-mail abaixo (2 vezes não: só 1) pelo e-mail da sua conta de administrador.
create table if not exists public.pedidos_nuvem (
  id uuid primary key default gen_random_uuid(),
  vendedor_id uuid not null default auth.uid(),
  vendedor_email text,
  app_id text not null,
  num int,
  criado_em timestamptz not null default now(),
  cliente text,
  total numeric,
  dados jsonb not null,
  unique (vendedor_id, app_id)
);
alter table public.pedidos_nuvem enable row level security;
drop policy if exists "inserir proprio" on public.pedidos_nuvem;
drop policy if exists "ver proprio ou admin" on public.pedidos_nuvem;
create policy "inserir proprio" on public.pedidos_nuvem for insert to authenticated
  with check (vendedor_id = auth.uid());
create policy "ver proprio ou admin" on public.pedidos_nuvem for select to authenticated
  using (vendedor_id = auth.uid() or (auth.jwt() ->> 'email') = 'SEU_EMAIL_AQUI');
