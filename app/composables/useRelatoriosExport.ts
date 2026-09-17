import {
  montarDadosExcel,
  montarDadosPdf,
  montarWorkbook,
  type ExcelJSModule,
  type RelatorioExportPayload
} from '@/utils/relatoriosExport'

const MIME_XLSX = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

const baixarBlob = (blob: Blob, nomeArquivo: string): void => {
  const url = URL.createObjectURL(blob)
  const link = document.createElement('a')

  link.href = url
  link.download = nomeArquivo
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)

  URL.revokeObjectURL(url)
}

export const useRelatoriosExport = () => {
  const exportandoExcel = ref(false)
  const gerandoPdf = ref(false)
  const erroExportacao = ref<string | null>(null)

  const exportarExcel = async (payload: RelatorioExportPayload): Promise<boolean> => {
    if (!import.meta.client || exportandoExcel.value) {
      return false
    }

    exportandoExcel.value = true
    erroExportacao.value = null

    try {
      const modulo = await import('exceljs')
      const ExcelJS = ((modulo as { default?: ExcelJSModule }).default ?? modulo) as ExcelJSModule
      const dados = montarDadosExcel(payload)
      const workbook = montarWorkbook(ExcelJS, dados)
      const buffer = await workbook.xlsx.writeBuffer()

      baixarBlob(new Blob([buffer], { type: MIME_XLSX }), dados.nomeArquivo)
      return true
    } catch {
      erroExportacao.value = 'Não foi possível gerar o arquivo Excel.'
      return false
    } finally {
      exportandoExcel.value = false
    }
  }

  const gerarPdf = async (payload: RelatorioExportPayload): Promise<boolean> => {
    if (!import.meta.client || gerandoPdf.value) {
      return false
    }

    gerandoPdf.value = true
    erroExportacao.value = null

    try {
      const [{ jsPDF }, { autoTable }] = await Promise.all([
        import('jspdf'),
        import('jspdf-autotable')
      ])

      const dados = montarDadosPdf(payload)
      const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' })
      const margem = 12
      const larguraPagina = doc.internal.pageSize.getWidth()
      const alturaPagina = doc.internal.pageSize.getHeight()
      const larguraUtil = larguraPagina - margem * 2

      let y = margem + 4

      doc.setFont('helvetica', 'bold')
      doc.setFontSize(14)
      doc.text(dados.cabecalho.orgao, margem, y)
      y += 6

      doc.setFont('helvetica', 'normal')
      doc.setFontSize(10)
      doc.text(dados.cabecalho.setor, margem, y)
      y += 8

      doc.setFont('helvetica', 'bold')
      doc.setFontSize(12)
      doc.text(dados.cabecalho.titulo, margem, y)
      y += 7

      doc.setFont('helvetica', 'normal')
      doc.setFontSize(9)
      doc.text(`Período: ${dados.cabecalho.periodo}`, margem, y)
      y += 5
      doc.text(`Emitido em: ${dados.cabecalho.emitidoEm}`, margem, y)
      y += 5

      const filtros = doc.splitTextToSize(`Filtros: ${dados.cabecalho.filtros}`, larguraUtil)
      doc.text(filtros, margem, y)
      y += filtros.length * 5 + 2

      const resumoTexto = dados.resumo
        .map((item) => `${item.label}: ${item.value}`)
        .join('   |   ')
      const resumo = doc.splitTextToSize(`Resumo: ${resumoTexto}`, larguraUtil)
      doc.text(resumo, margem, y)
      y += resumo.length * 5 + 3

      autoTable(doc, {
        startY: y,
        head: [dados.colunas],
        body: dados.linhas,
        styles: { fontSize: 8, cellPadding: 1.8, overflow: 'linebreak', valign: 'top' },
        headStyles: { fillColor: [0, 71, 144], textColor: 255, fontStyle: 'bold' },
        alternateRowStyles: { fillColor: [248, 250, 252] },
        margin: { left: margem, right: margem, bottom: margem + 6 }
      })

      const totalPaginas = doc.getNumberOfPages()

      for (let pagina = 1; pagina <= totalPaginas; pagina += 1) {
        doc.setPage(pagina)
        doc.setFont('helvetica', 'normal')
        doc.setFontSize(8)
        doc.text(`Página ${pagina} de ${totalPaginas}`, larguraPagina - margem, alturaPagina - 6, {
          align: 'right'
        })
      }

      doc.save(dados.nomeArquivo)
      return true
    } catch {
      erroExportacao.value = 'Não foi possível gerar o PDF.'
      return false
    } finally {
      gerandoPdf.value = false
    }
  }

  const limparErroExportacao = () => {
    erroExportacao.value = null
  }

  return {
    exportandoExcel,
    gerandoPdf,
    erroExportacao,
    exportarExcel,
    gerarPdf,
    limparErroExportacao
  }
}
