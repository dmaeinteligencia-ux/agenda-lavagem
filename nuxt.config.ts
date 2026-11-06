export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: false },
  modules: ['@nuxtjs/tailwindcss', '@nuxtjs/supabase'],
  supabase: {
    redirectOptions: {
      exclude: ['/nova-reserva']
    },
    // SameSite=None permite manter a sessão quando a Agenda está embutida no Portal do Núcleo (iframe).
    cookieOptions: {
      maxAge: 60 * 60 * 8,
      sameSite: 'none',
      secure: true
    }
  }
})
