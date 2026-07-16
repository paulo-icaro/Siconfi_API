# ========================== #
# === SCRIPT DE CONSULTA === #
# ========================== #

# --- Script by Paulo Icaro --- #


# ================ #
# === Consulta === #
# ================ #

siconfi_rreo_query = function(ano, periodo, co_tipo_demonstrativo, relatorio = NULL, esfera = NULL, ente, consultar_github = TRUE){
  
  # -------------------------- #
  # --- Funcoes Auxiliares ---#
  # -------------------------- #
  if(consultar_github == TRUE){
    source('https://raw.githubusercontent.com/paulo-icaro/Siconfi_RREO_API/refs/heads/main/siconfi_rreo_api.R')
    source('https://raw.githubusercontent.com/paulo-icaro/Siconfi_RREO_API/refs/heads/main/siconfi_rreo_url.R')
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
      for (x in periodo){
        for (y in relatorio){
          rreo_url = rbind(rreo_url, siconfi_rreo_url(i, x, co_tipo_demonstrativo, y, esfera, j))
        }
      }
    }
  }
  
  # ------------------------ #
  # -- Extracao dos Dados -- # 
  # ------------------------ #
  for (w in 1:length(rreo_url)){
    dataset_rreo = rbind(dataset_rreo, siconfi_rreo_api(url = rreo_url[w]))
    Sys.sleep(1)
    message(paste(w, 'download(s) de', length(rreo_url), ' \n', sep = ' '))
    if(w == length(rreo_url)){message('Todos os dados solicitados foram coletados !')}
  }  
  
  
  # ------------------------- #
  # --- Retornar os dados --- #
  # ------------------------- #
  return(dataset_rreo)
}