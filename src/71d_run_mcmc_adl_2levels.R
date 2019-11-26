library(rstan)
library(ggmcmc)

load("~/Data/JAHEAD/Process_Files/data_after_70.rda")
fit_model <- stan(file="src/71b_hierarchical_model_adl_2levels.stan", data=list_stan_adl, cores = 4, seed=1234,
                  iter = 10000, warmup = 5000, thin=5)
save(fit_model, file="~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_adl_2levels.rda")
fit_model
# トレースプロット
stan_trace(fit_model, inc_warmup = TRUE)
stan_trace(fit_model)
# 事後分布
stan_dens(fit_model, separate_chains = TRUE)
# 自己相関
stan_ac(fit_model)
# R_hatの分布
stan_rhat(fit_model)
# 実効サンプルサイズ
stan_ess(fit_model)
