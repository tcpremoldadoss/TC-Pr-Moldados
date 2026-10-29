// Configuração pública do Supabase (Project Settings → API).
// A chave "anon" é pública por definição: quem protege os dados são as regras (RLS) do banco
// e o login. NUNCA coloque aqui a chave service_role nem a senha do banco.
window.TC_CONFIG = {
  supabaseUrl: "",      // ex.: https://abcdefgh.supabase.co
  supabaseAnonKey: ""   // chave "anon public"
};
