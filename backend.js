/* Camada de dados do sistema TC sobre o Supabase.
   Expõe window.tcBackend com a mesma interface usada pelo app:
   - use("db"): collection(c).onSnapshot/add/doc(id).set/delete e doc("config/x").onSnapshot
   - use("assets"): upload(blob,{type}) -> {id,contentType}, arquivos no bucket "arquivos"
   - use("downloads"): save({filename,data}) baixa o arquivo no navegador
   Tudo fica na tabela public.registros (colecao, id, dados jsonb), com tempo real. */
(function(){
  const cfg=window.TC_CONFIG||{};
  const ok=!!(cfg.supabaseUrl&&cfg.supabaseAnonKey&&window.supabase);
  const sb=ok?window.supabase.createClient(cfg.supabaseUrl,cfg.supabaseAnonKey):null;
  const BUCKET="arquivos";

  const cache={};       // colecao -> Map(id -> dados)
  const ouvintes={};    // colecao -> Set(fn)
  let canal=null;

  const erro=(e)=>{const x=new Error(e&&e.message||"erro");x.code=e&&(e.code==="42501"?"invalid_argument":e.code)||"erro";return x};
  const novoId=()=>{const a="abcdefghijklmnopqrstuvwxyz0123456789";let s="";const r=crypto.getRandomValues(new Uint8Array(20));r.forEach(b=>s+=a[b%36]);return s};
  function avisa(c){
    const m=cache[c];if(!m)return;
    const docs=[...m.entries()].map(([id,d])=>({id,data:()=>JSON.parse(JSON.stringify(d))}));
    (ouvintes[c]||[]).forEach(fn=>{try{fn({docs})}catch(e){console.error(e)}});
  }
  function ligaTempoReal(){
    if(canal)return;
    canal=sb.channel("registros").on("postgres_changes",{event:"*",schema:"public",table:"registros"},p=>{
      const r=p.eventType==="DELETE"?p.old:p.new;if(!r||!r.colecao)return;
      const m=cache[r.colecao];if(!m)return;
      if(p.eventType==="DELETE")m.delete(r.id);else m.set(r.id,r.dados||{});
      avisa(r.colecao);
    }).subscribe();
  }
  async function carrega(c){
    const m=new Map();let de=0;
    for(;;){
      const {data,error}=await sb.from("registros").select("id,dados").eq("colecao",c).range(de,de+999);
      if(error)throw erro(error);
      data.forEach(r=>m.set(r.id,r.dados||{}));
      if(data.length<1000)break;de+=1000;
    }
    cache[c]=m;
  }
  async function grava(c,id,dados){
    const {error}=await sb.from("registros").upsert({colecao:c,id,dados,atualizado_em:new Date().toISOString()});
    if(error)throw erro(error);
    if(cache[c]){cache[c].set(id,JSON.parse(JSON.stringify(dados)));avisa(c)}
    return id;
  }
  async function apaga(c,id){
    const {error}=await sb.from("registros").delete().eq("colecao",c).eq("id",id);
    if(error)throw erro(error);
    if(cache[c]){cache[c].delete(id);avisa(c)}
  }
  function collection(c){
    return {
      onSnapshot(fn,fnErro){
        (ouvintes[c]=ouvintes[c]||new Set()).add(fn);ligaTempoReal();
        (cache[c]?Promise.resolve():carrega(c)).then(()=>avisa(c)).catch(e=>fnErro&&fnErro(e));
        return ()=>ouvintes[c].delete(fn);
      },
      add:async(dados)=>({id:await grava(c,novoId(),dados)}),
      doc:(id)=>({set:(dados)=>grava(c,id,dados),delete:()=>apaga(c,id)})
    };
  }
  function doc(caminho){
    const [c,id]=caminho.split("/");
    return {
      onSnapshot(fn,fnErro){
        return collection(c).onSnapshot(()=>{const d=cache[c].get(id);fn({exists:!!d,data:()=>JSON.parse(JSON.stringify(d||{}))})},fnErro);
      },
      set:(dados)=>grava(c,id,dados)
    };
  }
  const db={collection,doc};

  const assets={
    async upload(blob,{type}){
      if(blob.size>20*1024*1024){const e=new Error("grande");e.code="too_large";throw e}
      const ext=type==="application/pdf"?"pdf":type==="image/png"?"png":type==="image/webp"?"webp":"jpg";
      const id=(crypto.randomUUID?crypto.randomUUID():novoId())+"."+ext;
      const {error}=await sb.storage.from(BUCKET).upload(id,blob,{contentType:type,upsert:false});
      if(error)throw erro(error);
      return {id,contentType:type};
    }
  };
  const downloads={
    async save({filename,data}){
      const url=URL.createObjectURL(data);const a=document.createElement("a");
      a.href=url;a.download=filename;document.body.appendChild(a);a.click();a.remove();
      setTimeout(()=>URL.revokeObjectURL(url),4000);
    }
  };

  window.tcBackend={
    configurado:ok,
    sb,
    arquivoUrl:(id)=>ok?`${cfg.supabaseUrl}/storage/v1/object/public/${BUCKET}/${encodeURIComponent(id)}`:"",
    async use(nome){return nome==="db"?db:nome==="assets"?assets:nome==="downloads"?downloads:null}
  };
})();
