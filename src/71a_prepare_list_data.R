##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(readr)

load("~/Data/JAHEAD/Process_Files/data_after_14.rda")
load("~/Data/JAHEAD/Process_Files/data_after_23.rda")

##### 1. 子どものデータを抜き出してリスト化 ======================================================
data_stan_child <- data_united %>% 
    select(id_personyear_child, id_personyear,
           ch_sex, ch_age, ch_married, ch_dist_living_l, ch_working,
           do_care_parents_adl) #ADLで支援のある人を抜き出す

data_stan_child <- data_stan_child %>% 
    mutate(ch_female = case_when(ch_sex == "男性" ~ 0,
                                 ch_sex == "女性" ~ 1),
           ch_married = case_when(ch_married == "はい" ~ 1,
                                  ch_married == "いいえ" ~ 0),
           ch_working = case_when(ch_working == "はい" ~ 1,
                                  ch_working == "いいえ" ~ 0)) %>% 
    select(id_personyear_child, id_personyear, ch_female, everything(), -ch_sex) %>% 
    filter(complete.cases(.))

list_stan_adl <- c(list(C = nrow(data_stan_child)),
                   as.list(data_stan_child))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_united, file="~/Data/JAHEAD/Process_Files/data_after_71.rda")
rm(list = ls())