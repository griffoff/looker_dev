view: vw_kpi_data {
  view_label: "KPI"
  sql_table_name: ESCAL.vw_kpi_data ;;

  dimension_group: MODIFIED {
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
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: MODIFIEDdatekey  {
    type: number
    sql: ${MODIFIED_year}*10000 + ${MODIFIED_month_num}*100 + ${MODIFIED_day_of_month} ;;

  }

  dimension: Product {
    type: string
    sql: ${TABLE}.SERVICE_NAME ;;
  }

  dimension: STATUS {
    type: string
    sql: ${TABLE}.SERVICE_STATUS ;;
  }

  dimension: GoodBadStatus {
    type: yesno
    sql:   (${STATUS} = 'Available')
      or (${STATUS} = 'Partial')
      or (${STATUS} = 'Critical') ;;
  }

  dimension: UnavailableStatus {
    type: string
    sql:   case when ${STATUS}='Blackout'
                OR ${STATUS}='Disabled'
                OR ${STATUS}='Unavailable'
                OR ${STATUS}='Indeterminate'
                then 'Unavailable' else ${STATUS} end;;
  }
  dimension: BLACKOUT_ENABLED {
    type: yesno
    sql: ${TABLE}.BLACKOUT_ENABLED ;;
  }

  dimension: HEALTH {
    type: number
    sql: ${TABLE}.LOCATION_HEALTH ;;
  }

  dimension: SERVICE_ID {
    type: number
    sql: ${TABLE}.SERVICE_ID ;;
  }


  measure: count_max_health {
    label: "Max health"
    type:  max
    sql:  ${HEALTH} ;;
    drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID ]
  }

  measure: count_min_health {
    label: "Min health"
    type:  min
    sql:  ${HEALTH} ;;
    drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID ]
  }


  measure: count_average_health {
    label: "Average health"
    type:  average
    sql:  ${HEALTH} ;;
    drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID ]
  }


  measure: count_median_health {
    label: "Median health"
    type:  median
    sql:  ${HEALTH} ;;
    drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID ]
  }


  measure: count {
    label: "Count"
    type: count
    drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID ]
    }

  }
