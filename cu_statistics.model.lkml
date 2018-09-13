connection: "snowflake_prod"

include: "/bnoc/*.view.lkml"         # include all CU views in this project
include: "dim_date.view.lkml"
include: "/bnoc/cu*.dashboard.lookml"  # include all CU dashboards in this project

datagroup: enrollment_datagroup {
  sql_trigger: SELECT COUNT(*) FROM prod.UNLIMITED.RAW_OLR_ENROLLMENT ;;
  max_cache_age: "12 hours"
}

## Base views
explore: cu_clts_excluded_users {
  # from: cu_clts_excluded_users
  label: "cu_clts_excluded_users"
}
explore: cu_enrollment_events {
  # from: cu_enrollment_events
  label: "cu_enrollment_events"
}
explore: cu_raw_olr_enrollment {
  persist_with: enrollment_datagroup
  # from: cu_raw_olr_enrollment
  label: "cu_raw_olr_enrollment"
}
explore: cu_raw_olr_extended_iac {
  # from: cu_raw_olr_extended_iac
  label: "cu_raw_olr_extended_iac"
}
explore: cu_raw_olr_provisioned_product {
  # from: cu_raw_olr_provisioned_product
  label: "cu_raw_olr_provisioned_product"
}
explore: cu_raw_subscription_event {
  # from: cu_raw_subscription_event
  label: "cu_raw_subscription_event"
}

## Derived views
explore: cu_vw_provisioned_product_base {
  # from: cu_vw_provisioned_product_base
  label: "cu_vw_provisioned_product_base"
}

explore: cu_vw_enrollment_base {
  # from: cu_vw_enrollment_base
  label: "cu_vw_enrollment_base"
}

explore: cu_vw_enrollment_payments {
  # from: cu_vw_enrollment_payments
  label: "cu_vw_enrollment_payments"
}

explore: cu_vw_enrollment_payments_30 {
  # from: cu_vw_enrollment_payments_30
  label: "cu_vw_enrollment_payments_30"
}

## ORIGINAL


explore: vital_sourse {
  # from: vital_sourse
  label: "vital_sourse"
}

explore: prov_prod {
  # from: prov_prod
  label: "prov_prod"
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


explore: aaa {
  # from: aaa
  label: "aaa"
}



explore: a_no_cu_pay {
  # from: a_no_cu_pay
  label: "a_no_cu_pay"
}


explore: a_sub_m {
  # from: a_sub_m
  label: "a_sub_m"
}

explore: a_sum_m_copy {
  from: a_sum_m_copy
  label: "a_sum_m_copy"
}

explore: cu_sub_per_day {
  from: cu_sub_per_day
  label: "cu_sub_per_day"
}
