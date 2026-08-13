window.GIBDD_AUTH = {
  user: null,
  inspector: null,
  async init(){
    const {data:{session}}=await sb.auth.getSession();
    if(session) return this.finish(session.user);
    showLogin();
    sb.auth.onAuthStateChange((_event,session)=>{ if(session) this.finish(session.user); else showLogin(); });
  },
  async finish(user){
    this.user=user;
    const {data,error}=await sb.from('inspectors').select('*').eq('user_id',user.id).maybeSingle();
    if(error){showLoginError(error.message);return}
    if(!data || !data.is_active){await sb.auth.signOut();showLoginError('Профиль инспектора не найден или заблокирован.');return}
    this.inspector=data;
    document.getElementById('loginView').classList.add('hidden');
    document.getElementById('appView').classList.remove('hidden');
    document.getElementById('inspectorBadge').textContent=data.full_name;
    document.getElementById('statInspector').textContent=data.badge_number||'—';
    window.dispatchEvent(new CustomEvent('gibdd:ready'));
  },
  async login(email,password){
    const {error}=await sb.auth.signInWithPassword({email,password});
    if(error) throw error;
  },
  async logout(){await sb.auth.signOut();}
};
function showLogin(){document.getElementById('loginView').classList.remove('hidden');document.getElementById('appView').classList.add('hidden')}
function showLoginError(text){const e=document.getElementById('loginError');e.textContent=text||''}
document.addEventListener('DOMContentLoaded',()=>{
 document.getElementById('loginForm').addEventListener('submit',async e=>{e.preventDefault();showLoginError('');const btn=e.submitter;btn.disabled=true;try{await GIBDD_AUTH.login(document.getElementById('loginEmail').value.trim(),document.getElementById('loginPassword').value)}catch(err){showLoginError(err.message||'Не удалось войти.')}finally{btn.disabled=false}});
 document.getElementById('logoutBtn').addEventListener('click',()=>GIBDD_AUTH.logout());
 GIBDD_AUTH.init();
});
