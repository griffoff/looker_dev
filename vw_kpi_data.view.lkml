view: vw_kpi_data {
  view_label: "KPI"
 #  this table was used for table APPVIEW_STATUS
 # See http://wiki.cengage.com/display/CLOUD/AppNeta+PathView+API+Integration
 # sql_table_name: ESCAL.vw_kpi_data ;; # where LAST_MODIFIED_DATE>'2017-10-04T00:00:08.000Z'
  derived_table: {
    sql:
    SELECT
  json_data:SERVICE_ID::number as SERVICE_ID
, json_data:APPVIEW_STATUS::string as APPVIEW_STATUS
, json_data:CHECK_UUID::string as CHECK_UUID
,  to_timestamp_tz(json_data:LAST_MODIFIED_DATE::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as LAST_MODIFIED_DATE
,  to_timestamp_tz(json_data:MONITOR_DATE::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as MONITOR_DATE
, json_data:NAME::string as LOCATION_NAME
, json_data:BROWSER_TIME::number as BROWSER_TIME
, json_data:NETWORK_TIME::number as NETWORK_TIME
, json_data:SERVER_TIME::number as SERVER_TIME
, json_data:TOTAL_TIME::number as TOTAL_TIME
FROM ESCAL.raw_data_kpi
    ;;
  }


  dimension_group: MONITORED {
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
    sql: ${TABLE}.MONITOR_DATE ;;
  }


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

  dimension: SERVICE_ID {
    type: string
    sql: ${TABLE}.SERVICE_ID ;;
  }

  dimension: STATUS {
    type: string
    sql: ${TABLE}.APPVIEW_STATUS ;;
  }

  dimension: GoodBadStatus {
    type: yesno
    sql:   (${STATUS} = 'OK') ;;
  }

  dimension: CHECK_UUID {
    type: string
    sql: ${TABLE}.CHECK_UUID ;;
  }

  dimension: LOCATION_NAME {
    type: string
    sql: ${TABLE}.LOCATION_NAME ;;
  }


  dimension: BROWSER_TIME {
    type: number
    sql: ${TABLE}.BROWSER_TIME ;;
  }


  dimension: NETWORK_TIME {
    type: number
    sql: ${TABLE}.NETWORK_TIME ;;
  }


  dimension: SERVER_TIME {
    type: number
    sql: ${TABLE}.SERVER_TIME ;;
  }

  dimension: TOTAL_TIME {
    type: number
    sql: ${TABLE}.TOTAL_TIME ;;
  }


  measure: max_TOTAL_TIME {
    label: "Max TOTAL_TIME"
    type:  max
    sql:  ${TOTAL_TIME} ;;
  }

  measure: min_TOTAL_TIME {
    label: "Min TOTAL_TIME"
    type:  min
    sql:  ${TOTAL_TIME} ;;
  }


  measure: average_TOTAL_TIME {
    label: "Average TOTAL_TIME"
    type:  average
    sql:  ${TOTAL_TIME} ;;
  }


  measure: median_TOTAL_TIME {
    label: "Median TOTAL_TIME"
    type:  median
    sql:  ${TOTAL_TIME} ;;
  }


  measure: count {
    label: "Count"
    type: count
    drill_fields: [MODIFIED_raw, MONITORED_raw, STATUS, SERVICE_ID, CHECK_UUID, LOCATION_NAME, TOTAL_TIME]
  }

  }

# dimension_group: MODIFIED
# {
#     type: time
#     timeframes: [
#         raw,
#         time,
#         date,
#         week,
#         month,
#         month_name,
#         quarter,
#         year,
#         day_of_week,
#         hour_of_day,
#         week_of_year,
#         day_of_month,
#         month_num
#     ]
#     sql: ${TABLE}.LAST_MODIFIED_DATE;;
# }
#
# dimension: MODIFIEDdatekey
# {
#     type: number
#     sql: ${MODIFIED_year} * 10000 + ${MODIFIED_month_num} * 100 + ${MODIFIED_day_of_month};;
#
# }
#
# dimension: Product
# {
#     type: string
#     sql: ${TABLE}.SERVICE_NAME;;
# }
#
# dimension: STATUS
# {
#     type: string
#     sql: ${TABLE}.SERVICE_STATUS;;
# }
#
# dimension: GoodBadStatus
# {
#     type: yesno
#     sql: (${STATUS} = 'Available')
# or (${STATUS} = 'Partial')
# or (${STATUS} = 'Critical');;
# }
#
# dimension: UnavailableStatus
# {
#     type: string
#     sql: case when ${STATUS} = 'Blackout'
# OR ${STATUS} = 'Disabled'
# OR ${STATUS} = 'Unavailable'
# OR ${STATUS} = 'Indeterminate'
# then
# 'Unavailable' else ${STATUS}
# end;;
# }
# dimension: BLACKOUT_ENABLED
# {
#     type: yesno
#     sql: ${TABLE}.BLACKOUT_ENABLED;;
# }
#
# dimension: HEALTH
# {
#     type: number
#     sql: ${TABLE}.LOCATION_HEALTH;;
# }
#
# dimension: SERVICE_ID
# {
#     type: number
#     sql: ${TABLE}.SERVICE_ID;;
# }
#
#
# measure: count_max_health
# {
#     label: "Max health"
#     type: max
#     sql:  ${HEALTH};;
# drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID]
# }
#
# measure: count_min_health
# {
#     label: "Min health"
#     type: min
#     sql:  ${HEALTH};;
# drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID]
# }
#
#
# measure: count_average_health
# {
#     label: "Average health"
#     type: average
#     sql:  ${HEALTH};;
# drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID]
# }
#
#
# measure: count_median_health
# {
#     label: "Median health"
#     type: median
#     sql:  ${HEALTH};;
# drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID]
# }
#
#
# measure: count
# {
#     label: "Count"
#     type: count
#     drill_fields: [MODIFIED_raw, Product, BLACKOUT_ENABLED, HEALTH, STATUS, SERVICE_ID]
# }
