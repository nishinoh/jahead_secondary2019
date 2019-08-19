##### 0. 前準備 ========================================================
library(tidyverse)

load("~/Data/JAHEAD/Process_Files/data_after_11.rda")

##### 1. 私的ケアの変数を確認 =================================
# Waveごとにfactorの水準(言い回し程度)が異なっているので、揃える

# ADLについて助けてくれる人の存在
data_long <- data_long %>% 
    mutate(exist_helper_adl = recode(exist_helper_adl,
                                  `DK` = NA_character_,
                                  `DK/NA` = NA_character_,
                                  `NA` = NA_character_,
                                  `非該当` = NA_character_),
           exist_helper_adl = fct_relevel(exist_helper_adl,
                                       c("ほとんどいつもいた", "ときどきいた", "まれにいた",
                                         "いなかった", "必要なかった")))

# IADLについて助けてくれる人の存在
data_long <- data_long %>% 
    mutate(exist_helper_iadl = recode(exist_helper_iadl,
                                  `DK` = NA_character_,
                                  `DK/NA` = NA_character_,
                                  `NA` = NA_character_,
                                  `非該当` = NA_character_),
           exist_helper_iadl = fct_relevel(exist_helper_iadl,
                                       c("ほとんどいつもいた", "ときどきいた", "まれにいた",
                                         "いなかった", "必要なかった")))

# ADLやIADLなどについて助けてくれる人は誰か

data_long <- data_long %>% 
    mutate(who_helped_1_c = fct_collapse(who_helped_1,
                                         配偶者 = "配偶者",
                                         子ども = c("子ども", "息子", "娘", "複数の子ども"),
                                         子の配偶者 = c("嫁", "婿", "婿や嫁"),
                                         その他の親族 =c ("孫", "兄弟", "姉妹", "その他の親族", "その他親族"),
                                         ヘルパーや家政婦 = c("ヘルパーや家政婦", "ヘルパー・家政婦"),
                                         その他 = c("その他", "友達", "近隣の人"),
                                         DKNA = c("DK", "NA", "非該当")
                                         ),
           who_helped_1_c = fct_relevel(who_helped_1_c,
                                        c("配偶者", "子ども", "子の配偶者", "その他の親族", "ヘルパーや家政婦", "その他", "DKNA")),
           who_helped_1_c = recode(who_helped_1_c, `DKNA` = NA_character_))

data_long <- data_long %>% 
    mutate(who_helped_2_c = fct_collapse(who_helped_2,
                                         配偶者 = "配偶者",
                                         子ども = c("子ども", "息子", "娘", "複数の子ども"),
                                         子の配偶者 = c("嫁", "婿", "婿や嫁"),
                                         その他の親族 =c ("孫", "兄弟", "姉妹", "その他の親族", "その他親族"),
                                         ヘルパーや家政婦 = c("ヘルパーや家政婦", "ヘルパー・家政婦"),
                                         その他 = c("その他", "友達", "近隣の人"),
                                         DKNA = c("DK", "NA", "非該当")
    ),
    who_helped_2_c = fct_relevel(who_helped_2_c,
                                 c("配偶者", "子ども", "子の配偶者", "その他の親族", "ヘルパーや家政婦", "その他", "DKNA")),
    who_helped_2_c = recode(who_helped_2_c, `DKNA` = NA_character_))

##### Fin. 作成したファイルを保存 ================================================
# 作成したファイルを保存し、これまで作ったオブジェクトはいったん全て削除

save(data_long, file="~/Data/JAHEAD/Process_Files/data_after_12.rda")
rm(list = ls())