##### 0. 前準備 ========================================================
library(tidyverse)

load("~/Data/JAHEAD/Process_Files/data_after_12.rda")

##### 1. 公的ケアの変数を準備 =================================
# DKなどを欠損にして、数値型に変更する

recodePublicService <- function(data, variable){
    variable_new <- str_c(variable, "_n")
    data <- data %>% 
        # しばらくは文字列型で操作して、最後に数値型にする
        mutate(!!(variable_new) := case_when(.[[variable]]=="利用していない" ~ "0",
                                             .[[variable]]=="DK" ~ NA_character_,
                                             .[[variable]]=="DK/NA" ~ NA_character_,
                                             .[[variable]]=="非該当" ~ "0",
                                             TRUE ~ .[[variable]])) %>% 
        mutate(!!(variable_new) := as.numeric(.[[variable_new]]))
}

data_long <- recodePublicService(data_long, "use_dayservice")
data_long <- recodePublicService(data_long, "use_shortstay")
data_long <- recodePublicService(data_long, "use_homehelp")

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_long, file="~/Data/JAHEAD/Process_Files/data_after_13.rda")
rm(list = ls())