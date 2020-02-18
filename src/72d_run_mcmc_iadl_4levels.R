library(rstan)
library(ggmcmc)

load("~/Data/JAHEAD/Process_Files/data_after_73a_74a.rda")
fit_model_iadl <- stan(file="src/74b_hierarchical_model_iadl_4levels.stan", data=list_stan_4levels, cores = 4, seed=1234,
                  iter = 25000, warmup = 5000, thin = 5)
save(fit_model_iadl, file="~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_iadl_4levels.rda")

fit_model_iadl
# トレースプロット
stan_trace(fit_model_iadl, inc_warmup = TRUE)
stan_trace(fit_model_iadl)
# 事後分布
stan_dens(fit_model_iadl, separate_chains = TRUE)
# 自己相関
stan_ac(fit_model_iadl)
# R_hatの分布
stan_rhat(fit_model_iadl)
# 実効サンプルサイズ
stan_ess(fit_model_iadl)