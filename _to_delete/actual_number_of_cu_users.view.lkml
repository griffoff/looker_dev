# view: actual_number_of_cu_users {
# derived_table: {
#   sql: with
# days as (
# SELECT DATEVALUE as day FROM DW_DEVMATH.DIM_DATE WHERE DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2))) ORDER BY DATEVALUE
# )


# , events as
# (SELECT distinct
# day
# , user_sso_guid
# , last_value(subscription_state) over (partition by user_sso_guid, day order by local_time) as last_state

# , last_value(local_time) over (partition by user_sso_guid, day order by local_time) as _local_time

# , last_value(SUBSCRIPTION_START) over (partition by user_sso_guid, day order by local_time) as _start

# ,last_value(SUBSCRIPTION_END) over (partition by user_sso_guid, day order by local_time) as _end

# , last_value(contract_id) over (partition by user_sso_guid, day order by local_time) as contract_id
# FROM ${cu_vw_subscription_base.SQL_TABLE_NAME} inner join days on local_time <= day
# )

# select * from events
#       ;;
# }

# measure: count {
#   type: count_distinct
#   sql: ${user_sso_guid} ;;
#   drill_fields: [detail*]
# }

# dimension: day {
#   type: date
#   sql: ${TABLE}."DAY" ;;
# }

# dimension: user_sso_guid {
#   type: string
#   sql: ${TABLE}."USER_SSO_GUID" ;;
# }

# dimension: last_state {
#   type: string
#   sql: ${TABLE}."LAST_STATE" ;;
# }

# dimension_group: _local_time {
#   type: time
#   sql: ${TABLE}."_LOCAL_TIME" ;;
# }

# dimension_group: _start {
#   type: time
#   sql: ${TABLE}."_START" ;;
# }

# dimension_group: _end {
#   type: time
#   sql: ${TABLE}."_END" ;;
# }

# dimension: contract_id {
#   type: string
#   sql: ${TABLE}."CONTRACT_ID" ;;
# }

#   dimension: states_custom_sort {
#     label: "States (Custom Sort)"
#     case: {
#       when: {
#         sql:  ${last_state}= 'banned' ;;
#         label: "banned"
#       }
#       when: {
#         sql: ${last_state} = 'cancelled' ;;
#         label: "cancelled"
#       }
#       when: {
#         sql: ${last_state} = 'no_access' ;;
#         label: "no_access"
#       }
#       when: {
#         sql: ${last_state} = 'provisional_locker' ;;
#         label: "provisional_locker"
#       }
#       when: {
#         sql:${last_state} = 'read_only' ;;
#         label: "read_only"
#       }
#       when: {
#         sql: ${last_state} = 'trial_access' ;;
#         label: "trial_access"
#       }
#       when: {
#         sql: ${last_state} = 'full_access' ;;
#         label: "full_access"
#       }
#     }
#     }

# set: detail {
#   fields: [
#     day,
#     user_sso_guid,
#     last_state,
#     _local_time_time,
#     _start_time,
#     _end_time,
#     contract_id
#   ]
# }
# }
