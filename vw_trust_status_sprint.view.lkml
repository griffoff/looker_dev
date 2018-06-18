view: vw_trust_status_sprint {
  view_label: "TRUST status for current sprint"
  derived_table: {
    sql:
      with histories as(
      select
      jsondata:key::string as id
      --, split_part(split_part(i.value::string, 'name=Sprint ', 2),',startDate=',1)::string as sprint
      --, split_part(split_part(i.value::string, ',startDate=', 2),',endDate=',1)::string as sprintstart
      , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
      , JSONDATA:fields:status:name::string as current_statuss
      ,  to_timestamp_tz(JSONDATA:fields:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as updated
      ,  to_timestamp_tz(j.value:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as modifyedtime
      ,  j.value:items as items
      from JIRA.RAW_JIRA_ISSUE , lateral flatten(input => JSONDATA:fields:customfield_12530) i
      , lateral flatten(input => JSONDATA:changelog:histories) j
        where contains(jsondata:key, 'TRUST-') ) --  or contains(jsondata:key, 'TRUST-2488')
-- select * from  histories ;
, status_changes as (
        select
      id
      ,modifyedtime
      ,i.value:toString::string as toString
      ,i.value:fromString::string  as fromString
      from histories, lateral flatten(input => items) i
      where i.value:field::string='status'
      group by    id , modifyedtime , toString, fromString
      union
  select
        id
        ,created as modifyedtime
        , 'Open' as toString
        , 'None' as fromString
      from histories
      order by modifyedtime     )
   --   select * from  status_changes ;
, status_changes_marked as ( -- marked by  modifyedtime
        select *
    , row_number() over (order by id, modifyedtime) as number_of_row
   from status_changes  )
, status_table as(
    select     t1.id
          ,t1.fromString as prev_status
          ,t1.toString as current_statuss
          ,t1.modifyedtime as begin_status
          ,t2.modifyedtime as end_status
    FROM status_changes_marked as t1
    LEFT  JOIN status_changes_marked as t2 ON t1.id=t2.id AND t1.number_of_row=(t2.number_of_row-1)
    )
, assignee_changes as (
    select
       id
       ,modifyedtime
      --,i.value:field::string as field
      --,i.value:fromString::string as fromString
       , case
            when i.value:fromString::string is null and i.value:toString::string is not null then 10
            when i.value:fromString::string is not null and i.value:toString::string is null then 1
            when i.value:fromString::string is not null and i.value:toString::string is not null then 11
            else 0 end as assigneer
       --,  i.value:toString::string as assigneer2
     from histories, lateral flatten(input => items) i
       where i.value:field::string='assignee'
       group by    id , modifyedtime , assigneer
      order by modifyedtime     )
, combo as (    select
        s.id
        , s.prev_status
        --, s.current_statuss
        , s.begin_status
        , s.end_status
        , a.MODIFYEDTIME
        , a.ASSIGNEER
    from status_table s
    left join assignee_changes a on s.id=a.id
     where current_statuss='QA Ready'
     )
, combo_last as (    select
        s.id
        --, s.prev_status
        , s.current_statuss
        , s.begin_status
        , s.end_status
        , a.MODIFYEDTIME
        , a.ASSIGNEER
    from status_table s
    left join assignee_changes a on s.id=a.id
     where PREV_STATUS='QA Ready'
     )
, new_dev_complete as(
  select
        id
        , MODIFYEDTIME
        , case when ASSIGNEER=10 then 'DevComplete' else 'QA Ready' end  as toSTRING
        , case when ASSIGNEER=1  then 'DevComplete' else 'QA Ready' end  as fromSTRING
  from combo where modifyedtime  between BEGIN_STATUS and END_STATUS and ASSIGNEER in (1,10)
  )
, combo_min as (
select
      id
      , begin_status
      , end_status
      , max (MODIFYEDTIME) as MODIFYEDTIME
from combo
  where MODIFYEDTIME<begin_status
  group by id       , begin_status      , end_status
  )
, new_row_min as (  select --- new_row_min: determine 'DevComplete' or 'QA Ready'
      c.id
      , c.begin_status as MODIFYEDTIME
      , case when c.ASSIGNEER>1 then 'DevComplete' else 'QA Ready' end  as TOSTRING
      , c.prev_status as FROMSTRING
      --, c.MODIFYEDTIME as
      from combo_min cm
      join combo c on cm.id=c.id and cm.begin_status=c.begin_status and  cm.MODIFYEDTIME=c.MODIFYEDTIME
  )
, combo_for_max as (
select
        t1.id
        , t2.modifyedtime as qa_time_status_many
        , t1.MODIFYEDTIME
    from new_dev_complete t1
     left join status_changes t2 on t1.id=t2.id and t1.modifyedtime<t2.modifyedtime and  t2.fromstring='QA Ready'
    )
, combo_max as (    select
        id
        ,qa_time_status_many
        , max(modifyedtime) as max_time
    from combo_for_max
    group by id, qa_time_status_many
    )
, new_row_max as (  select --- new_row_max time: determine from 'DevComplete' or 'QA Ready'
          c.id
          , c.begin_status as MODIFYEDTIME
          , c.current_statuss as TOSTRING
          , case when c.ASSIGNEER>1 then 'DevComplete' else 'QA Ready' end  as FROMSTRING
      from combo_max cm
        join combo_last c on cm.id=c.id and cm.qa_time_status_many=c.begin_status and  cm.max_time=c.MODIFYEDTIME
        )
  , new_status_changes as (
  select *
  from   status_changes   --new_dev_complete
  where  TOSTRING <> 'QA Ready'  and FROMSTRING<> 'QA Ready'
    union
  select * from new_dev_complete
    union
  select * from new_row_min
    union
  select * from     new_row_max
  )
  , new_status_changes_marked as ( -- marked by  modifyedtime
        select *
    , row_number() over (order by id, modifyedtime) as number_of_row
   from new_status_changes  )
, final as (    select     t1.id
          ,t1.toString as current_statuss
          ,t1.fromString as prev_status
          ,t1.modifyedtime as begin_status
          ,t2.modifyedtime as end_status
          , case when current_statuss in ('In Progress', 'DevComplete','Reopened') then 'Dev'
              when current_statuss in ('QA Ready','QA Active','Verified') then 'QA'
              else null
              end as jira_status_work
          , TIMEDIFF(minute, begin_status, end_status)/1440 as work_delta
          --, 1000 as work_delta
    FROM new_status_changes_marked as t1
    LEFT  JOIN new_status_changes_marked as t2 ON t1.id=t2.id AND t1.number_of_row=(t2.number_of_row-1)
  )
  select *
  , sum (work_delta) over ( PARTITION BY id, JIRA_STATUS_WORK) as total_time_table
  from final
   group by id, current_statuss, prev_status, begin_status, end_status, work_delta, jira_status_work
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

  dimension: previous_status {
    type: string
    sql: ${TABLE}.prev_status ;;
  }

  dimension: jira_status_work {
    type: string
    sql: ${TABLE}.jira_status_work ;;
  }

  dimension: work_delta {
    type: number
    sql: ${TABLE}.work_delta ;;
  }

  dimension: total_time_table {
    type: number
    sql: ${TABLE}.total_time_table    ;;
    value_format: "0.##"
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


  measure: count_Reopened {
    label: "# Reopened"
    type:  count_distinct
    sql: case when ${currentstatus_on_interval}='Reopened' then ${begin_status_raw} end;;
  }
  measure: total_time {
    type: max
    sql: ${TABLE}.total_time_table  ;;
    value_format: "0.##"
  }

}
