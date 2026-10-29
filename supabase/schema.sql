-- Sistema TC Pré Moldados: estrutura do banco no Supabase.
-- Rode uma vez em: Supabase → SQL Editor → New query → colar → Run.

-- Todos os registros do sistema (produtos, clientes, orçamentos, OS, custos e configurações).
create table if not exists public.registros (
  colecao        text        not null,
  id             text        not null,
  dados          jsonb       not null default '{}'::jsonb,
  atualizado_em  timestamptz not null default now(),
  atualizado_por uuid        default auth.uid(),
  primary key (colecao, id)
);

-- Só usuários logados (equipe) leem e alteram.
alter table public.registros enable row level security;
drop policy if exists "equipe le"     on public.registros;
drop policy if exists "equipe cria"   on public.registros;
drop policy if exists "equipe altera" on public.registros;
drop policy if exists "equipe apaga"  on public.registros;
create policy "equipe le"     on public.registros for select to authenticated using (true);
create policy "equipe cria"   on public.registros for insert to authenticated with check (true);
create policy "equipe altera" on public.registros for update to authenticated using (true) with check (true);
create policy "equipe apaga"  on public.registros for delete to authenticated using (true);

-- Atualização em tempo real entre computadores e celulares.
alter table public.registros replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.registros;
exception when duplicate_object then null; end $$;

-- Fotos e PDFs anexados (até 20 MB). Os nomes são aleatórios (UUID).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('arquivos', 'arquivos', true, 20971520, array['image/jpeg','image/png','image/webp','application/pdf'])
on conflict (id) do nothing;

drop policy if exists "equipe le arquivos"     on storage.objects;
drop policy if exists "equipe envia arquivos"  on storage.objects;
drop policy if exists "equipe apaga arquivos"  on storage.objects;
create policy "equipe le arquivos"    on storage.objects for select to authenticated using (bucket_id = 'arquivos');
create policy "equipe envia arquivos" on storage.objects for insert to authenticated with check (bucket_id = 'arquivos');
create policy "equipe apaga arquivos" on storage.objects for delete to authenticated using (bucket_id = 'arquivos');
