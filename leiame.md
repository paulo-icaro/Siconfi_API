# Obtendo dados do Siconfi via API


<!--------------->

<!--- PARTE 1 --->

<!--------------->

### Propósito

      Este pacote é uma valiosa ferramenta que facilita o acesso aos
relatórios RREO disponíveis na API do
[*Siconfi*](https://apidatalake.tesouro.gov.br/docs/siconfi). O pacote
dispõe de duas rotinas principais que são os scripts
[**Siconfi_RREO_URL**](https://github.com/paulo-icaro/Siconfi_API/blob/main/FG_URL_RREO.R)
e
[**Siconfi_RREO_API**](https://github.com/paulo-icaro/Siconfi_API/blob/main/API_Siconfi.R).
Enquanto a primeira rotina é responsável por gerar as URL’s onde os
dados estão disponíveis, a outra rotina recebe a URL gera e a utiliza
para acessar e coletar as informações disponíveis na API.  
      Juntamente a essas duas funções, um último script está disponível:
[**Siconfi_RREO_Query**](https://github.com/paulo-icaro/Siconfi_API/blob/main/Query_RREO.R).
Essa rotina combina as funcionalidades mencionadas executando uma
perfeita extração das informações.  
      Vejamos a seguir detalhadamente como cada script funciona.

<!--------------->

<!--- PARTE 2 --->

<!--------------->

### Siconfi_RREO_URL

<div class="function_card">

siconfi_url_rreo (an_exercicio, nr_periodo, co_tipo_demonstrativo,
no_anexo, co_esfera, id_ente)

</div>

      A função requer a especificação de alguns argumentos[^1]
necessários a extração das informações. A tabela abaixo contém o
detalhamento dos parâmetros.

[^1]: É importante atentar que todos os parâmetros devem ser
    especificados como string/character.
