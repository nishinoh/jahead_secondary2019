library(rstan)
library(ggmcmc)

load("~/Data/JAHEAD/Process_Files/data_after_70.rda")
fit_model_adl_2services <- stan(file="src/75b_hierarchical_model_adl_4levels_2services.stan", data=list_stan_4levels, cores = 4, seed=1234,
                      iter = 25000, warmup = 5000, thin = 5)
save(fit_model_adl_2services, file="~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_adl_4levels_2services.rda")

fit_model_adl
# トレースプロット
stan_trace(fit_model_adl, inc_warmup = TRUE)
stan_trace(fit_model_adl)
# 事後分布
stan_dens(fit_model_adl, separate_chains = TRUE)
# 自己相関
stan_ac(fit_model_adl)
# R_hatの分布
stan_rhat(fit_model_adl)
# 実効サンプルサイズ
stan_ess(fit_model_adl)
