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

  join: vw_trust_time_interval {
    sql_on: ${vw_trust.key} = ${vw_trust_time_interval.key} ;;
    relationship: one_to_many
  }
  join: vw_trust_status_interval {
    sql_on: ${vw_trust.key} = ${vw_trust_status_interval.key} ;;
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
