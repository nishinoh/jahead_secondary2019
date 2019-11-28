data {
    int C; // 子どもとその配偶者のケース数
    int P; // 回答者(パーソンイヤー)のケース数
    int<lower=0, upper=P> id_personyear_n[C];
    int<lower=0, upper=1> do_care_parents_iadl[C]; //被説明変数
    int<lower=0, upper=1> is_real_child[C]; //個人レベルの説明変数
    int<lower=0, upper=1> ch_female[C]; 
    real<lower=0, upper=4> ch_dist_living_l[C];
    // real<lower=0> t_age[P]; //回答者の年齢
    int<lower=0, upper=1> t_female[P]; //回答者の性別(女性ダミー)
    int<lower=0, upper=6> lim_iadl[P]; //ここから世帯単位の情報
    int<lower=0, upper=1> living_spouse[P]; //配偶者と住んでいるか
    int<lower=0> use_homehelp_n[P]; //特に着目する説明変数
}

parameters {
    real b_0; // 全体切片
    real bc_1; // 係数@子の子どもかは子の配偶者か
    real bc_2; // 係数@子の性別
    real bc_3; // 係数@子の住んでいる距離
    real bp_1; // 係数@回答者の性別(女性ダミー)
    real bp_2; // 係数@ニードの重さ
    real bp_3; // 係数@配偶者と住んでいるか
    real bp_4; // 係数@デイケア利用
    real ep[P];
    real<lower=0> sigma_p;
}

transformed parameters {
    real q[C];
    real ap[P];
    for(p in 1:P)
        ap[p] = b_0 + bp_1*t_female[p] + bp_2*lim_iadl[p] + bp_3*living_spouse[p] + bp_4*use_homehelp_n[p] + ep[p];
    for(c in 1:C)
        q[c] = inv_logit(ap[id_personyear_n[c]] + bc_1*is_real_child[c] + bc_2*ch_female[c] + bc_3*ch_dist_living_l[c]);
}

model {
    for (p in 1:P)
        ep[p] ~ normal(0, sigma_p);
    for (c in 1:C)
        do_care_parents_iadl[c] ~ bernoulli(q[c]);
}
