##### 0. 前準備 ========================================================
library(tidyverse)

load("~/Data/JAHEAD/Process_Files/data_after_13.rda")

##### 1. デモグラフィック情報を作成 =================================
# ラベルの共通化やカテゴリの再編を行う

# 年齢と性別
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

# 居住地の都市規模
data_long <- data_long %>% 
    mutate(city_size_c = fct_collapse(city_size,
                                      町村 = "町村",
                                      `10万未満の市` = "10万未満の市",
                                      `10万以上の市` = c("10万以上の市",  "20万以上の市"),
                                      政令市と特別区 = c("13大市（千葉）", "13大市（札幌、仙台、川崎、神戸、広島、福岡）",
                                                  "13大市（東京23区、大阪）", "13大市（横浜、名古屋、京都、北九州）",
                                                  "16大市（さいたま）", "16大市（千葉、堺）",
                                                  "16大市（札幌、仙台、川崎、静岡、神戸、広島、福岡）",
                                                  "16大市（東京23区、大阪）", "16大市（横浜、名古屋、京都、北九州）")
                                      )) %>% 
    mutate(city_size_c = fct_relevel(city_size_c, c("町村", "10万未満の市", "10万以上の市", "政令市と特別区")))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_long, file="~/Data/JAHEAD/Process_Files/data_after_14.rda")
rm(list = ls())