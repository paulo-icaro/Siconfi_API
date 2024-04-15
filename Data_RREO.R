# =============================================== #
# === COLETA E ARMAZENAMENTO DOS DADOS DA API === #
# =============================================== #

# --- Script by Paulo Icaro ---#



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
ente = 43
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
         rreo_url = rbind(rreo_url, param_rreo(i, x, tipo_demonstrativo, y, esfera, j))
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
receitas_correntes = dataset_rreo |> filter(cod_conta == 'ReceitasCorrentes')
receitas_capital = dataset_rreo |> filter(cod_conta == 'ReceitasDeCapital')
operacoes_credito = dataset_rreo |> filter(cod_conta == 'ReceitasDeOperacoesDeCredito')
investimentos_pagos = dataset_rreo |> filter(cod_conta == 'Investimentos')
inversoes_financeiras_pagas = dataset_rreo |> filter(cod_conta == 'InversoesFinanceiras')
despesas_correntes_pagas = dataset_rreo |> filter(cod_conta == 'DespesasCorrentes')
juros_pagos = dataset_rreo |> filter(cod_conta == 'JurosEEncargosDaDivida')
