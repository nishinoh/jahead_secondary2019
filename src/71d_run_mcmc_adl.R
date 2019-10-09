library(rstan)

load("~/Data/JAHEAD/Process_Files/data_after_71.rda")
fit_model <- stan(file="src/71c_hierarchical_model_adl_2.stan", data=list_stan_adl, cores = 4, seed=1234)
save(fit_model, file="~/Data/Process_Files/share2018_aso/stan_result_varying_intercept_care1.rda")