window.GIBDD_INSPECTORS = {
  async getCurrent(){
    if(window.GIBDD_AUTH?.inspector) return window.GIBDD_AUTH.inspector;
    const {data,error}=await sb.from('inspectors').select('*').eq('user_id',(await sb.auth.getUser()).data.user.id).maybeSingle();
    if(error) throw error;
    return data;
  },
  async updateProfile(values){
    const current=await this.getCurrent();
    const {data,error}=await sb.from('inspectors').update(values).eq('id',current.id).select().single();
    if(error) throw error;
    window.GIBDD_AUTH.inspector=data;
    return data;
  }
};
