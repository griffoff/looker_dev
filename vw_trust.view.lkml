view: vw_trust {
    view_label: "TRUST"
    derived_table: {
      sql:
      with histories as(
      select
        jsondata:key::string as id
      , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
      , to_timestamp_tz(JSONDATA:fields:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as updated
      , JSONDATA:fields:summary::string as summary
      , JSONDATA:fields:status:name::string as current_status
      , JSONDATA:fields:issuetype:name::string as issuetype
      , JSONDATA:fields:status:statusCategory:name::string as statusCategory
      , JSONDATA:fields:resolution:name::string as resolution
      , JSONDATA:fields:customfield_10792::float as story_point
      , JSONDATA:fields:customfield_18730::string as order_in_sprint
      , JSONDATA:fields:customfield_13435:name::string as last_in_progress_user
      , split_part(split_part(i.value::string, 'name=Sprint ', 2),',startDate=',1)::string as sprint
      , split_part(split_part(i.value::string, ',startDate=', 2),',endDate=',1)::string as sprintstart
      , split_part(split_part(i.value::string, ',endDate=', 2),',completeDate=',1)::string as sprintend
      ,  to_timestamp_tz(j.value:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as modifyedtime
      ,  to_date(modifyedtime) as modifyeddate
      ,  j.value:items as items
      from JIRA.RAW_JIRA_ISSUE , lateral flatten(input => JSONDATA:fields:customfield_12530) i
      , lateral flatten(input => JSONDATA:changelog:histories) j
        where sprintend <> '<null>' )
 , max_info as(
        select
        id
      , summary
      , created
      ,updated
      ,current_status
      ,issuetype
      , statusCategory
      ,resolution
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
       group by  id,field ,sprint         )
 , status_before as(
        select
      status_prep.id
      , status_prep.max_modifyedtime
    , status_prep.sprint
      ,max_info.toString as status
      from status_prep
      left join max_info on status_prep.id=max_info.id     and status_prep.max_modifyedtime=max_info.modifyedtime
       and max_info.field='status'    and status_prep.sprint=max_info.sprint )
  , data as (select         max_info.*
      , case when status_before.id is null then 'Open' else status_before.status end as start_status_sprint
     from status_before
 RIGHT OUTER  join max_info on status_before.id=max_info.id  and status_before.sprint=max_info.sprint)

 , f1 as (select data.id
 , data.sprint
 , case when ARRAY_CONTAINS('Closed'::variant, array_agg(distinct data.toString)) then 'yes' else 'no' end as isfinished
 from data
 where data.field like 'status'
 and to_date(data.SPRINTSTART) <= data.MODIFYEDDATE
 and to_date(data.sprintend) >= data.MODIFYEDDATE
 group by data.id , data.sprint)

 , f2 as (
 select data.id
 , data.sprint
 , 'no' as isfinished
 from data left outer join f1 on data.id = f1.id and data.sprint = f1.sprint
 where f1.sprint is null
)
, fin as (
select * from f1
union
select * from f2
)
, number_of_sprints as (
select fin.id
, array_size(array_agg(distinct fin.sprint)) as count_sprints
from fin
group by fin.id
)

 select data.*
 , fin.isfinished
 , ns.count_sprints
 , first_value(data.SPRINTSTART) over (partition by data.id order by data.SPRINTSTART)  as first_SPRINTSTART
 from data
 inner join fin on data.id = fin.id and data.sprint = fin.sprint
inner join  number_of_sprints ns on ns.id = data.id
   ;;
    }

# List of Jira's fields used here:

# components
# created
# key
# priority
# resolution
# resolutiondate
# status
# summary
# updated
#
#
# customfield_10792  as story_point
# customfield_12530  for sprint_info: name, start, stop
# customfield_13430  as last_closed
# customfield_13435  as last_in_progress_user
# customfield_13438  as last_resolved
# customfield_18730  as order_in_sprint
# customfield_24430  as acknowledged
# customfield_21431  as categories
# customfield_23432  as severity


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

  dimension: issuetype {
    type: string
    sql: ${TABLE}.issuetype ;;
  }

  dimension: currentstatus {
    type: string
    sql: ${TABLE}.current_status ;;
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

  dimension: isfinished {
    type: string
    sql: ${TABLE}."ISFINISHED" ;;
  }
  dimension_group: first_sprintstart {
    type: time
    sql: ${TABLE}."FIRST_SPRINTSTART" ;;
  }

  dimension: is_from_prev {
    type: yesno
    sql: ${sprintstart_date} > ${first_sprintstart_date};;
  }

  dimension: is_finished_now {
    type: yesno
    sql: ${currentstatus} like 'Closed';;
  }

  dimension: story_point_claster {
    type: number
    sql: case when ${storypoint} = 0 or ${storypoint} is null then 0--'[0 ; 0.5]'
    when ${storypoint} >= 0.1 and ${storypoint} <= 0.5 then 1--'[0.1 ; 0.5]'
    when ${storypoint} > 0.5 and ${storypoint} <= 1 then 2-- '(0.5 ; 1]'
    when ${storypoint} > 1 and ${storypoint} <= 2 then 3 --'(1 ; 2]'
    when ${storypoint} > 2 and ${storypoint} <= 3 then 4 --'(2 ; 3]'
    when ${storypoint} > 3 and ${storypoint} <= 5 then 5 -- '(3 ; 5]'
    when ${storypoint} > 5 and ${storypoint} <= 8 then 6 --'(5 ; 8]'
    when ${storypoint} > 8 and ${storypoint} <= 13 then 7 --'(8 ; 13]'
    when ${storypoint} > 13 then 8 end ;;
  }


  measure: count {
    type: count
    drill_fields: [key, field, OldString, NewString]
  }

  measure: count_prev{
    type: count_distinct
    filters: {
      field: is_from_prev
      value: "yes"
    }
    sql: ${key} ;;
    drill_fields: [key]
  }

  measure: number_of_sprints{
    type: sum_distinct
    sql_distinct_key: ${sprint};;
    sql: 1;;
    drill_fields: [key, storypoint]
  }

  measure: count_finished{
    type: count_distinct
    filters: {
      field: isfinished
      value: "yes"
    }
    sql: ${key} ;;
    drill_fields: [key]
  }

  measure: count_finished_generalzed{
    type: count_distinct
    filters: {
      field: currentstatus
      value: "Closed"
    }
    sql: ${key} ;;
    drill_fields: [key]
  }

  dimension: count_sprints {
    type: number
    sql: ${TABLE}."COUNT_SPRINTS" ;;
  }

  measure: count_0_storypoint{
    type: count_distinct
    filters: {
      field: storypoint
      value: "0"
    }
    sql: ${key} ;;
    drill_fields: [key]
  }

  measure: count_storypoints_in_sprint{
    type: sum_distinct
    sql_distinct_key: ${key};;
    sql: ${storypoint};;
    drill_fields: [key, storypoint]
  }

  measure: count_finished_storypoints{
    type: sum_distinct
    filters: {
      field: isfinished
      value: "yes"
    }
    sql_distinct_key: ${key};;
    sql: ${storypoint};;
    drill_fields: [key, storypoint]
  }

  measure: count_finished_storypoints_generalized{
    type: sum_distinct
    filters: {
      field: is_finished_now
      value: "yes"
    }
    sql_distinct_key: ${key};;
    sql: ${storypoint};;
    drill_fields: [key, storypoint]
  }

  measure: count_unfinished_storypoints{
    type: sum_distinct
    filters: {
      field: isfinished
      value: "no"
    }
    sql_distinct_key: ${key};;
    sql: ${storypoint};;
    drill_fields: [key, storypoint]
  }


  measure: count_tickets_in_sprint{
    type: count_distinct
    sql: ${key} ;;
    drill_fields: [key, storypoint]
  }



  measure: latest_state {
    type: string
    sql: MAX(${NewStatus});;
    drill_fields: [key, field, OldString, NewString]
  }


  }


# view: vw_trast_sprint {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
