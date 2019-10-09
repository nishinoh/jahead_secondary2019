data {
    int C; // 子どもの情報
    int P; // 回答者のWave
    int<lower=0, upper=P> id_personyear_n[C];
    int<lower=0, upper=1> do_care_parents_adl[C]; //被説明変数
    int<lower=0, upper=1> ch_female[C]; //個人レベルの説明変数
    real<lower=0> ch_age[C];
    real<lower=0, upper=1> ch_working[C];
    real<lower=0, upper=4> ch_dist_living_l[C];
    real<lower=0> t_age[P]; //回答者の年齢
    int<lower=0, upper=1> t_female[P]; //回答者の性別(女性ダミー)
    int<lower=0, upper=6> lim_adl[P]; //ここから世帯単位の情報
    int<lower=0> num_hh_member[P]; //世帯の人数
    int<lower=0> use_dayservice_n[P]; //特に着目する説明変数
}

parameters {
    real b_0; // 全体切片
    real b_1; // 係数@子の性別
    real b_2; // 係数@子の年齢
    real b_3; // 係数@子の雇用形態
    real b_4; // 係数@子の住んでいる距離
    real bp_1; // 係数@回答者の年齢
    real bp_2; // 係数@回答者の性別(女性ダミー)
    real bp_3; // 係数@ニードの重さ
    real bp_4; // 係数@世帯の人数
    real bp_5; // 係数@デイケア利用
    real b_p[P];
    real<lower=0> sigma_p;
}

transformed parameters {
    real q[C];
    real x_p[P];
    for(p in 1:P)
        x_p[p] = bp_1*t_age[p] + bp_2*t_female[p] + bp_3*lim_adl[p] + bp_4*num_hh_member[p] + bp_5*use_dayservice_n[p] + b_p[p];
    for(c in 1:C)
        q[c] = inv_logit(b_0 + x_p[id_personyear_n[c]] +
                         b_1*ch_female[c] + b_2*ch_age[c] + b_3*ch_working[c] + b_4*ch_dist_living_l[c]);
}

model {
    for (p in 1:P)
        b_p[p] ~ normal(0, sigma_p);
    for (c in 1:C)
        do_care_parents_adl[c] ~ bernoulli(q[c]);
}
