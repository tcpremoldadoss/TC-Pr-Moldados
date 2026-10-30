-- Sistema TC Pré Moldados: funcionário da produção inicia e finaliza a OS pelo link enviado no WhatsApp.
-- Rode uma vez em: Supabase → SQL Editor → New query → colar → Run (pode rodar de novo sem problema).
--
-- Cada OS enviada pelo WhatsApp ganha um código aleatório (dados->>'token') que vai no link os.html?t=CODIGO.
-- A página do funcionário não tem login: ela só consegue ver aquela OS e marcá-la como iniciada
-- ou finalizada, por estas três funções. O resto do banco continua fechado para quem não é da equipe.

create or replace function public.os_por_link(p_token text) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
           'numero',      dados->'numero',
           'clienteNome', dados->'clienteNome',
           'itens',       coalesce(dados->'itens', '[]'::jsonb),
           'prazo',       dados->'prazo',
           'responsavel', dados->'responsavel',
           'obsProducao', dados->'obsProducao',
           'fotos',       coalesce(dados->'fotos', '[]'::jsonb),
           'status',      dados->'status',
           'iniciadaEm',  dados->'iniciadaEm',
           'iniciadaPor', dados->'iniciadaPor',
           'finalizadaEm',  dados->'finalizadaEm',
           'finalizadaPor', dados->'finalizadaPor')
    from public.registros
   where colecao = 'os' and length(coalesce(p_token, '')) >= 20 and dados->>'token' = p_token
   limit 1
$$;

create or replace function public.os_iniciar_por_link(p_token text, p_nome text) returns jsonb
language plpgsql security definer set search_path = public as $$
declare r public.registros;
begin
  if length(coalesce(p_token, '')) < 20 then return null; end if;
  select * into r from public.registros
   where colecao = 'os' and dados->>'token' = p_token
   for update;
  if not found then return null; end if;
  -- Só muda quem ainda está aguardando; nas outras etapas só devolve a OS.
  if coalesce(r.dados->>'status', 'aguardando') = 'aguardando' then
    update public.registros
       set dados = r.dados || jsonb_build_object(
             'status',      'produzindo',
             'iniciadaEm',  to_char(now() at time zone 'America/Fortaleza', 'YYYY-MM-DD"T"HH24:MI:SS'),
             'iniciadaPor', left(coalesce(nullif(trim(p_nome), ''), 'Produção'), 80)),
           atualizado_em = now()
     where colecao = r.colecao and id = r.id;
  end if;
  return public.os_por_link(p_token);
end $$;

create or replace function public.os_finalizar_por_link(p_token text, p_nome text, p_obs text) returns jsonb
language plpgsql security definer set search_path = public as $$
declare r public.registros;
begin
  if length(coalesce(p_token, '')) < 20 then return null; end if;
  select * into r from public.registros
   where colecao = 'os' and dados->>'token' = p_token
   for update;
  if not found then return null; end if;
  -- Já finalizada (ou já entregue): não muda nada, só devolve a OS.
  if r.dados->>'status' in ('pronto', 'entregue') then return public.os_por_link(p_token); end if;
  update public.registros
     set dados = r.dados || jsonb_build_object(
           'status',        'pronto',
           'itens',         (select coalesce(jsonb_agg(i || '{"feito":true}'::jsonb), '[]'::jsonb)
                               from jsonb_array_elements(coalesce(r.dados->'itens', '[]'::jsonb)) i),
           'finalizadaEm',  to_char(now() at time zone 'America/Fortaleza', 'YYYY-MM-DD"T"HH24:MI:SS'),
           'finalizadaPor', left(coalesce(nullif(trim(p_nome), ''), 'Produção'), 80),
           'finalizadaObs', left(coalesce(trim(p_obs), ''), 1000),
           'avisoPendente', true)
         || case when r.dados ? 'iniciadaEm' then '{}'::jsonb else jsonb_build_object(
           'iniciadaEm',  to_char(now() at time zone 'America/Fortaleza', 'YYYY-MM-DD"T"HH24:MI:SS'),
           'iniciadaPor', left(coalesce(nullif(trim(p_nome), ''), 'Produção'), 80)) end,
         atualizado_em = now()
   where colecao = r.colecao and id = r.id;
  return public.os_por_link(p_token);
end $$;

revoke all on function public.os_por_link(text) from public;
revoke all on function public.os_finalizar_por_link(text, text, text) from public;
revoke all on function public.os_iniciar_por_link(text, text) from public;
grant execute on function public.os_por_link(text) to anon, authenticated;
grant execute on function public.os_finalizar_por_link(text, text, text) to anon, authenticated;
grant execute on function public.os_iniciar_por_link(text, text) to anon, authenticated;
