view: vw_dig_info_changelog {
  view_label: "DIG Changelog"
  sql_table_name: ZSS.vw_dig_status_time_interval ;;

  dimension: key {
    type: string
    hidden: yes
    sql: ${TABLE}.KEY ;;
  }


  dimension: ticket_status {
    type: string
    sql: ${TABLE}.ticket_status ;;
  }


  dimension_group: created_data_time {
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
    sql: ${TABLE}.start_date ;;
  }


  dimension_group: finished_data_time {
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
    sql: ${TABLE}.end_date ;;
  }


# Use for check
#  dimension: ticket_status_on_1505 {
#    type: yesno
#    sql: ( start_date<'2017-05-15' AND '2017-05-15'<end_date );;
#  }


#   For link 'created_data_time' with 'dim_date'
  dimension: createdatekey  {
    type: number
    sql: ${created_data_time_year}*10000 + ${created_data_time_month_num}*100 + ${created_data_time_day_of_month} ;;

  }


  measure: count {
    label: "changelog"
    type: count
    drill_fields: []
  }
}
