// Quando a Agenda roda embutida no Portal do Núcleo, verifica se o navegador
// permite gravar cookies neste contexto. Se não permitir (Safari, bloqueio de
// cookies de terceiros), avisa o portal para oferecer "Abrir em nova aba".
export default defineNuxtPlugin(() => {
  if (window.self === window.top) return

  const nome = 'agenda_teste_embutido'
  document.cookie = `${nome}=1; Path=/; Max-Age=60; SameSite=None; Secure`
  const permitido = document.cookie.includes(`${nome}=1`)
  document.cookie = `${nome}=; Path=/; Max-Age=0; SameSite=None; Secure`

  window.parent.postMessage(
    { tipo: permitido ? 'nucleo:sessao-ok' : 'nucleo:sessao-bloqueada' },
    '*'
  )
})
