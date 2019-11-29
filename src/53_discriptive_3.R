library(tidyverse)

load("~/Data/JAHEAD/Process_Files/data_after_41_data_frame.rda")
load("~/Data/JAHEAD/Process_Files/data_after_14.rda")

theme_set(theme_bw(base_size = 18, base_family = "HiraKakuProN-W3") +
              theme(axis.text=element_text(colour="black")))

# 1.  基本的な情報の作成 ==================================
N <- nrow(data_complete_cases)



# data_long(回答者のロングデータ)から分析に使われるケースのみ抜き出す
# 次の抜き出しでだけ利用する
tmp <- data_complete_cases %>%
    distinct(id_personyear)

data_complete_cases_personyear <- data_long %>% 
    filter(id_personyear %in% tmp$id_personyear)
rm(tmp)

##### 回答者単位の記述統計 ==============================

# ケース数
data_complete_cases_personyear %>% 
    count(wave, ques_type)

# アウトカムの分布
data_complete_cases %>% 
    count(do_care_parents_adl, do_care_parents_iadl, do_care_parents_iadl_only) %>% 
    mutate(r = n/N * 100)

# ADL・IADLの困難度の分布
p_lim_adl <- data_complete_cases_personyear %>% 
    count(lim_adl) %>% 
    ggplot(aes(x=factor(lim_adl), y=n)) +
        geom_bar(stat="identity", fill="#009FE1") +
        labs(x="ADLの困難度")

quartz(file="~/downloads/fig_lim_adl.pdf", type="pdf",  width=4,height=4)
p_lim_adl
dev.off()
    

p_lim_iadl <- data_complete_cases_personyear %>% 
    count(lim_iadl) %>% 
    ggplot(aes(x=factor(lim_iadl), y=n)) +
        geom_bar(stat="identity", fill="#009FE1") +
        labs(x="IADLの困難度")

quartz(file="~/downloads/fig_lim_iadl.pdf", type="pdf",  width=4,height=4)
p_lim_iadl
dev.off()

# デイサービス・ホームヘルプの利用頻度
p_use_dayservice <- data_complete_cases_personyear %>% 
    count(use_dayservice_n) %>% 
    ggplot(aes(x=factor(use_dayservice_n), y=n)) +
        geom_bar(stat="identity", fill="#009FE1") +
        labs(x="デイサービス利用頻度")

quartz(file="~/downloads/fig_use_dayservice.pdf", type="pdf",  width=4,height=4)
p_use_dayservice
dev.off()

p_use_homehelp <- data_complete_cases_personyear %>% 
    count(use_homehelp_n) %>% 
    ggplot(aes(x=factor(use_homehelp_n), y=n)) +
        geom_bar(stat="identity", fill="#009FE1") +
        labs(x="ホームヘルプ利用頻度")

quartz(file="~/downloads/fig_use_homehelp.pdf", type="pdf",  width=4,height=4)
p_use_homehelp
dev.off()
