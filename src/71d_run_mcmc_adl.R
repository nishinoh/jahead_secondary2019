library(rstan)
library(ggmcmc)

load("~/Data/JAHEAD/Process_Files/data_after_71.rda")
fit_model <- stan(file="src/71c_hierarchical_model_adl_2.stan", data=list_stan_adl, cores = 4, seed=1234,
                  iter = 5000, warmup = 2500, thin=5)
save(fit_model, file="~/Data/JAHEAD/Process_Files/stan_result_varying_intercept_adl1.rda")
fit_model
stan_trace(fit_model)
