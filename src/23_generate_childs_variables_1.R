##### 0. 前準備 ========================================================
# library(tidyverse)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(tibble)
library(readr)

load("~/Data/JAHEAD/Process_Files/data_after_22.rda")

##### 1. 親に対するケのあり方をあらわす変数を追加 =====================================
data_united <- data_united %>% 
    # 子ども番号から、親にケアを提供しているか否かを変数化
    # 番号が指し示す子どもが変数を通して一定であることが前提
    mutate(do_care_parents_primary = case_when((is_child == "子ども" & who_helped_1_c == "子ども" & ch_number == who_helped_1_ch_id) ~ 1,
                                               (is_child == "子の配偶者" & who_helped_1_c == "子の配偶者" & ch_number == who_helped_1_ch_id) ~ 1,
                                               TRUE ~ 0),
           do_care_parents_secondary = case_when((is_child == "子ども" & who_helped_2_c == "子ども" & ch_number == who_helped_2_ch_id) ~ 1,
                                                 (is_child == "子の配偶者" & who_helped_2_c == "子の配偶者" & ch_number == who_helped_2_ch_id) ~ 1,
                                                 TRUE ~ 0)) %>% 
    mutate(do_care_parents = case_when(do_care_parents_primary == 1 | do_care_parents_secondary == 1 ~ 1,
                                       is.na(who_helped_1_c) ~ NA_real_,
                                       TRUE ~ 0))

data_united %>% count(do_care_parents, wave)
data_united %>% group_by(id) %>% summarise(n=n())

data_united <- data_united %>% 
    # ADL・IADLどちらもニーズがなければサンプルから除外
    filter(needs_type != "どちらも不要") %>% 
    # 手助けしてくれたがいたかという質問で「必要なかった」「いなかった」という人は子の支援も0にする。
    # TODO 本当にこの処理で問題ないかあとで見直す。あと、さらに数ケースくらはNA消せるかも。
    mutate(do_care_parents = case_when(exist_helper_adl_l <= 2 & exist_helper_iadl_l <=2 ~ 0,
                                       TRUE ~ do_care_parents))

data_united <- data_united %>% 
    mutate(do_care_parents_adl = case_when(do_care_parents == 1 & exist_helper_adl_l >= 3 ~ 1,
                                           TRUE ~ 0)) %>% 
    mutate(do_care_parents_iadl = case_when(do_care_parents == 1 & exist_helper_iadl_l >= 3 ~ 1,
                                            TRUE ~ 0))

# data_united <- data_united %>% 
#     mutate(do_care_parents_adl = case_when(do_care_parents == 1 & needs_type == "どちらも必要" ~ 1,
#                                            do_care_parents == 1 & needs_type == "ADLだけ必要" ~ 1,
#                                            is.na(do_care_parents) ~ NA_real_,
#                                            TRUE ~ 0)) %>% 
#     mutate(do_care_parents_iadl = case_when(do_care_parents == 1 & needs_type == "IADLだけ必要" ~ 1,
#                                             is.na(do_care_parents) ~ NA_real_,
#                                             TRUE ~ 0))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_united, file="~/Data/JAHEAD/Process_Files/data_after_23.rda")
rm(list = ls())
