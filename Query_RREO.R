# ========================== #
# === SCRIPT DE CONSULTA === #
# ========================== #

# --- Script by Paulo Icaro --- #


# ================ #
# === Consulta === #
# ================ #

query_rreo = function(ano, periodo, co_tipo_demonstrativo, anexo = NULL, esfera = NULL, ente, consultar_github = TRUE){
  
  # -------------------------- #
  # --- Funcoes Auxiliares ---#
  # -------------------------- #
  if(consultar_github == TRUE){
    source('https://raw.githubusercontent.com/paulo-icaro/Siconfi_API/refs/heads/main/API_Siconfi.R')
    source('https://raw.githubusercontent.com/paulo-icaro/Siconfi_API/refs/heads/main/FG_URL_RREO.R')
  }
  
  # ---------------------------------- #
  # --- Variáveis de Armazenamento --- #
  # ---------------------------------- #
  rreo_url = dataset_rreo = NULL
  
  # ------------------------- #
  # --- Construção de URL --- #
  # ------------------------- #
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
    Sys.sleep(1)
    message(paste(w, 'download(s) de', length(rreo_url), ' \n', sep = ' '))
    if(w == length(rreo_url)){message('Todos os dados solicitados foram coletados !')}
  }  
  
  
  # ------------------------- #
  # --- Retornar os dados --- #
  # ------------------------- #
  return(dataset_rreo)
  
  
  # =============== #
  # === Limpeza === #
  # =============== #
  rm(ano, bimestre, ente, esfera, relatorio, tipo_demonstrativo)
}