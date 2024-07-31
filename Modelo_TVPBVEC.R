# ==================================== #
# === ESTIMACAO DO MODELO TVP_BVEC === #
# ==================================== #



# ------------------- #
# --- Bibliotecas --- #
# ------------------- #
library(bvartools)        # Pacote para estimação de modelos bayesianos com parâmetros variando no tempo
library(readxl)           # Pacote para leitura de arquivos em Excel
library(aTSA)             # Pacote para cálculo da estacionariedade das variáveis



# ---------------- #
# --- Data Set --- #
# ---------------- #
dataset = read_excel(path = 'Dados_RREO.xlsx', sheet = 'Microdados', range = anchored('B1', dim = c(NA, 6)), col_names = TRUE)





# ------------------- #
# --- Time Series --- #
# ------------------- #
endo_var_ts = ts(data = dataset[,4:6], frequency = 6, start = c(2018, 1))         # Transformação das variáveis em objeto do tipo Time Series

adf_invest = adf.test(endo_var_ts[,1])                                            # Teste de Estacionariedade (Investimentos)
adf_caixa = adf.test(endo_var_ts[,2])                                             # Teste de Estacionariedade (Caixa)
adf_divida = adf.test(endo_var_ts[,3])                                            # Teste de Estacionariedade (Dívida)


# Inputs para estimacao #
inputs = gen_vec(data = endo_var_ts, p = 1, r = 1, s = 1, const = 'unrestricted', tvp = TRUE, iterations = 50000, burnin = 5000)


# Priors para estimacao #
# Obs: Foram utilizadas 50.000 simulacoes MCMC
priors <- add_priors.bvecmodel(inputs,
                               coef = list(v_i = 1, v_i_det = 0.1, shape = 3, rate = 0.0001, rate_det = 0.01),
                               coint = list(v_i = 0, p_tau_i = 1, shape = 3, rate = 0.0001, rho = .999),
                               sigma = list(df = "k", scale = 1, mu = 0, v_i = 0.01, sigma_h = 0.05, constant = 0.0001))


# Calculo das posteriors
posteriors = draw_posterior.bvecmodel(priors)


# Resumo das estimacoes
summary(posteriors)


# Plot dos resultados da estimação #
# Obs: cálculo das margens com 95% de confianca
plot.bvec(posteriors, style = 2, type = 'hist', ci = 0.95)