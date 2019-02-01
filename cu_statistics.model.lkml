connection: "snowflake_prod"

include: "/bnoc/*.view.lkml"         # include all CU views in this project
include: "dim_date.view.lkml"
include: "/bnoc/cu*.dashboard.lookml"  # include all CU dashboards in this project

datagroup: enrollment_datagroup {
  sql_trigger: SELECT COUNT(*) FROM prod.UNLIMITED.RAW_OLR_ENROLLMENT ;;
  max_cache_age: "12 hours"
}

datagroup: subscription_datagroup {
  sql_trigger: SELECT COUNT(*) FROM prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT ;;
  max_cache_age: "12 hours"
}

datagroup: enrollment_test {
  sql_trigger: SELECT * FROM prod.UNLIMITED.RAW_OLR_ENROLLMEN;;
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
  persist_with: enrollment_test
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
  persist_with: subscription_datagroup
  # from: cu_raw_subscription_event
  label: "cu_raw_subscription_event"
}



## Derived views
explore: cu_vw_provisioned_product_base {
  # from: cu_vw_provisioned_product_base
  label: "cu_vw_provisioned_product_base"
}

explore: number_of_sub_per_day {
  # from: number_of_sub_per_day
  label: "number_of_sub_per_day"
}


explore: cu_vw_enrollment_base {
  # from: cu_vw_enrollment_base
  persist_for: "12 hour"
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

explore: cu_vw_subscription_base {
  # from: cu_vw_subscription_base
  label: "cu_vw_subscription_base"
}

## ORIGINAL




explore: prov_prod {
  # from: prov_prod
  label: "prov_prod"
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





explore: a_no_cu_pay {
  # from: a_no_cu_pay
  label: "a_no_cu_pay"
}


explore: a_sub_m {
  # from: a_sub_m
  label: "a_sub_m"
}


explore: cu_sub_per_day {
  from: cu_sub_per_day
  label: "cu_sub_per_day"
}


explore: cu_sub_per_day_3 {
  from: cu_sub_per_day_3
  label: "cu_sub_per_day_3"
}
explore: cu_vm_provisioned_product {
  from: cu_vm_provisioned_product
  label: "cu_vm_provisioned_product"
}

explore: cu_vw_enrollment_payments_30_new {
  persist_for: "8 hour"
  label: "cu_vw_enrollment_payments_30_new"
   join: cu_vw_enrollment_base {
     sql_on:  ${cu_vw_enrollment_payments_30_new.user_sso_guid} = ${cu_vw_enrollment_base.user_sso_guid} and ${cu_vw_enrollment_payments_30_new.course_key} = ${cu_vw_enrollment_base.course_key};;
    relationship: one_to_one
   }
  join: dim_date {
    sql_on: ${cu_vw_enrollment_base.local_time_date}<= ${dim_date.datevalue_date}
    and ${dim_date.datekey} BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2)));;
    relationship: one_to_one

  }
}
