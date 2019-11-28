library(rstan)
library(ggmcmc)

load("~/Data/JAHEAD/Process_Files/data_after_73a_74a.rda")
fit_model <- stan(file="src/78b_hierarchical_model_iadl_only_4levels.stan", data=list_stan_4levels, cores = 4, seed=1234,
                  iter = 25000, warmup = 5000, thin = 5)
save(fit_model, file="~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_iadl_only_4levels.rda")

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