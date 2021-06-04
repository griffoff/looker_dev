# view: vw_trust_leadtime {
# derived_table: {
#   sql: with histories as(
#       select
#       jsondata:key::string as id
#       --, split_part(split_part(i.value::string, 'name=Sprint ', 2),',startDate=',1)::string as sprint
#       --, split_part(split_part(i.value::string, ',startDate=', 2),',endDate=',1)::string as sprintstart
#       , to_timestamp_tz(JSONDATA:fields:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as created
#       , JSONDATA:fields:status:name::string as current_statuss
#       ,  to_timestamp_tz(JSONDATA:fields:updated::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as updated
#       ,  to_timestamp_tz(j.value:created::string,'YYYY-MM-DD"T"HH24:MI:SS.FFTZHTZM') as modifyedtime
#       ,  j.value:items as items
#       from JIRA.RAW_JIRA_ISSUE , lateral flatten(input => JSONDATA:fields:customfield_12530) i
#       , lateral flatten(input => JSONDATA:changelog:histories) j)
# -- select * from  histories ;
# , status_changes as (
#         select
#       id
#       ,modifyedtime
#       ,i.value:toString::string as toString
#       ,i.value:fromString::string  as fromString
#       from histories, lateral flatten(input => items) i
#       where i.value:field::string='status'
#       group by    id , modifyedtime , toString, fromString
#       union
#   select
#         id
#         ,created as modifyedtime
#         , 'Open' as toString
#         , 'None' as fromString
#       from histories
#       order by modifyedtime     )
#   --   select * from  status_changes ;


# , status_changes_marked as ( -- marked by  modifyedtime -- the same but with number pf row
#         select *
#     , row_number() over (order by id, modifyedtime) as number_of_row
#   from status_changes  )


# , status_table as(
#     select     t1.id
#           ,t1.fromString as prev_status
#           ,t1.toString as current_statuss
#           ,t1.modifyedtime as begin_status
#           ,t2.modifyedtime as end_status
#     FROM status_changes_marked as t1
#     LEFT  JOIN status_changes_marked as t2 ON t1.id=t2.id AND t1.number_of_row=(t2.number_of_row-1)
#     )

# , first_last as(
# select distinct id
# , CURRENT_STATUSS
# , first_value(BEGIN_STATUS) over (partition by id, current_statuss order by BEGIN_STATUS)  as first_time
# , last_value(BEGIN_STATUS) over (partition by id, current_statuss order by BEGIN_STATUS)  as last_time
# from status_table
# )



# select f1.*
# , f2.first_time as open_time
# , first_value(f3.first_time) over (partition by f3.id order by f3.first_time)  as start_work_time
# from first_last f1
# inner join first_last f2 on f1.id = f2.id
# inner join first_last f3 on f1.id = f3.id
# where f2.current_statuss like 'Open'
# and f3.current_statuss not like 'Open'
# ;;
# }

# measure: count {
#   type: count
#   drill_fields: [detail*]
# }

# dimension: id {
#   type: string
#   sql: ${TABLE}."ID" ;;
# }

# dimension: current_statuss {
#   type: string
#   sql: ${TABLE}."CURRENT_STATUSS" ;;
# }

# dimension_group: first_time {
#   type: time
#   sql: ${TABLE}."FIRST_TIME" ;;
# }

# dimension_group: last_time {
#   type: time
#   sql: ${TABLE}."LAST_TIME" ;;
# }

#   dimension_group: open_time {
#     type: time
#     sql: ${TABLE}."OPEN_TIME" ;;
#   }
#   dimension_group: start_work_time {
#     type: time
#     sql: ${TABLE}."START_WORK_TIME" ;;
#   }


#   measure: time_beetween_open_and_status_first{
#     type: max
#     sql: datediff(hh, ${open_time_time}, ${first_time_time})/ 24 ;;
#     value_format: "0.##"
#     drill_fields: [detail*]
#   }

#   measure: time_beetween_open_and_status_last{
#     type: max
#     sql: datediff(hh, ${open_time_time}, ${last_time_time}) / 24 ;;
#     value_format: "0.##"
#     drill_fields: [detail*]
#   }

#   measure: BA_time{
#     type: max
#     sql: datediff(hh, ${open_time_time}, ${first_time_time}) / 24 ;;
#     filters: {
#       field: current_statuss
#       value: "Ready"
#     }
#     value_format: "0.##"
#     drill_fields: [detail*]
#   }

#   measure: BA_DEV_time{
#     type: max
#     sql: datediff(hh, ${open_time_time}, ${last_time_time}) / 24 ;;
#     filters: {
#       field: current_statuss
#       value: "Ready for QA"
#     }
#     value_format: "0.##"
#     drill_fields: [detail*]
#   }

#   measure: BA_DEV_QA_time{
#     type: max
#     sql: datediff(hh, ${open_time_time}, ${last_time_time}) / 24 ;;
#     filters: {
#       field: current_statuss
#       value: "Closed"
#     }
#     value_format: "0.##"
#     drill_fields: [detail*]
#   }


#   dimension: status_custom_sort {
#     label: "Status (Custom Sort)"
#     case: {
#       when: {
#         sql: ${current_statuss} = 'Open' ;;
#         label: "Open"
#       }
#       when: {
#         sql: ${current_statuss} = 'Refining' ;;
#         label: "Refining"
#       }
#       when: {
#         sql: ${current_statuss} = 'Ready' ;;
#         label: "Ready"
#       }
#       when: {
#         sql: ${current_statuss} = 'Reopened' ;;
#         label: "Reopened"
#       }
#       when: {
#         sql:${current_statuss} = 'In Progress' ;;
#         label: "In Progress"
#       }
#       when: {
#         sql: ${current_statuss} = 'Dev Complete' ;;
#         label: "Dev Complete"
#       }
#       when: {
#         sql: ${current_statuss} = 'Ready for QA' ;;
#         label: "Ready for QA"
#       }
#       when: {
#         sql: ${current_statuss} = 'In QA' ;;
#         label: "In QA"
#       }
#       when: {
#         sql: ${current_statuss} = 'Closed' ;;
#         label: "Closed"
#       }
#     }
#   }
# set: detail {
#   fields: [id, current_statuss, first_time_time, last_time_time]
# }
# }
