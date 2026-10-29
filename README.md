# Sistema TC Pré Moldados

Sistema interno de orçamentos, produção, clientes, produtos e financeiro da TC Pré Moldados.

- **Site:** página estática (`index.html`), publicada na Vercel.
- **Dados, login e fotos:** Supabase (tabela `registros`, Supabase Auth e bucket `arquivos`).

## Arquivos

| Arquivo | Para quê |
|---|---|
| `index.html` | O sistema |
| `backend.js` | Ligação com o Supabase (dados em tempo real, fotos, downloads) |
| `supabase-config.js` | URL e chave **pública** (anon) do Supabase |
| `supabase/schema.sql` | Cria a tabela, as regras de acesso e o bucket de fotos |
| `os.html` | Página do funcionário da produção: abre pelo link da OS no WhatsApp e marca a OS como finalizada |
| `supabase/os-whatsapp.sql` | Funções que deixam o link da OS ver e finalizar só aquela OS (rodar uma vez) |
| `supabase/seed.sql` | Dados migrados do protótipo (setembro/2026, clientes, produtos, centros de custo e categorias) |

## Configuração (uma vez)

1. **Supabase** → criar projeto → *SQL Editor* → rodar `supabase/schema.sql` e depois `supabase/seed.sql`.
2. *Authentication → Sign In / Providers*: desligar **Allow new users to sign up** (só a equipe entra).
3. *Authentication → Users → Add user*: criar cada pessoa da equipe com e-mail e senha (marcar *Auto Confirm User*).
   Para o nome aparecer certo no sistema, rode no SQL Editor:
   ```sql
   update auth.users set raw_user_meta_data = raw_user_meta_data || '{"nome":"Pedro Henrique"}' where email = 'EMAIL_DO_PEDRO';
   ```
4. *Project Settings → API*: copiar **Project URL** e a chave **publishable** (ou anon public) para `supabase-config.js`.
5. **Vercel** → *Add New → Project* → importar este repositório → *Framework Preset: Other* → *Deploy*.
   Cada novo commit na branch `main` publica sozinho.

## OS pelo WhatsApp

Na OS, preencha o responsável e o WhatsApp dele e clique em **Enviar à produção (WhatsApp)**. A mensagem vai pronta com
os itens e um link exclusivo daquela OS. Quando o funcionário aperta **Finalizada** no link, a OS passa para
"Pronto p/ entrega" e aparece um aviso verde no Painel e na Produção. Precisa ter rodado `supabase/os-whatsapp.sql` uma vez.

Nunca coloque no código a chave `service_role` nem a senha do banco.
