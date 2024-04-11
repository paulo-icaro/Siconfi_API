# =============================================== #
# === COLETA E ARMAZENAMENTO DOS DADOS DA API === #
# =============================================== #


source('FG_URL_RREO.R')
source('API_Siconfi.R')




ano = 2018:2023
bimestre = 1:6
ente = 43
relatorio = 01
esfera = 'E'
tipo_demonstrativo = 'RREO'



rreo_url = NULL
for (i in ano){
  for (j in ente){
    for (x in bimestre){
      for (y in relatorio){
         rreo_url = rbind(rreo_url, param_rreo(i, x, tipo_demonstrativo, relatorio, esfera, j))
      }
    }
  }
}
