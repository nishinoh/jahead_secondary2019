##### 0. 前準備 ========================================================
library(tidyverse)
library(foreign)

load("~/Data/JAHEAD/Process_Files/data_after_01.rda")

##### 1. ====================================
items_adl <- c(str_c(rep("adl_sq",6), 1:6))
items_iadl <- c(str_c(rep("iadl_sq",4), 1:4))
items_ability <- c(str_c(rep("ability_sq", 7), 1:7))

# 
unclassFunctionalLimitation <- function(data, variable){
    data <- data %>% 
        # !!()と、括弧で囲う方が安全
        mutate(!!(variable) := recode(.[[variable]], `わからない` = NA_character_)) %>% 
        mutate(!!(variable) := unclass(.[[variable]])) %>%
        mutate(!!(variable) := .[[variable]] - 1)
        # 0からはじまり、数字が大きくなるほど、動作が難しい
}

# 上の関数を使って、Functional Limitationの変数を数値型に変えていく
for(item in items_adl){
    data_joint_allwaves <- unclassFunctionalLimitation(data_joint_allwaves, item)
}

for(item in items_iadl){
    data_joint_allwaves <- unclassFunctionalLimitation(data_joint_allwaves, item)
}

for(item in items_ability){
    data_joint_allwaves <- unclassFunctionalLimitation(data_joint_allwaves, item)
}

# ADLの制約度の合計点を作成
# ここはそれぞれの単純な合計点
data_joint_allwaves <- data_joint_allwaves %>% 
    mutate(lim_adl = select(., one_of(items_adl)) %>% 
                                rowSums(na.rm = FALSE),
           lim_iadl = select(., one_of(items_iadl)) %>% 
                                rowSums(na.rm = FALSE),
           lim_ability = select(., one_of(items_ability)) %>% 
                                rowSums(na.rm = FALSE))

