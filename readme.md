# Obtendo dados do Siconfi via API


<!--------------->

<!--- PARTE 1 --->

<!--------------->

### Propósito

<p>

      Este pacote é uma valiosa ferramenta que facilita o acesso aos
relatórios RREO disponíveis na API do
[**Siconfi**](https://apidatalake.tesouro.gov.br/docs/siconfi). O pacote
dispõe de duas rotinas principais que são os scripts
[**siconfi_rreo_url**](https://github.com/paulo-icaro/Siconfi_API/blob/main/siconfi_rreo_url.R)
e
[**siconfi_rreo_api**](https://github.com/paulo-icaro/Siconfi_API/blob/main/siconfi_rreo_api.R).
Enquanto a primeira rotina é responsável por gerar as URL’s onde os
dados estão disponíveis, a outra rotina recebe a URL gera e a utiliza
para acessar e coletar as informações disponíveis na API.  
      Juntamente a essas duas funções, um último script está disponível:
[**siconfi_rreo_query**](https://github.com/paulo-icaro/Siconfi_API/blob/main/siconfi_rreo_query.R).
Essa rotina combina as funcionalidades mencionadas executando uma
perfeita extração das informações.  
      Vejamos a seguir detalhadamente como cada script funciona.

</p>

<!--------------->

<!--- PARTE 2 --->

<!--------------->

### Siconfi_RREO_URL

<!------------------------------------------->

<!--- Detalhamento Função Github Document --->

<!------------------------------------------->

``` r
siconfi_rreo_url (an_exercicio, nr_periodo, co_tipo_demonstrativo, no_anexo, co_esfera, id_ente)
```

<!------------------------------->

<!--- Detalhamento Função PDF --->

<!------------------------------->

<!-------------------------------->

<!--- Detalhamento Função HTML --->

<!-------------------------------->

<p>

      A função requer a especificação de alguns argumentos[^1]
necessários a extração das informações. A tabela abaixo contém o
detalhamento dos parâmetros.

| **Argumento** | **Descrição** | **Observação** |
|:---|:---|:---|
| an_exercicio | Ano de exercício do relatório. | Ex: 2026 |
| nr_periodo | Bimestre de referência. | Escolha um valor de 1 à 6. |
| co_tipo_demonstrativo | Tipo do demonstrativo | Escolha entre RREO ou RREO Simplificado. |
| no_anexo | Anexo associado ao demonstrativo |  |
| co_esfera | Esfera do ente | M (Municípios), E (Estados), U (União) ou C (Consórcios) |
| id_ente | Código identificador do ente federativo. | Ex: 23 (Ceará) |

Vejamos uma demonstração:
</p>

``` r
# -------------------------------- #
# --- Exemplo - Geração de URL --- #
# -------------------------------- #

# ---  Funções e Bibliotecas --- #
source('https://raw.githubusercontent.com/paulo-icaro/Siconfi_RREO_API/refs/heads/main/siconfi_rreo_url.R')
#source('Siconfi_RREO_URL.R')

# --- Argumentos --- #
ano = '2025'
bimestre = 6
tipo_demonstrativo = 'RREO'
anexo = '04'
esfera = 'E'
ente = '23'

# --- Criar URL --- #
siconfi_url = siconfi_rreo_url(ano, bimestre, tipo_demonstrativo, anexo, esfera, ente)
siconfi_url
```

    [1] "https://apidatalake.tesouro.gov.br/ords/cdwhprd/siconfi/tt/rreo?an_exercicio=2025&nr_periodo=6&co_tipo_demonstrativo=RREO&no_anexo=RREO-Anexo%2004&co_esfera=E&id_ente=23"

<!--------------->

<!--- PARTE 3 --->

<!--------------->

### Siconfi_RREO_API

<!------------------------------------------->

<!--- Detalhamento Função Github Document --->

<!------------------------------------------->

``` r
siconfi_rreo_api (url, httr = TRUE)
```

<!------------------------------->

<!--- Detalhamento Função PDF --->

<!------------------------------->

<!-------------------------------->

<!--- Detalhamento Função HTML --->

<!-------------------------------->

<p>

      Esta função se conecta a API do Siconfi utilizando uma das duas
funções de acesso: [**httr**](https://httr.r-lib.org/) ou
[**httr2**](https://httr.r-lib.org/). Independente da opção selecionada,
a função **siconfi_rreo_api** verifica os status[^2] de conexão HTTP.
Caso a conexão inicial falhe, ainda há três tentativas para obter uma
conexão válida.  
      Com respeito aos argumentos necessários, basta ao usuário informar
a ***url***. Opcionalmente, o usuário pode informar se deseja utilizar o
pacote *httr* (padrão) ou *httr2*.

      Vejamos uma demonstração:

</p>

``` r
# --------------------------------- #
# --- Exemplo - Conexão com API --- #
# --------------------------------- #

# ---  Funções e Bibliotecas --- #
source('https://raw.githubusercontent.com/paulo-icaro/Siconfi_RREO_API/refs/heads/main/siconfi_rreo_api.R')

siconfi_url = 'https://apidatalake.tesouro.gov.br/ords/cdwhprd/siconfi/tt/rreo?an_exercicio=2025&nr_periodo=6&co_tipo_demonstrativo=RREO&no_anexo=RREO-Anexo%2004&co_esfera=E&id_ente=23'
data = 1

# --- Extração --- #
siconfi_dataset = siconfi_rreo_api(url = siconfi_url, httr = TRUE)
head(siconfi_dataset[c(1,3,9,10,12,13,15)])
```

      exercicio periodo         anexo esfera                                 coluna
    1      2025       6 RREO-Anexo 04      E                PREVISÃO ATUALIZADA (a)
    2      2025       6 RREO-Anexo 04      E RECEITAS REALIZADAS ATÉ O BIMESTRE (b)
    3      2025       6 RREO-Anexo 04      E                PREVISÃO ATUALIZADA (a)
    4      2025       6 RREO-Anexo 04      E RECEITAS REALIZADAS ATÉ O BIMESTRE (b)
    5      2025       6 RREO-Anexo 04      E                PREVISÃO ATUALIZADA (a)
    6      2025       6 RREO-Anexo 04      E RECEITAS REALIZADAS ATÉ O BIMESTRE (b)
                                                   cod_conta      valor
    1              ReceitasCorrentesRPPSBrutasPrevidenciario 1111826929
    2              ReceitasCorrentesRPPSBrutasPrevidenciario 1411590711
    3  ReceitaDeContribuicoesDosSeguradosBrutaPrevidenciario  263657732
    4  ReceitaDeContribuicoesDosSeguradosBrutaPrevidenciario  310915754
    5 ReceitaDeContribuicoesDosSeguradoslAtivoPrevidenciario  199792365
    6 ReceitaDeContribuicoesDosSeguradoslAtivoPrevidenciario  248278060

<!--------------->

<!--- PARTE 4 --->

<!--------------->

### Siconfi_RREO_Query

<!------------------------------------------->

<!--- Detalhamento Função Github Document --->

<!------------------------------------------->

``` r
siconfi_rreo_query (ano, periodo, co_tipo_demonstrativo, relatorio = NULL, esfera = NULL, ente, consultar_github = TRUE)
```

<!------------------------------->

<!--- Detalhamento Função PDF --->

<!------------------------------->

<!-------------------------------->

<!--- Detalhamento Função HTML --->

<!-------------------------------->

<p>

      Por fim, a função **siconfi_rreo_query** une[^3] os atributos das
funções anteriores permitindo realizar uma consulta de maneira eficaz.
Aqui, o usuário terá de especificar os mesmos argumentos necessário para
a função **siconfi_rreo_url**. Além disso, por padrão a função está
programada para buscar essas duas funções auxiliares neste repositório.
Caso ocorra algum problema no acesso, é possivel, **mediante download**,
importar as funções do diretório local onde estão situadas para atingir
o mesmo objetivo.

      Vejamos uma demonstração:

</p>

``` r
# ------------------------------------------ #
# --- Exemplo - Extração das Informações --- #
# ------------------------------------------ #

# ---  Funções e Bibliotecas --- #
source('https://raw.githubusercontent.com/paulo-icaro/Siconfi_RREO_API/refs/heads/main/siconfi_rreo_query.R')

# --- Argumentos --- #
ano = '2025'
bimestre = 6
tipo_demonstrativo = 'RREO'
anexo = '04'
esfera = 'E'
ente = '23'


# --- Extração --- #
siconfi_dataset = siconfi_rreo_query(ano = ano, periodo = bimestre, co_tipo_demonstrativo = tipo_demonstrativo, relatorio = anexo, esfera = esfera, ente = ente, consultar_github = TRUE)
head(siconfi_dataset[c(1,3,9,10,12,13,15)])
```

      exercicio periodo         anexo esfera                                 coluna
    1      2025       6 RREO-Anexo 04      E                PREVISÃO ATUALIZADA (a)
    2      2025       6 RREO-Anexo 04      E RECEITAS REALIZADAS ATÉ O BIMESTRE (b)
    3      2025       6 RREO-Anexo 04      E                PREVISÃO ATUALIZADA (a)
    4      2025       6 RREO-Anexo 04      E RECEITAS REALIZADAS ATÉ O BIMESTRE (b)
    5      2025       6 RREO-Anexo 04      E                PREVISÃO ATUALIZADA (a)
    6      2025       6 RREO-Anexo 04      E RECEITAS REALIZADAS ATÉ O BIMESTRE (b)
                                                   cod_conta      valor
    1              ReceitasCorrentesRPPSBrutasPrevidenciario 1111826929
    2              ReceitasCorrentesRPPSBrutasPrevidenciario 1411590711
    3  ReceitaDeContribuicoesDosSeguradosBrutaPrevidenciario  263657732
    4  ReceitaDeContribuicoesDosSeguradosBrutaPrevidenciario  310915754
    5 ReceitaDeContribuicoesDosSeguradoslAtivoPrevidenciario  199792365
    6 ReceitaDeContribuicoesDosSeguradoslAtivoPrevidenciario  248278060

[^1]: É importante atentar que todos os parâmetros devem ser
    especificados como string/character.

[^2]: Uma conexão bem sucedida retorna um código 200, enquanto uma
    conexão mal-sucedida retorna um código 400 ou 404.

[^3]: Note que ao invocar a função **siconfi_rreo_query** fica
    dispensado chamar as demais
