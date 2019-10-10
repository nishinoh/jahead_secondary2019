library(rstan)
library(ggmcmc)

load("~/Data/JAHEAD/Process_Files/data_after_72.rda")
fit_model_iadl <- stan(file="src/72b_hierarchical_model_adl_2.stan", data=list_stan_adl, cores = 4, seed=1234,
                  iter = 2000, warmup = 1000, thin=5)
save(fit_model, file="~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_iadl1.rda")
fit_model
stan_trace(fit_model_iadl)
