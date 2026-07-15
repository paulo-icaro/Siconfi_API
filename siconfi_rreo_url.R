# ================================ #
# === URL - API SICONFI (RREO) === #
# ================================ #

# --- Script by Paulo Icaro ---#


# ------------------------------ #
# --- Funcao Geradora de URL --- #
# ------------------------------ #
siconfi_rreo_url = function(an_exercicio, nr_periodo, co_tipo_demonstrativo, no_anexo, co_esfera, id_ente){
  url = 'https://apidatalake.tesouro.gov.br/ords/cdwhprd/siconfi/tt/rreo?'
  
  for(i in an_exercicio){
    for(j in id_ente){
      for(x in nr_periodo){
        for(y in no_anexo){
          url_rreo = paste0(url, 'an_exercicio=', i, '&',
                                 'nr_periodo=', x, '&',
                                 'co_tipo_demonstrativo=', co_tipo_demonstrativo, '&',
                                 'no_anexo=', co_tipo_demonstrativo, '-Anexo%20', y, '&',
                                 'co_esfera=', co_esfera, '&',
                                 'id_ente=', id_ente)
          return(url_rreo)
        }
      }
    }
  }
}