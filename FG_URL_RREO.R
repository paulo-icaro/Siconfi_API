# ======================================= #
# === FUNCAO GERADORA DE URL's - RREO === #
# ======================================= #

# --- Script by Paulo Icaro ---#



# ------------------------------ #
# --- Funcao Geradora de URL --- #
# ------------------------------ #
url_rreo = function(an_exercicio, nr_periodo, co_tipo_demonstrativo, no_anexo, co_esfera, id_ente){
  url = 'http://apidatalake.tesouro.gov.br/ords/siconfi/tt/rreo'
  
  for(i in an_exercicio){
    for(j in id_ente){
      for(x in nr_periodo){
        for(y in no_anexo){
          main_url_param = paste0(url, '?',
                                  'an_exercicio=', i, '&',
                                  'nr_periodo=', x, '&',
                                  'co_tipo_demonstrativo=', co_tipo_demonstrativo, '&',
                                  'no_anexo=', co_tipo_demonstrativo, '-Anexo%20', y, '&',
                                  'co_esfera=', co_esfera, '&',
                                  'id_ente=', id_ente
                                  )
          
          return(main_url_param)
        }
      }
    }
  }
}
