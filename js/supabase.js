/* Supabase client. Replace these two values with Project Settings -> API. */
const SUPABASE_URL = 'https://uzykxlznikjuakrwskrz.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_-OhOsi7WG9HA2S8WP02Qnw_gF9t_kO2';

window.sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
  auth: { persistSession: true, autoRefreshToken: true, detectSessionInUrl: true }
});
