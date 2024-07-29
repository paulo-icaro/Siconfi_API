# =============================================== #
# === COLETA E ARMAZENAMENTO DOS DADOS DA API === #
# =============================================== #

# --- Script by Paulo Icaro ---#


# ------------------- #
# --- Bibliotecas --- #
# ------------------- #
library(stringr)
library(openxlsx)



# ------------------------ #
# -- Funcoes Auxiliares -- #
# ------------------------ #
source('FG_URL_RREO.R')
source('API_Siconfi.R')


# ---------------- #
# -- Parametros -- #
# ---------------- #
ano = 2018:2023
bimestre = 1:6
ente = 42
relatorio = c('01', '03', '04', '06')
esfera = 'E'
tipo_demonstrativo = 'RREO'



# -------------------------------- #
# -- Variaveis de Armazenamento -- #
# -------------------------------- #
rreo_url = NULL
dataset_rreo = NULL



# ----------------------- #
# -- Geracao das URL's -- #
# ----------------------- #
for (i in ano){
  for (j in ente){
    for (x in bimestre){
      for (y in relatorio){
         rreo_url = rbind(rreo_url, url_rreo(i, x, tipo_demonstrativo, y, esfera, j))
      }
    }
  }
}



# ------------------------ #
# -- Extracao dos Dados -- # 
# ------------------------ #
for (w in 1:length(rreo_url)){
  dataset_rreo = rbind(dataset_rreo, siconfi_api(url = rreo_url[w]))
  Sys.sleep(2)
  message(paste(w, 'download(s) de', length(rreo_url), ' \n', sep = ' '))
  if(w == length(rreo_url)){message('Todos os dados solicitados foram coletados !')}
}


# -------------- #
# -- Rubricas -- #
# -------------- #

# --- Variaveis do Trabalho --- #
# Nivel #
caixa = dataset_rreo |> filter(cod_conta  == 'DisponibilidadeDeCaixaBruta' & (str_detect(coluna, 'Até o Bimestre 20') | str_detect(coluna, 'Até o Bimestre / 2018')))
divida_consolidada = dataset_rreo |> filter(cod_conta == 'DividaConsolidadaLiquida' & str_detect(coluna, 'Até o Bimestre'))
investimentos_pagos = dataset_rreo |> filter(cod_conta == 'Investimentos' & coluna == 'DESPESAS LIQUIDADAS ATÉ O BIMESTRE (h)')
receitas_correntes = dataset_rreo |> filter(cod_conta == 'ReceitasCorrentes' & coluna == 'Até o Bimestre (c)')
dataset = cbind(investimentos_pagos[c(1, 3, 6, 15)], caixa[c(15)], divida_consolidada[c(15)])


# Variavel/RCL #
investimentos_pagos_rc = investimentos_pagos[c(15)]/receitas_correntes[c(15)]
caixa_rc = caixa[c(15)]/receitas_correntes[c(15)]
divida_consolidada_rc = divida_consolidada[c(15)]/receitas_correntes[c(15)]
dataset = cbind(investimentos_pagos[c(1, 3, 6)], investimentos_pagos_rc, caixa_rc, divida_consolidada_rc)



colnames(dataset) = c('Exercício', 'Período', 'Cod. IBGE', 'Investimentos', 'Caixa', 'Divida')

# Outras Variaveis #
# receitas_correntes = dataset_rreo |> filter(cod_conta == 'ReceitasCorrentes')
# receitas_capital = dataset_rreo |> filter(cod_conta == 'ReceitasDeCapital')
# operacoes_credito = dataset_rreo |> filter(cod_conta == 'ReceitasDeOperacoesDeCredito')
# inversoes_financeiras_pagas = dataset_rreo |> filter(cod_conta == 'InversoesFinanceiras')
# despesas_correntes_pagas = dataset_rreo |> filter(cod_conta == 'DespesasCorrentes')
# juros_pagos = dataset_rreo |> filter(cod_conta == 'JurosEEncargosDaDivida')




# --------------------- #
# --- Armazenamento --- #
# --------------------- #
wb_rreo = createWorkbook(creator = 'pi')
addWorksheet(wb = wb_rreo, sheetName = 'Microdados')
writeData(wb = wb_rreo, sheet = 'Microdados', x = dataset, rowNames = TRUE)
saveWorkbook(wb = wb_rreo, file = 'Dados_RREO.xlsx', overwrite = TRUE)


# --------------- #
# --- Limpeza --- #
# --------------- #
rm(ano, bimestre, ente, esfera, i, j, relatorio, tipo_demonstrativo, w, x, y)
rm(caixa, divida_consolidada, investimentos_pagos, receitas_correntes)