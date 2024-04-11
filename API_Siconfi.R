# ================================================ #
# === FUNCAO DE COLETA DE DADOS DA API SICONFI === #
# ================================================ #

# --- Script by Paulo Icaro ---#



# ------------------------- #
# --- Links Importantes --- #
# ------------------------- #
# https://statplace.com.br/blog/trabalhando-com-api-no-r/
# https://technologyadvice.com/blog/information-technology/how-to-use-an-api/



# ---------------------------- #
# --- Packages e Libraries --- #
# ---------------------------- #
#install.packages(c('httr', 'httr2', 'jsonlite'))
library(httr)                               # Conectar com a API (Versao Base): https://httr.r-lib.org/
library(httr2)                              # Conectar com a API (Versao Moderna): https://httr2.r-lib.org/
library(jsonlite)                           # Converter dados Json para um Objeto
library(dplyr)                              # Biblioteca para manipulacao de dados



# ------------------------------ #
# --- API - Funcao de Coleta --- #
# ------------------------------ #

siconfi_api = function(url, httr = TRUE){
  
  
  # --- Conexao API - Utilizando httr --- #
  if(httr == TRUE){
      api_connection = GET(url = url)#, add_headers(toString(header_type)))       #Teste: Caso deseje especificar essa parte poupa trabalho ao utilizar o comando rwaToChar
      
      
      # --- Flag de Conexao --- #
      if(api_connection$status_code == 200){
        message('A conexao com a API foi bem sucedida! :)\nDados sendo coletados ...\n')
      }
      if(api_connection$status_code != 200){
        message('Problemas na conexao :(\nTentando acessar a API novamente ...\n')
        Sys.sleep(1)
        api_connection = GET(url = url)
      }
      if(api_connection$status_code != 200){
        message('Problemas na conexao :(\nTentando acessar a API uma última vez ...\n')
        Sys.sleep(10)
        api_connection = GET(url = url)
      }
      else{'Falha na conexao :(\nTente conectar com a API mais tarde'}
      
      api_connection = rawToChar(api_connection$content)
      api_connection = fromJSON(api_connection, flatten = TRUE)
      api_connection = api_connection$items
  }
  
  

  # --- Conexao API - Utilizando httr2 --- #
  # A especificacao dos parametros utilizando a funcao "req_url_query" e algo algo manual e nao muito pratico para utilizar em uma funcao, optei por emendar na main_url
   else{
     # -- Conexao com API -- # 
     api_connection =
       request(base_url = url) %>%
       #req_url_path_append(url = paste0(main_url, '?', param)) %>%              # Este trecho é para caso a url estivesse separada em base_url e main_url
       #req_url_query(id_ente='1718659', an_referencia='2014') %>%               # Teste: Caso deseje especificar manualmente
       req_perform()
     
     
     # -- Flag de conexao -- #
     if(api_connection$status_code == 200){
       message('A conexao com a API foi bem sucedida! :)\nDados sendo coletados ...\n')
     }
     if(api_connection$status_code != 200){
       message('Problemas na conexao :(\nTentando acessar a API novamente ...\n')
       Sys.sleep(1)
       api_connection = GET(url = paste0(base_url, main_url, '?', param), add_headers('application/json'))
     }
     if(api_connection$status_code != 200){
       message('Problemas na conexao :(\nTentando acessar a API uma última vez ...\n')
       Sys.sleep(10)
       api_connection = GET(url = paste0(base_url, main_url, '?', param), add_headers('application/json'))
     }
     else{'Falha na conexao :(\nTente conectar com a API mais tarde'}    
     
     # -- Conversão dos Dados  -- #
     api_connection = rawToChar(api_connection$body)
     api_connection = fromJSON(api_connection, flatten = TRUE)
     api_connection = api_connection$items
   }

  
  # --- Output --- #
  return(api_connection)
}