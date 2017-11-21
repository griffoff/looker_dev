view: vw_kpi_summary {
  view_label: "KPI summary"
  #  this table was used for table APPVIEW_STATUS
  # See http://wiki.cengage.com/display/CLOUD/AppNeta+PathView+API+Integration
  derived_table: {
    sql:
with main as (
 SELECT
  json_data:SERVICE_ID::number as SERVICE_ID
, json_data:APPVIEW_STATUS::string as APPVIEW_STATUS
, json_data:CHECK_UUID::string as CHECK_UUID
, to_timestamp_ntz(json_data:LAST_MODIFIED_DATE::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM')  as LAST_MODIFIED_DATE
, to_timestamp_ntz(json_data:MONITOR_DATE::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as MONITOR_DATE
, json_data:NAME::string as LOCATION_NAME
, json_data:BROWSER_TIME::number as BROWSER_TIME
, json_data:NETWORK_TIME::number as NETWORK_TIME
, json_data:SERVER_TIME::number as SERVER_TIME
, json_data:TOTAL_TIME::number as TOTAL_TIME
FROM ESCAL.raw_data_kpi )
, health as ( select
SERVICE_ID
,CHECK_UUID
, min (LAST_MODIFIED_DATE)  as LAST_MODIFIED_DATE
, count(APPVIEW_STATUS) as total_statuses
, count(APPVIEW_STATUS='OK') as ok_statuses
, case when total_statuses>0 then to_number(100*ok_statuses/total_statuses) else NULL end as LOCATION_HEALTH
, case when total_statuses=0 then TRUE else FALSE end as BLACKOUT_ENABLED
from main
GROUP BY SERVICE_ID,CHECK_UUID)
 -- SERVICE_ID --> SERVICE_NAME
select t1.SERVICE_ID
, t1.CHECK_UUID
, t1.LAST_MODIFIED_DATE
, t1.LOCATION_HEALTH
, t2.SERVISE as SERVICE_NAME
from health t1
 left join  ESCAL.KPI_SERVISES_ID t2 on t1.SERVICE_ID=t2.SERVICE_ID
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

  dimension: SERVICE_NAME {
    type: string
    sql: ${TABLE}.SERVICE_NAME ;;
  }

  dimension: CHECK_UUID {
    type: string
    sql: ${TABLE}.CHECK_UUID ;;
  }


  measure: count {
    label: "Count"
    type: count  #_distinct
    # sql: CONCAT(${CHECK_UUID},${LOCATION_NAME}) ;;
    drill_fields: [MODIFIED_raw, MONITORED_raw,  SERVICE_ID, SERVICE_NAME, CHECK_UUID]
  }


  }
