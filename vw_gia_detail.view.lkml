view: vw_gia_detail {
  view_label: "GIA detail"
  derived_table: {
    sql:
      with histories as(
      select
      jsondata:key::string as id
      , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
      , to_timestamp_tz(JSONDATA:fields:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as updated
      , JSONDATA:fields:summary::string as summary
      , JSONDATA:fields:status:name::string as current_status
      , JSONDATA:fields:fixVersions[0]:name::string as fixversions
      , JSONDATA:fields:issuetype:name::string as issuetype
      , JSONDATA:fields:status:statusCategory:name::string as statusCategory
      , JSONDATA:fields:resolution:name::string as resolution
      , JSONDATA:fields:labels::string as labels
      , JSONDATA:fields:customfield_10792::number as story_point
      , JSONDATA:fields:customfield_18730::string as order_in_sprint
      , JSONDATA:fields:customfield_13435:name::string as last_in_progress_user
      , split_part(split_part(i.value::string, 'name=ABIW - Sprint ', 2),' [',1)::string as sprint
      , split_part(split_part(i.value::string, ',startDate=', 2),',endDate=',1)::string as sprintstart
      , split_part(split_part(i.value::string, ',endDate=', 2),',completeDate=',1)::string as sprintend
      ,  to_timestamp_tz(j.value:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as modifyedtime
      ,to_date(modifyedtime) as modifyeddate
      ,  j.value:items as items
      from JIRA.RAW_JIRA_ISSUE , lateral flatten(input => JSONDATA:fields:customfield_12530) i
      , lateral flatten(input => JSONDATA:changelog:histories) j
        where contains(jsondata:key, 'GIA') and sprintend<>'<null>' and sprint>''      )
 , max_info as(
        select
      id
      , summary
      , created
      ,updated
      ,current_status
      ,fixversions
      ,issuetype
      , statusCategory
      ,resolution
      , labels
      ,story_point
      ,order_in_sprint
      ,last_in_progress_user
      ,sprint
      , to_timestamp_tz(sprintstart,'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM')  as sprintstart
      , to_timestamp_tz(sprintend,'YYYY-MM-DD"T"HH24:MI:SS.FFTZH:TZM')  as sprintend
      ,modifyedtime
      ,to_date(modifyedtime) as modifyeddate
      , i.value:field::string as field
      ,i.value:fromString::string as fromString
      ,i.value:toString::string as toString
      from histories, lateral flatten(input => items) i
      order by fromString      )
 , status_prep as(
        select
      id
      , max(modifyedtime) as  max_modifyedtime
      , i.value:field::string as field
      ,sprint
      from histories, lateral flatten(input => items) i
      where  to_date(modifyedtime) < to_date(sprintstart)  and field='status'
       group by  id,field ,sprint      )
 , status_before as(
        select
      status_prep.id
      , status_prep.max_modifyedtime
    , status_prep.sprint
      ,max_info.toString as status
      from status_prep
      left join max_info on status_prep.id=max_info.id     and status_prep.max_modifyedtime=max_info.modifyedtime
       and max_info.field='status'   and status_prep.sprint=max_info.sprint  )
  select         max_info.*
      , case when status_before.id is null then 'Open' else status_before.status end as start_status_sprint
     from status_before
 RIGHT OUTER  join max_info on status_before.id=max_info.id  and status_before.sprint=max_info.sprint
;;
  }

  dimension: key {
    type: string
    sql: ${TABLE}.id ;;
    link: {
      label: "Review in Jira"
      url: "https://jira.cengage.com/browse/{{value}}"
    }
  }

  dimension_group: created {
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
    sql: ${TABLE}.created ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
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
    sql: ${TABLE}.updated ;;
  }

  dimension_group: modifyedtime {
    type: time
    timeframes: [
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
    sql: ${TABLE}.modifyedtime ;;
  }

  dimension_group: sprintstart {
    type: time
    timeframes: [
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
    sql: ${TABLE}.sprintstart ;;
  }


  dimension_group: sprintend {
    type: time
    timeframes: [
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
    sql: ${TABLE}.sprintend ;;
  }

  dimension: summary {
    type: string
    sql: ${TABLE}.summary ;;
  }

  dimension: fixversions {
    type: string
    sql: ${TABLE}.fixversions ;;
  }

  dimension: issuetype {
    type: string
    sql: ${TABLE}.issuetype ;;
  }

  dimension: currentstatus {
    type: string
    sql: ${TABLE}.current_status ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: statusCategory {
    type: string
    sql: ${TABLE}.statuscategory ;;
  }

  dimension: resolution {
    type: string
    sql: ${TABLE}.resolution ;;
  }

  dimension: storypoint {
    type: number
    sql: ${TABLE}.story_point ;;
  }

  dimension: orderinsprint {
    type: string
    sql: ${TABLE}.order_in_sprint ;;
  }

  dimension: lastinprogress_user {
    type: string
    sql: ${TABLE}.last_in_progress_user ;;
  }

  dimension: sprint {
    type: string
    sql: ${TABLE}.sprint ;;
  }

  dimension: field {
    type: string
    sql: ${TABLE}.field ;;
  }

  dimension: startstatus {
    type: string
    sql: ${TABLE}.start_status_sprint ;;
  }

  dimension: OldString {
    type: string
    sql: ${TABLE}.fromString ;;
  }

  dimension: NewString {
    type: string
    sql: ${TABLE}.toString ;;
  }

  dimension: NewStatus {
    type: string
    sql: case when ${field}='status' then ${NewString} end  ;;
  }

  measure: count {
    type: count
    drill_fields: [key, field, OldString, NewString]
  }

  measure: latest_state {
    type: string
    sql: MAX(${NewStatus});;
    drill_fields: [key, field, OldString, NewString]
  }


}
