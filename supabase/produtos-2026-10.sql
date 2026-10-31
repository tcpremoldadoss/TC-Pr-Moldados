-- Novos produtos da planilha Cadastro_Produtos_TC.xlsx (31/10/2026).
-- Rode no Supabase: SQL Editor -> New query -> colar tudo -> Run.
-- Só ACRESCENTA. Produto que já existe com o mesmo nome fica como está. Pode rodar de novo sem duplicar.
insert into public.registros (colecao, id, dados)
select 'produtos', n.id, n.dados from (values
  ('p-ferragem-10mm-4-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 4 barras no aço CA-50 ∅ 10mm (3/8)", "foto": null, "nome": "Ferragem 10mm – 4 barras", "preco": 40.0, "unidade": "m"}$tc$::jsonb),
  ('p-ferragem-12-5mm-4-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 4 barras no aço CA-50 ∅ 12,5mm (1/2)", "foto": null, "nome": "Ferragem 12,5mm – 4 barras", "preco": 80.0, "unidade": "m"}$tc$::jsonb),
  ('p-ferragem-8mm-4-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 4 barras no aço CA-50 ∅ 8 mm (5/16)", "foto": null, "nome": "Ferragem 8mm – 4 barras", "preco": 35.0, "unidade": "m"}$tc$::jsonb),
  ('p-ferragem-6-3mm-4-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 4 barras no aço CA-50 ∅ 6,3mm (1/4)", "foto": null, "nome": "Ferragem 6,3mm – 4 barras", "preco": 20.0, "unidade": "m"}$tc$::jsonb),
  ('p-ferragem-10mm-6-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 6 barras no aço CA-50 ∅ 10 mm (3/8)", "foto": null, "nome": "Ferragem 10mm – 6 barras", "preco": 60.0, "unidade": "m"}$tc$::jsonb),
  ('p-ferragem-12-5mm-6-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 6 barras no aço CA-50 ∅ 12,5mm (1/2)", "foto": null, "nome": "Ferragem 12,5mm – 6 barras", "preco": 100.0, "unidade": "m"}$tc$::jsonb),
  ('p-ferragem-6-3mm-6-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 6 barras no aço CA-50 ∅ 6,3mm (1/4)", "foto": null, "nome": "Ferragem 6,3mm – 6 barras", "preco": 30.0, "unidade": "m"}$tc$::jsonb),
  ('p-ferragem-8mm-6-barras', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Ferragem armada com 6 barras no aço CA-50 ∅ 8mm (5/16)", "foto": null, "nome": "Ferragem 8mm – 6 barras", "preco": 50.0, "unidade": "m"}$tc$::jsonb),
  ('p-verga-1m', $tc${"categoria": "Vergas", "codigo": "", "custo": null, "descricaoCompleta": "Verga de concreto armado 10 x 10 cm, comprimento 1 m", "foto": null, "nome": "Verga 1m", "preco": 15.0, "unidade": "unid."}$tc$::jsonb),
  ('p-verga-1-20m', $tc${"categoria": "Vergas", "codigo": "", "custo": null, "descricaoCompleta": "Verga de concreto armado 10 x 10 cm, comprimento 1,20 m", "foto": null, "nome": "Verga 1,20m", "preco": 20.0, "unidade": "unid."}$tc$::jsonb),
  ('p-verga-2-0m', $tc${"categoria": "Vergas", "codigo": "", "custo": null, "descricaoCompleta": "Verga de concreto armado 10 x 10 cm, comprimento 2 m reforçada", "foto": null, "nome": "Verga 2,0m", "preco": 35.0, "unidade": "unid."}$tc$::jsonb),
  ('p-verga-2-50m', $tc${"categoria": "Vergas", "codigo": "", "custo": null, "descricaoCompleta": "Verga de concreto armado 10 x 10 cm, comprimento 2,5 m", "foto": null, "nome": "Verga 2,50m", "preco": 70.0, "unidade": "unid."}$tc$::jsonb),
  ('p-verga-3-0m', $tc${"categoria": "Vergas", "codigo": "", "custo": null, "descricaoCompleta": "Verga de concreto armado 10 x 10 cm, comprimento 3 m", "foto": null, "nome": "Verga 3,0m", "preco": 100.0, "unidade": "unid."}$tc$::jsonb),
  ('p-verga-3-50m', $tc${"categoria": "Vergas", "codigo": "", "custo": null, "descricaoCompleta": "Verga de concreto armado 10 x 10 cm, comprimento 3,50 m", "foto": null, "nome": "Verga 3,50m", "preco": 150.0, "unidade": "unid."}$tc$::jsonb),
  ('p-verga-4-0m', $tc${"categoria": "Vergas", "codigo": "", "custo": null, "descricaoCompleta": "Verga de concreto armado 10 x 10 cm, comprimento 4 m", "foto": null, "nome": "Verga 4,0m", "preco": 180.0, "unidade": "unid."}$tc$::jsonb),
  ('p-paver-8cm', $tc${"categoria": "Paver", "codigo": "", "custo": null, "descricaoCompleta": "Paver de 16 lados com 8cm", "foto": null, "nome": "Paver 8cm", "preco": 50.0, "unidade": "m²"}$tc$::jsonb),
  ('p-paver-6cm-10x20cm', $tc${"categoria": "Paver", "codigo": "", "custo": null, "descricaoCompleta": "Tijolinhos de 6cm", "foto": null, "nome": "Paver 6cm - 10x20cm", "preco": 45.0, "unidade": "m²"}$tc$::jsonb),
  ('p-eps-de-8cm', $tc${"categoria": "EPS (isopor)", "codigo": "", "custo": null, "descricaoCompleta": "Isopor de 1000x400x80 mm", "foto": null, "nome": "Eps de 8cm", "preco": 12.0, "unidade": "unid."}$tc$::jsonb),
  ('p-nervura-trelicada', $tc${"categoria": "Laje treliçada", "codigo": "", "custo": null, "descricaoCompleta": "Nervura treliçada H8", "foto": null, "nome": "Nervura treliçada", "preco": 15.0, "unidade": "m"}$tc$::jsonb),
  ('p-rufo-tipo-casa', $tc${"categoria": "Rufos", "codigo": "", "custo": null, "descricaoCompleta": "rufos casinha 30x100", "foto": null, "nome": "Rufo tipo casa", "preco": 25.0, "unidade": "unid."}$tc$::jsonb),
  ('p-rufo-reto', $tc${"categoria": "Rufos", "codigo": "", "custo": null, "descricaoCompleta": "rufos 30x100", "foto": null, "nome": "Rufo reto", "preco": 25.0, "unidade": "m"}$tc$::jsonb),
  ('p-corte-e-montagem-de-ferragem', $tc${"categoria": "Corte e dobra", "codigo": "", "custo": null, "descricaoCompleta": "Corte e dobra conforme projeto", "foto": null, "nome": "Corte e montagem de ferragem", "preco": 2.8, "unidade": "kg"}$tc$::jsonb)
) as n(id, dados)
where not exists (
  select 1 from public.registros r
  where r.colecao = 'produtos'
    and (r.id = n.id or lower(trim(r.dados->>'nome')) = lower(n.dados->>'nome'))
);

-- Conferência: lista todos os produtos depois da atualização.
select dados->>'categoria' as categoria, dados->>'nome' as produto, dados->>'unidade' as unidade, (dados->>'preco')::numeric as preco
from public.registros where colecao = 'produtos' order by 1, 2;
