// Configuração pública do Supabase (Project Settings → API).
// A chave "publishable" (antiga "anon") é pública por definição: quem protege os dados são as regras (RLS) do banco
// e o login. NUNCA coloque aqui a chave service_role nem a senha do banco.
window.TC_CONFIG = {
  supabaseUrl: "https://ydyotkbhaqhfiuvxzzqo.supabase.co",
  supabaseAnonKey: "sb_publishable_h4w4j3rkG85K9BDhqFPL7A_Qtgl4gVY" // chave publishable (pública)
};
