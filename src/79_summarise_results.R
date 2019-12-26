library(tidyverse)

load("~/Data/JAHEAD/Process_Files/estimated_parameters_adl.rda")
load("~/Data/JAHEAD/Process_Files/estimated_parameters_iadl_only.rda")

estimated_parameters_adl <-  estimated_parameters_adl %>% 
    # 図にするときの並び順となる情報を追加
    mutate(model = "ADL model",
           order = row_number())

estimated_parameters_iadl_only <- estimated_parameters_iadl_only %>% 
    # 図にするときの並び順となる情報を追加
    mutate(model = "IADL model",
           order = row_number())

fig_data <- estimated_parameters_adl %>% 
    bind_rows(estimated_parameters_iadl_only) %>% 
    # mutate(model = fct_relevel(model, c("ADL model", "IADL model"))) %>% 
    # 以下の処理はかなりアドホックなやり方(表示順を一部強引に変えるための処理)
    mutate(order = as.double(order),
           order = case_when(term == "bp_3" & model == "IADL model" ~ order + 0.5,
                             term == "bp_1" & model == "IADL model" ~ order + 0.5,
                             TRUE ~ order))

fig_data <- fig_data %>% 
    mutate(model = case_when(model == "ADL model" ~ "Model 1\n(ADL)",
                             model == "IADL model" ~ "Model 2\n(IADL)"))

# 不要な小数点を削除する関数。後でscale_y_continuous()の中で使う。
formatDicimals <- function(x,...) {
    format(x, ..., scientific = FALSE, drop0trailing = TRUE)
}

fig <- fig_data %>% 
    ggplot(aes(x=reorder(term_full, -order), y=med_odds, ymax=ymax_odds, ymin=ymin_odds,
               group=model, shape=model)) + 
    geom_pointrange(size = 1,
                    position = position_dodge2(width = 0.5, reverse = TRUE)) + # reverseでグループ内の順序逆転
    geom_hline(aes(yintercept = 1), size = .25, linetype = "dashed") +
    scale_y_continuous(trans="log", #軸を対数変換
                       breaks = c(0, 0.1, 0.25, 0.5, 1, 2, 4, 10), #軸に表示する数値を手動で設定
                       labels = formatDicimals) +
    coord_flip() + 
    labs(y="オッズ比") +
    theme_bw(base_size = 18, base_family = "HiraKakuProN-W3") +
    theme(axis.text=element_text(colour="black"),
          axis.title.y=element_blank()) +
    labs(group = "", shape = "")
print(fig)

# 報告書用の表示
quartz(file="~/Dropbox/00_Projects/dropbox_jahead_secondary2019/fig/fig_result_joint_paper.pdf", type="pdf",  width=10,height=8)
fig
dev.off()

# スライド用に少し調整
fig_slide <- fig + theme(legend.position = "top")

quartz(file="~/Dropbox/00_Projects/dropbox_jahead_secondary2019/fig/fig_result_joint_slide.pdf", type="pdf",  width=8,height=5.5)
fig_slide
dev.off()