view: vw_trust_status_interval {
  view_label: "TRUST time interval with status"
  derived_table: {
    sql:
      with histories as(
      select
      jsondata:key::string as id
      , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
      , JSONDATA:fields:status:name::string as current_statuss
      ,  to_timestamp_tz(JSONDATA:fields:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as updated
      ,  to_timestamp_tz(j.value:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as modifyedtime
      ,  j.value:items as items
      from ZSS.RAW_JIRA_ISSUE , lateral flatten(input => JSONDATA:fields:customfield_12530) i
      , lateral flatten(input => JSONDATA:changelog:histories) j
        where contains(jsondata:key, 'TRUST') )
, status_changes as (
        select
      id
      ,modifyedtime
      ,i.value:toString::string as toString
      from histories, lateral flatten(input => items) i
      where i.value:field::string='status'
      group by    id , modifyedtime , toString
      union
  select
        id
      ,created as modifyedtime
      , 'Open' as toString
      from histories
      order by modifyedtime     )
, status_changes_marked as ( -- marked by  modifyedtime
        select *
    , row_number() over (order by id, modifyedtime) as number_of_row
   from status_changes  )
    select     t1.id
          ,t1.toString as current_statuss
          ,t1.modifyedtime as begin_status
          ,t2.modifyedtime as end_status
    FROM status_changes_marked as t1
    LEFT  JOIN status_changes_marked as t2 ON t1.id=t2.id AND t1.number_of_row=(t2.number_of_row-1)
    ;;
  }

  dimension: key {
    type: string
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: currentstatus_on_interval {
    type: string
    sql: ${TABLE}.current_statuss ;;
  }

  dimension_group: begin_status {
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
    sql: ${TABLE}.begin_status ;;
  }

  dimension_group: end_status {
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
    sql: ${TABLE}.end_status ;;
  }

  measure: count_date {
    type: count_distinct
    sql: ${currentstatus_on_interval};;
    # drill_fields: [key, currentstatus_on_interval, begin_status, end_status]
  }

  measure: WIP  {
    type: date_raw
    sql: min (case when ${end_status_raw} is not null then ${end_status_raw} end );;
  }

  measure: QA_start  {
    type: date_raw
    sql: max (case when ${currentstatus_on_interval}='QA Ready' or ${currentstatus_on_interval}='QA Active' then ${begin_status_raw} end);;
  }

  measure: Verified_start  {
    type: date_raw
    sql: max (case when ${currentstatus_on_interval}='Verified' or ${currentstatus_on_interval}='Completed' then ${begin_status_raw} end);;
    }

  measure: Last_Closed  {
    type: date_raw
    sql: max (case when ${currentstatus_on_interval}='Closed' then ${begin_status_raw} end);;
  }

  measure: QA_interval  {
    type: number
    sql: case when ${QA_start} is not null then round(TIMEDIFF(hour, ${WIP}, ${QA_start})/24,1)  end;;
  }

  measure: Verified_interval  {
    type: number
    sql: case when ${Verified_start} is not null then round(TIMEDIFF(hour, ${WIP}, ${Verified_start})/24,1)  end;;
  }

  measure: Closed_interval  {
    type: number
    sql: case when ${Last_Closed} is not null then round(TIMEDIFF(hour, ${WIP}, ${Last_Closed})/24,1)  end;;
  }

  measure: count_Reopened {
    label: "# Reopened"
    type:  count_distinct
    sql: case when ${currentstatus_on_interval}='Reopened' then ${begin_status_raw} end;;
  }

}
