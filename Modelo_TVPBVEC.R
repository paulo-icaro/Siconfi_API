# =================================== #
# === ESTIMACAO DO MODELO TVPBVAR === #
# =================================== #

# ------------------- #
# --- Bibliotecas --- #
# ------------------- #
library(bvartools)
library(readxl)
library(aTSA) # adf test

# ---------------- #
# --- Data Set --- #
# ---------------- #
dataset = read_excel(path = 'Dados_RREO.xlsx', sheet = 'Microdados', range = anchored('B1', dim = c(NA, 6)), col_names = TRUE)

# ------------------- #
# --- Time Series --- #
# ------------------- #

#TVP_BVEC
endo_var_ts = ts(data = dataset[,4:6], frequency = 6, start = c(2019, 1))
adf_invest = adf.test(endo_var_ts[,1])
adf_caixa = adf.test(endo_var_ts[,2])
adf_divida = adf.test(endo_var_ts[,3])
eg_test = coint.test(y = endo_var_ts[,1], X = endo_var_ts[,2:3])


inputs = gen_vec(data = endo_var_ts, p = 1, r = 1, s = 1, const = 'unrestricted', tvp = TRUE, iterations = 2000, burnin = 20)
priors <- add_priors.bvecmodel(inputs,
                               coef = list(v_i = 1, v_i_det = 0.1, shape = 3, rate = 0.0001, rate_det = 0.01),
                               coint = list(v_i = 0, p_tau_i = 1, shape = 3, rate = 0.0001, rho = .999),
                               sigma = list(df = "k", scale = 1, mu = 0, v_i = 0.01, sigma_h = 0.05, constant = 0.0001))
posteriors = draw_posterior.bvecmodel(priors)
plot.bvec(posteriors, style = 2, type = 'hist', c_i = 0.95)






Inves#TVP_BVAR
dataset = gen_var(data = endo_var_ts, p = 1, s = 0,
                  deterministic = 'const', tvp = TRUE,
                  iterations = 50000, burnin = 5000)

adding_priors <- add_priors.bvarmodel(dataset,
                                      coef = list(v_i = 0, v_i_det = 0, const = 'mean', shape = 3, rate = 0.0001),
                                      sigma = list(df = 1, scale = .0001, shape = 3))

posteriors = draw_posterior.bvarmodel(adding_priors)

plot.bvar(posteriors, style = 2, type = 'hist')
