##### 0. 前準備 ========================================================
library(tidyverse)

load("~/Data/JAHEAD/Process_Files/data_after_13.rda")

##### 1. デモグラフィック情報を作成 =================================
# DKなどを欠損にして、数値型に変更する

# 年齢と性別の変数を準備
data_long <- data_long %>% 
    mutate(t_gender = fct_collapse(t_gender,
                                   男性 = c("男性", "Male"),
                                   女性 = c("女性", "Female")
                                   )) %>% 
    # 年齢を計算する(生まれた年と調査の年から単純計算)
    mutate(int_year = case_when(wave == 5 ~ 1998,
                                wave == 6 ~ 2002,
                                wave == 7 ~ 2006),
           t_age = int_year - t_birth_y)

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_long, file="~/Data/JAHEAD/Process_Files/data_after_14.rda")
rm(list = ls())