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
relatorio = '01'
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
         rreo_url = rbind(rreo_url, param_rreo(i, x, tipo_demonstrativo, relatorio, esfera, j))
      }
    }
  }
}



# ------------------------ #
# -- Extracao dos Dados -- # 
# ------------------------ #
for (w in 1:length(rreo_url)){
  dataset_rreo = rbind(dataset_rreo, siconfi_api(url = rreo_url[w]))
  Sys.sleep(3)
  message(paste(w, 'download(s) de', length(rreo_url), ' \n', sep = ' '))
}