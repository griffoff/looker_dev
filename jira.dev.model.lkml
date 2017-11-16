connection: "snowflake_dev"
label: "JIRA DEV"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: escals {
  from: vw_escal_detail
  label: "Alternative Escals"

  join: vw_escal_categories {
    fields: [] # hide all the fields
    sql_on: ${escals.key} = ${vw_escal_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_escal_components {
    fields: []  #hide all the fields
    sql_on: ${escals.key} = ${vw_escal_components.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    view_label: "Date"
    sql_on: ${escals.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: all_categories {
    sql: right join all_categories on ${vw_escal_categories.category} = ${all_categories.category} ;;
    relationship: one_to_many
  }

  join: all_priorities {
    sql: right join all_priorities on ${escals.priority} = ${all_priorities.priority} ;;
    relationship: one_to_many
  }

  join: all_products {
    sql: right join all_products on ${vw_escal_components.component} = ${all_products.product} ;;
    relationship: one_to_many
  }

}

explore: vw_escal_detail {
  label: "Escals"

  join: vw_escal_categories {
    sql_on: ${vw_escal_detail.key} = ${vw_escal_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_escal_components {
    sql_on: ${vw_escal_detail.key} = ${vw_escal_components.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    sql_on: ${vw_escal_detail.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: issue_status_last_month{
    sql_on: ${issue_status_last_month.key} = ${vw_escal_detail.key} ;;
    relationship: many_to_many
  }


}

#test dev table 'RAW_DATA_ISSUE_ALL' with optimize data collection
explore: vw_escal_detail_test {
  label: "Escals optimization test "

  join: vw_escal_categories {
    sql_on: ${vw_escal_detail_test.key} = ${vw_escal_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_escal_components {
    sql_on: ${vw_escal_detail_test.key} = ${vw_escal_components.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    sql_on: ${vw_escal_detail_test.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  #join: issue_status_last_month{
  #  sql_on: ${issue_status_last_month.key} = ${vw_escal_detail_test.key} ;;
  #  relationship: many_to_many
  #}
}


#test dev table 'RAW_JIRA_ISSUE' with optimize data collection for all jira's project
# View was move to PROD as 'vw_escal_optimized'
explore: vw_escal_detail_test_optimization {
  label: "Escals optimization test for all project"

#  join: vw_escal_categories {
#    sql_on: ${vw_escal_detail_test_optimization.key} = ${vw_escal_categories_test.key} ;;
#    relationship: one_to_many
#  }

#  join: vw_escal_components {
#    sql_on: ${vw_escal_detail_test_optimization.key} = ${vw_escal_components_test.key} ;;
#    relationship: one_to_many
#  }

  join: dim_date {
    sql_on: ${vw_escal_detail_test_optimization.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  #join: issue_status_last_month{
  #  sql_on: ${issue_status_last_month.key} = ${vw_escal_detail_test.key} ;;
  #  relationship: many_to_many
  #}
}



#For tickets from Jira's project NG: dev table 'RAW_JIRA_ISSUE' with optimize data collection for all jira's project
explore: vw_ng_detail {
  label: "NG project"
  join: dim_date {
    sql_on: ${vw_ng_detail.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}

# for work with DIG
explore: vw_dig_info_detail {
  label: "DIG"


  join: vw_dig_info_changelog {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_changelog.key} ;;
    relationship: one_to_many
  }

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_dig_info_changelog.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }

  join: issue_closures {
    type: left_outer
    relationship: many_to_many
    sql_on: ${issue_closures.issue_id} = ${vw_dig_info_detail.key} ;;
  }

  join: vw_dig_info_categories {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_categories.key} ;;
    relationship: one_to_many
  }

  join: vw_dig_info_components {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_components.key} ;;
    relationship: one_to_many
  }

  join: vw_dig_info_labels {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_labels.key} ;;
    relationship: one_to_many
  }

  join: vw_dig_info_inwardissue {
    sql_on: ${vw_dig_info_detail.key} = ${vw_dig_info_inwardissue.key} ;;
    relationship: one_to_many
  }

}

# for work with ESCAL Summary Report
#  explore: vw_escal_detail_dummy {
#    label: "ESCAL Summary Report"
explore: vw_escal_statuses{
    label: "ESCAL Summary Report"

    join: vw_escal_issue_resolved {
      type: left_outer
      relationship: one_to_many
      sql_on: ${vw_escal_issue_resolved.issue_id} = ${vw_escal_statuses.key} ;;
    }

}


# for work with ESCAL Summary Report
explore: vw_escal_detail_dummy{
  label: "ESCAL Summary Report DEV"
  join: vw_escal_issue_resolved {
    type: left_outer
    relationship: one_to_many
    sql_on: ${vw_escal_issue_resolved.issue_id} = ${vw_escal_detail_dummy.key} ;;
  }

}



# for work with ESCAL Summary Report
explore: vw_jira_status{
  label: "ESCAL jira status DEV"
}

# for work with ESCAL Summary Report
explore: tbl_jira_status{
  label: "ESCAL jira status vs date DEV"
}

# for work with ESCAL Summary Report
explore: tbl_jira_status_test{
  label: "ESCAL jira status for graph DEV"
}


# for work with KPI-data
explore: vw_kpi_data{
  label: "KPI status"

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



# for work with TRUST
explore: vw_trust{
  label: "TRUST"

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
  label: "GIA"

  join: vw_gia_time_interval {
    sql_on: ${vw_gia_detail.key} = ${vw_gia_time_interval.key} ;;
    relationship: one_to_many
  }
}

# for work with mc-graw hill
explore: vw_status_information_mgh {
  label: "SCRAPING INFORMATION MGH"

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_status_information_mgh.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}


# for work with  mc-graw hill
explore: vw_status_interval_mgh {
  label: "Issue time interval for Mc-Graw Hill"

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_status_interval_mgh.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}

# for work with pearson
explore: vw_status_information_prsn {
  label: "Scraping information pearson"

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_status_information_prsn.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}


# for work with pearson
explore: vw_status_interval_prsn {
  label: "Issue time interval for Pearson"

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_status_interval_prsn.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}


# for work with twitter
explore: vw_twitter {
  label: "Twitts"

  join: dim_date {
    view_label: "Date"
    sql_on: ${vw_twitter.createdatekey} = ${dim_date.datekey} ;;
    relationship: many_to_one
  }
}
