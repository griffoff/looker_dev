view: vw_dig_info_detail {
  view_label: "DIG"
  sql_table_name: ZSS.VW_DIG_INFO_DETAIL ;;


  dimension: issue_type {
    type: string
    sql: ${TABLE}.issue_type ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
  }


  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }


  dimension: components {
    type: string
    sql: ${TABLE}.components ;;
  }


  dimension: product_type_or_environment {
    type: string
    sql: ${TABLE}.product_type_or_environment ;;
  }


dimension: summary {
  type: string
  sql:  ${TABLE}.summary ;;
}

  dimension: risk {
    type: string
    sql: ${TABLE}.risk ;;
  }


  dimension: portfolio {
    type: string
    sql: ${TABLE}.portfolio ;;
  }


  dimension: discipline {
    type: string
    sql: ${TABLE}.discipline ;;
  }


  dimension: sso_isbn_13 {
    type: string
    sql: ${TABLE}.sso_isbn_13 ;;
  }



  dimension: core_isbn {
    type: string
    sql: ${TABLE}.core_isbn ;;
  }

  dimension: copyright_year_new {
    type: string
    sql: ${TABLE}.copyright_year_new ;;
  }

  dimension: copyright_year {
    type: string
    sql: ${TABLE}.copyright_year ;;
  }

  dimension_group: estimated_start_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,

      month_num
    ]
    sql: ${TABLE}.estimated_start_date ;;
  }

  dimension_group: estimated_qa_start_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.estimated_qa_start_date ;;
  }

  dimension_group: in_production_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.in_production_date ;;
  }

  dimension_group: estimated_transmittal_dig_start_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.estimated_transmittal_dig_start_date ;;
  }

  dimension_group: due_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.due_date ;;
  }

  dimension_group: kpo_due_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.kpo_due_date ;;
  }

  dimension_group: last_closure_date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year,
      day_of_week,
      hour_of_day,
      week_of_year,
      day_of_month,
      month_num
    ]
    sql: ${TABLE}.last_closure_date ;;
  }


  dimension: key {
    type: string
    primary_key: yes
    sql: ${TABLE}.KEY ;;
  }


  measure: count {
    type: count
    drill_fields: [key, status, issue_type, risk]
    link: {
      label: "Look at Content Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Content%20Development%25"
    }
    link: {
      label: "Look at Software Aging Data"
      url: "https://cengage.looker.com/dashboards/37?Category=%25Software%25"

    }
  }
  #measure: count2 {
  #  type: count
  #  link: {
  #    label: "‘Drill Down Test’"
  #    url: "{{ sessions.count_bounce_sessions._link }}"
  #    icon_url: "http://www.looker.com/favicon.ico"
  #  }
  #}
}
