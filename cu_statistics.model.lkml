connection: "snowflake_prod"

include: "/bnoc/*.view.lkml"         # include all CU views in this project
include: "dim_date.view.lkml"
include: "/bnoc/cu_stats.dashboard.lookml"  # include all CU dashboards in this project

explore: sub_event_ {
  # from: sub_event_
  label: "sub_event_"
}

explore: vital_sourse {
  # from: vital_sourse
  label: "vital_sourse"
}

explore: prov_prod {
  # from: prov_prod
  label: "prov_prod"
}
explore: enroll {
  # from: enroll
  label: "enroll"
}

explore: check_script {
  # from: check_script
  label: "check_script"

}

explore: usage {
  # from: usage
  label: "usage"

}

explore: cs_m {
  # from: cs_m
  label: "cs_m"
}


explore: a_e_p {
  # from: a_e_p
  label: "a_e_p"
}
explore: a_s_p {
  # from: a_s_p
  label: "a_s_p"
}

explore: a_p_p {
  # from: a_p_p
  label: "a_p_p"
}

explore: switch_state_prod {
  # from: switch_state_prod
  label: "switch_state_prod"
}

explore: a_subscriptions {
  # from: a_subscriptions
  label: "a_subscriptions"
}

explore: a_enrollent {
  # from: a_enrollent
  label: "a_enrollent"
}

explore: aaa {
  # from: aaa
  label: "aaa"
}
explore: a {
  # from: a
  label: "a"
}

explore: a_enroll_problem {
  # from: a_enroll_problem
  label: "a_enroll_problem"
}

explore: a_no_cu_pay {
  # from: a_no_cu_pay
  label: "a_no_cu_pay"
}

explore: a_prov_problem {
  # from: a_prov_problem
  label: "a_prov_problem"
}

explore: a_actv_problem {
  # from: a_actv_problem
  label: "a_actv_problem"
}

explore: a_temporary_problem {
  # from: a_temporary_problem
  label: "a_temporary_problem"
}

explore: a_sub_m {
  # from: a_sub_m
  label: "a_sub_m"
}

explore: a_sub_m_ckecker {
  # from: a_sub_m_ckecker
  label: "a_sub_m_ckecker"
}
