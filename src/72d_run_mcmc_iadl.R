library(rstan)
library(ggmcmc)

load("~/Data/JAHEAD/Process_Files/data_after_70.rda")
fit_model_iadl <- stan(file="src/72b_hierarchical_model_iadl_1.stan", data=list_stan_adl, cores = 4, seed=1234,
                  iter = 10000, warmup = 5000, thin=5)
save(fit_model, file="~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_iadl1.rda")

# 結果の表示
fit_model_iadl
stan_trace(fit_model_iadl)
