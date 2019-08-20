##### 0. 前準備 ========================================================
library(tidyverse)
library(plm)

load("~/Data/JAHEAD/Process_Files/data_after_14.rda")

theme_set(theme_bw(base_size = 14, base_family = "HiraKakuProN-W3") +
              theme(axis.text=element_text(colour="black")))

modules <- c("wave5_main", "wave6_main", "wave6_proxy", "wave7_main", "wave7_proxy")
descriptive_data <- data_long %>% 
    filter(module %in% modules)

##### 1. アウトカムのヒストグラム ==============================================

# ADLの手助け頻度(パーソンイヤー)
p <- data_long %>% 
    ggplot(aes(x=exist_helper_adl_l)) +
        geom_histogram(fill="#009FE1", bins=5) +
        labs(x="ADLの手助け頻度", y="")
print(p)
quartz(file="~/Downloads/fig_hist_adl.pdf", type="pdf", width=8,height=5)
p
dev.off()

# IADLの手助け頻度(パーソンイヤー)
data_long %>% 
    ggplot(aes(x=exist_helper_iadl_l)) +
    geom_histogram(fill="#009FE1", bins=5) +
    labs(x="IADLの手助け頻度", y="")

# ADLの固体内偏差
tmp <- data_long %>% 
    group_by(id) %>% 
    summarise(mean_adl = mean(exist_helper_adl_l, na.rm=TRUE))

p <- data_long %>% 
    left_join(tmp, by="id") %>% 
    mutate(dv_adl = exist_helper_adl_l - mean_adl) %>% 
    ggplot(aes(x=dv_adl)) +
    geom_histogram(fill="#009FE1", bins=5) +
    labs(x="ADLの手助け頻度の変化", y="")
print(p)

quartz(file="~/Downloads/fig_change_adl.pdf", type="pdf", width=8,height=5)
p
dev.off()


# IADLの固体内偏差
tmp <- data_long %>% 
    group_by(id) %>% 
    summarise(mean_iadl = mean(exist_helper_iadl_l, na.rm=TRUE))

data_long %>% 
    left_join(tmp, by="id") %>% 
    mutate(dv_iadl = exist_helper_iadl_l - mean_iadl) %>% 
    ggplot(aes(x=dv_iadl)) +
    geom_histogram(fill="#009FE1", bins=5) +
    labs(x="ADLの手助け頻度の変化", y="")

##### 2. その他基本情報確認 ===========================================
# ケース数(パーソンイヤー)
descriptive_data %>% 
    group_by(id) %>% 
    nrow()

# 平均の観測数
descriptive_data %>% 
    group_by(id) %>% 
    summarise(n = n()) %>% 
    summarise(mean_n = mean(n))

# Waveごとに各種サービスの利用度合いを比べてみる
# 特に、Wave5は介護保険開始前で、開始後にどう利用率が変わったかも見られる
data_long %>%
    filter(t_age == 85) %>% 
    group_by(wave) %>% 
    summarise(m = mean(use_dayservice_n, na.rm=T))