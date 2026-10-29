-- Sistema TC Pré Moldados: cria os usuários da equipe e limita o acesso a eles.
-- Antes de rodar, troque os e-mails e as SENHAS abaixo (só aqui, no SQL Editor; não salve este arquivo com senhas).
-- Rode em: Supabase → SQL Editor → New query → colar → Run. Pode rodar de novo para trocar a senha.

create extension if not exists pgcrypto;

-- 1) Lista da equipe: só estes e-mails conseguem ver e alterar os dados,
--    mesmo que alguém crie uma conta por conta própria.
create table if not exists public.equipe (email text primary key, nome text not null);
alter table public.equipe enable row level security;

insert into public.equipe (email, nome) values
  ('EMAIL_DO_PEDRO',   'Pedro Henrique'),
  ('EMAIL_DA_TAINARA', 'Tainara')
on conflict (email) do update set nome = excluded.nome;

create or replace function public.eh_equipe() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.equipe where lower(email) = lower(auth.jwt() ->> 'email'))
$$;

drop policy if exists "equipe le"     on public.registros;
drop policy if exists "equipe cria"   on public.registros;
drop policy if exists "equipe altera" on public.registros;
drop policy if exists "equipe apaga"  on public.registros;
create policy "equipe le"     on public.registros for select to authenticated using (public.eh_equipe());
create policy "equipe cria"   on public.registros for insert to authenticated with check (public.eh_equipe());
create policy "equipe altera" on public.registros for update to authenticated using (public.eh_equipe()) with check (public.eh_equipe());
create policy "equipe apaga"  on public.registros for delete to authenticated using (public.eh_equipe());

drop policy if exists "equipe envia arquivos" on storage.objects;
drop policy if exists "equipe apaga arquivos" on storage.objects;
create policy "equipe envia arquivos" on storage.objects for insert to authenticated with check (bucket_id = 'arquivos' and public.eh_equipe());
create policy "equipe apaga arquivos" on storage.objects for delete to authenticated using (bucket_id = 'arquivos' and public.eh_equipe());

-- 2) Cria (ou atualiza a senha de) cada usuário, já confirmado.
create or replace function pg_temp.cria_usuario(p_email text, p_senha text, p_nome text) returns void
language plpgsql as $$
declare uid uuid;
begin
  select id into uid from auth.users where lower(email) = lower(p_email);
  if uid is null then
    uid := gen_random_uuid();
    insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
                            raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
                            confirmation_token, email_change, email_change_token_new, recovery_token)
    values ('00000000-0000-0000-0000-000000000000', uid, 'authenticated', 'authenticated', lower(p_email),
            crypt(p_senha, gen_salt('bf')), now(),
            '{"provider":"email","providers":["email"]}', jsonb_build_object('nome', p_nome), now(), now(),
            '', '', '', '');
    insert into auth.identities (id, user_id, provider_id, provider, identity_data, last_sign_in_at, created_at, updated_at)
    values (gen_random_uuid(), uid, uid::text, 'email',
            jsonb_build_object('sub', uid::text, 'email', lower(p_email), 'email_verified', true), now(), now(), now());
  else
    update auth.users set encrypted_password = crypt(p_senha, gen_salt('bf')),
           email_confirmed_at = coalesce(email_confirmed_at, now()),
           raw_user_meta_data = coalesce(raw_user_meta_data, '{}') || jsonb_build_object('nome', p_nome),
           updated_at = now()
     where id = uid;
  end if;
end $$;

select pg_temp.cria_usuario('EMAIL_DO_PEDRO',   'SENHA_DO_PEDRO',   'Pedro Henrique');
select pg_temp.cria_usuario('EMAIL_DA_TAINARA', 'SENHA_DA_TAINARA', 'Tainara');

select email, nome from public.equipe;
