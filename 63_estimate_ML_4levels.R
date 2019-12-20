##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)
library(stringr)
library(lme4)

load("~/Data/JAHEAD/Process_Files/data_after_41_data_frame.rda")

data <- data_complete_cases %>% 
    mutate(id_text = str_c("R", id_text))

ans <- glmer(do_care_parents_adl ~ is_child + ch_sex + ch_dist_living_l + lim_adl + living_spouse + use_dayservice_d + t_gender +
                 (1|id_personyear/id_personyear_child),
             data = data,
             family = binomial(link = "logit"))
data

summary(ans)
