connection: "snowflake_prod"
label: "JIRA"

# include all the views
include: "*.view"

# include all the dashboards
include: "kpi.dashboard"
include: "escal.dashboard"

datagroup: escal_datagroup {
  sql_trigger: SELECT COUNT(*) FROM JIRA.RAW_JIRA_ISSUE ;;
  max_cache_age: "12 hours"
}


explore: vw_escal_detail {
  label: "Escals"
#used in dashboard-19. Will be deleted.
  join: vw_escal_categories {
    sql_on: ${vw_escal_detail.key} = ${vw_escal_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_escal_components {
    sql_on: ${vw_escal_detail.key} = ${vw_escal_components.key};;
    relationship: one_to_many
  }

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_escal_detail.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}

explore: vw_escal_detail_prod {
  persist_with: escal_datagroup
  label: "Escals_new"
#used in dashboard-104, 114. Will be used.
  join: vw_escal_categories_prod {
    sql_on: ${vw_escal_detail_prod.key} = ${vw_escal_categories_prod.key} ;;
    relationship: one_to_many
  }

  join: vw_escal_components_prod {
    sql_on: ${vw_escal_detail_prod.key} = ${vw_escal_components_prod.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_escal_detail_prod.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}

explore: vw_escal_report_totals {
  label: "Escals Report Totals"
}

# for work with ESCAL Summary Report
#  explore: vw_escal_detail_dummy {
#    label: "ESCAL Summary Report"
explore: vw_escal_detail_dummy{
  label: "ESCAL Summary Report PROD"

  join: vw_escal_issue_resolved {
    type: left_outer
    relationship: one_to_many
    sql_on: ${vw_escal_issue_resolved.issue_id} = ${vw_escal_detail_dummy.key} ;;
  }
}

# Table 'RAW_JIRA_ISSUE' is used  for optimized data collection of all jira's project
# View was test on DEV as 'vw_escal_detail_test_optimization'
explore: vw_escal_optimized {
  label: "Escal optimized"
}


# for work with TRUST
explore: vw_trust{
  label: "TRUST (PROD)"
  persist_for: "8 hour"
  join: vw_trust_time_interval {
    sql_on: ${vw_trust.key} = ${vw_trust_time_interval.key} ;;
    relationship: one_to_many
  }
  join: vw_trust_status_interval {
    sql_on: ${vw_trust.key} = ${vw_trust_status_interval.key} ;;
    relationship: one_to_many
  }
  join: vw_trust_status_sprint {
    sql_on:${vw_trust_status_sprint.key} = ${vw_trust.key}  ;;
    relationship: one_to_many
  }
}


# for work with GIA
explore: vw_gia_detail{
  persist_with: escal_datagroup
  label: "GIA (PROD)"

  join: vw_gia_time_interval {
    sql_on: ${vw_gia_detail.key} = ${vw_gia_time_interval.key} ;;
    relationship: one_to_many
  }
}

# for work with KPI-data from PROD
explore: vw_kpi_data{
  persist_for: "8 hour"
  label: "KPI status (PROD)"

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_kpi_data.MODIFIEDdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: vw_kpi_services {
    view_label: "KPI SERVICES"
    sql_on: ${vw_kpi_data.SERVICE_ID} = ${vw_kpi_services.SERVICE_ID} ;;
    relationship: one_to_one
  }
}

# for work with SSO GATE ACMS GATEDPL
explore: vw_sso{
  persist_with: escal_datagroup
  label: "SSO (PROD)"

  join: vw_sso_time_interval {
    sql_on: ${vw_sso.key} = ${vw_sso_time_interval.key} ;;
    relationship: one_to_many
  }
}

explore: escal_2 {
  from: escal_2
  persist_with: escal_datagroup
  label: "Escal-2"

  join: dim_date {
    view_label: "Date"
    sql_on: ${escal_2.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

}

explore: escal_2_total {
  from: escal_2_total
  persist_with: escal_datagroup
  label: "Escal-2-total"

  #join: vw_topsystem {
  #  view_label: "Cengage systems"
  #  sql_on:  ${vw_topsystem.systemname} =${escal_2_total.component};;
  #  relationship: many_to_many
  #}
}

explore: escal_2_top_systems {
  from: escal_2_top_systems
  persist_with: escal_datagroup
  label: "Escal-2-top-systems"
}

explore: escal_2_cloned {
  from: escal_2_cloned
  persist_with: escal_datagroup
  label: "Escal-2-cloned"

}

explore: raw_jira_issue_v {
  from: raw_jira_issue_v
  persist_with: escal_datagroup
  label: "raw_jira_issue_v"
}

explore: sub_event_ {
  from: sub_event_
  label: "sub_event_"
}

explore: vital_sourse {
  from: vital_sourse
  label: "vital_sourse"
}

explore: prov_prod {
  from: prov_prod
  label: "prov_prod"
}
explore: enroll {
  from: enroll
  label: "enroll"
}

explore: check_script {
  from: check_script
  label: "check_script"

}

explore: usage {
  from: usage
  label: "usage"

}

explore: cs_m {
  from: cs_m
  label: "cs_m"
}


explore: a_e_p {
  from: a_e_p
  label: "a_e_p"
}
explore: a_s_p {
  from: a_s_p
  label: "a_s_p"
}

explore: a_p_p {
  from: a_p_p
  label: "a_p_p"
}

explore: switch_state_prod {
  from: switch_state_prod
  label: "switch_state_prod"
}

explore: a_subscriptions {
  from: a_subscriptions
  label: "a_subscriptions"
}

explore: a_enrollent {
  from: a_enrollent
  label: "a_enrollent"
}

explore: aaa {
  from: aaa
  label: "aaa"
}
explore: a {
  from: a
  label: "a"
}

explore: a_enroll_problem {
  from: a_enroll_problem
  label: "a_enroll_problem"
}

explore: a_no_cu_pay {
  from: a_no_cu_pay
  label: "a_no_cu_pay"
}

explore: a_prov_problem {
  from: a_prov_problem
  label: "a_prov_problem"
}

explore: a_actv_problem {
  from: a_actv_problem
  label: "a_actv_problem"
}

explore: a_temporary_problem {
  from: a_temporary_problem
  label: "a_temporary_problem"
}

explore: a_sub_m {
  from: a_sub_m
  label: "a_sub_m"
}

explore: a_sub_m_ckecker {
  from: a_sub_m_ckecker
  label: "a_sub_m_ckecker"
}
