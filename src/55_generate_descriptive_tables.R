##### 0. 前準備 ========================================================
library(tidyverse)
library(stargazer)
library(xtable)

load("~/Data/JAHEAD/Process_Files/data_after_41_data_frame.rda")
load("~/Data/JAHEAD/Process_Files/data_after_14.rda") #ADLケアとIADLケアの被提供をみるため

dir <- "~/Dropbox/00_Projects/dropbox_jahead_secondary2019/tab/"

makeDiscriptiveTable <- function(data){
    # このデータは、集計する変数のみで構成すること
    data %>% 
        gather(key=key, value=value) %>% 
        group_by(key) %>% 
        summarise(N = n(),
                  Mean = mean(value),
                  SD = sd(value),
                  Min = min(value),
                  Max = max(value))
}

tab_i_level <-  data_complete_cases %>% 
    select(do_care_parents_adl, do_care_parents_iadl, is_real_child, ch_female) %>% 
    rename(ADLのケア提供 = do_care_parents_adl,
           IADLのケア提供 = do_care_parents_iadl,
           実子ダミー = is_real_child,
           女性ダミー = ch_female) %>% 
    makeDiscriptiveTable(.)

tab_c_level <- data_complete_cases %>% 
    distinct(id_personyear_child, .keep_all = TRUE) %>% 
    select(ch_dist_living_l) %>% 
    rename(居住場所の距離 = ch_dist_living_l) %>% 
    makeDiscriptiveTable()

tab_p_level <- data_complete_cases %>% 
    distinct(id_personyear, .keep_all = TRUE) %>% 
    select(lim_adl, lim_iadl, living_spouse, use_dayservice_d, use_homehelp_d) %>% 
    rename(親のADL困難度 = lim_adl,
           親のIADL困難度 = lim_iadl,
           親が配偶者と同居 = living_spouse,
           親がデイサービスを利用 = use_dayservice_d,
           親がホームヘルプを利用 = use_homehelp_d
           ) %>% 
    makeDiscriptiveTable()

tab_r_level <- data_complete_cases %>% 
    distinct(id_text, .keep_all = TRUE) %>% 
    select(t_female) %>% 
    rename(親の性別 = t_female) %>% 
    makeDiscriptiveTable()

discriptive_table <- tab_i_level %>% 
    bind_rows(tab_c_level, tab_p_level, tab_r_level) %>% 
    xtable(., label="tab_discriptive_table", caption = "記述統計量", digits = c(0,0,0,2,2,0,0))

print(discriptive_table, file=str_c(dir, "descriptive_statistics.tex"),
      caption.placement = "top", table.placement = "htbp", include.rownames = FALSE)

# as.data.frame(tmp) %>% 
    # stargazer(., out=str_c(dir, "test.tex"), title = "Iレベルの記述統計", style="ajs", omit.summary.stat = c("p75", "p25"))

#####  ======================================
data_complete_cases %>% 
    distinct(id_personyear, .keep_all=TRUE) %>% 
    names()

list <- data_complete_cases %>% 
    distinct(id_personyear)

# ADLのケアを受けている人と、IADLのケアを受けている人で4つに分けて人数を出す
data_long %>% 
    filter(id_personyear %in% list$id_personyear) %>% 
    mutate(exist_helper_adl_d = if_else(exist_helper_adl_l > 2, "ADLの介護者あり", "ADLの介護者なし"),
           exist_helper_iadl_d = if_else(exist_helper_iadl_l > 2, "IADLの介護者あり", "IADLの介護者なし")) %>% 
    count(exist_helper_adl_d, exist_helper_iadl_d)
# なぜか両方の質問でNAの人がいる。遡って検証
