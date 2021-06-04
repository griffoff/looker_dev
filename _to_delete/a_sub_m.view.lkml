# view: a_sub_m {
# derived_table: {
#   sql: with
#       min_dates as(
#       select sub.user_sso_guid
#       , sub.subscription_state
#       , max(sub.local_time)  as  local_time
#       from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENt sub
#       inner join  ${cu_vw_subscription_base.SQL_TABLE_NAME}  t on t.user_sso_guid = sub.user_sso_guid
#       group by sub.user_sso_guid, sub.subscription_state
#       )

#       , trial as (
#       select distinct sub.user_sso_guid
#       , m.local_time
#       , sub.SUBSCRIPTION_START
#       , sub.SUBSCRIPTION_END
#       , sub.SUBSCRIPTION_STATE
#       , sub.CONTRACT_ID
#       from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT sub
#       inner join  ${cu_vw_subscription_base.SQL_TABLE_NAME}  t on t.user_sso_guid = sub.user_sso_guid
#       inner join min_dates m on m.user_sso_guid = sub.user_sso_guid and m.local_time = sub.local_time
#       where sub.SUBSCRIPTION_STATE like 'trial_access'
#       and m.subscription_state like 'trial_access'

#       )

#       , _full as (
#       select distinct sub.user_sso_guid
#       , m.local_time
#       , sub.SUBSCRIPTION_START
#       , sub.SUBSCRIPTION_END
#       , sub.SUBSCRIPTION_STATE
#       , sub.CONTRACT_ID
#       from prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT sub
#       inner join  ${cu_vw_subscription_base.SQL_TABLE_NAME}  t on t.user_sso_guid = sub.user_sso_guid
#       inner join min_dates m on m.user_sso_guid = sub.user_sso_guid and m.local_time = sub.local_time
#       where sub.SUBSCRIPTION_STATE like 'full_access'
#       and m.subscription_state like 'full_access'

#       )
#       , only_trial as (
#       select distinct trial.user_sso_guid
#       , trial.local_time
#       , to_date(trial.SUBSCRIPTION_START) as _start
#       , to_date(trial.SUBSCRIPTION_END) as _end
#       , trial.SUBSCRIPTION_STATE
#       , trial.CONTRACT_ID
#       ,'Trial access users' as  status
#       , 'Unpaid' as paid_status
#       from trial
#       left outer join _full f on trial.user_sso_guid = f.user_sso_guid
#       where f.user_sso_guid is null
#       )

#       , only_full as (
#       select distinct _full.user_sso_guid
#       , _full.local_time
#       , to_date(_full.SUBSCRIPTION_START) as _start
#       , to_date(_full.SUBSCRIPTION_END) as _end
#       , _full.SUBSCRIPTION_STATE
#       , _full.CONTRACT_ID
#       , 'Full Access - Direct Purchase' as status
#       , case when _full.user_sso_guid in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020')) then 'PAC' else 'Commerce' end as paid_status
#       from _full
#       left outer join trial t on _full.user_sso_guid = t.user_sso_guid
#       where t.user_sso_guid is null
#       )

#       , two_state as (
#       select distinct _full.user_sso_guid
#       , _full.local_time
#       , to_date(_full.SUBSCRIPTION_START) as _start
#       , to_date(_full.SUBSCRIPTION_END) as _end
#       , _full.SUBSCRIPTION_STATE
#       , _full.CONTRACT_ID
#       , 'Full Access - Upgraded' as status
#       , case when _full.user_sso_guid in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020')) then 'PAC' else 'Commerce' end as paid_status
#       from _full
#       inner join trial t on t.User_sso_guid = _full.user_sso_guid
#       )

#       , days as (
#       SELECT DATEVALUE as day FROM DW_DEVMATH.DIM_DATE WHERE DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2))) ORDER BY DATEVALUE
#       )


#       ,_all as (
#       select * from only_trial
#       union
#       select * from only_full
#       union
#       select * from two_state
#       )

#       , res as (
#       select days.day
#       , _all.*
#       from _all, days
#       where _start <= days.day
#       and _end >= days.day
#       )

#       select * from res
# ;;
# }


# measure: count {
#   type: count
#   drill_fields: [detail*]
# }

#   measure: Number_of_users {
#     drill_fields: [detail*]
#     type: count_distinct
#     sql: ${user_sso_guid} ;;
#   }

# dimension: day {
#   type: date
#   sql: ${TABLE}."DAY" ;;
# }

# dimension: user_sso_guid {
#   type: string
#   sql: ${TABLE}."USER_SSO_GUID" ;;
# }

# dimension_group: local_time {
#   type: time
#   sql: ${TABLE}."LOCAL_TIME" ;;
# }

# dimension: _start {
#   type: date
#   sql: ${TABLE}."_START" ;;
# }

# dimension: _end {
#   type: date
#   sql: ${TABLE}."_END" ;;
# }

# dimension: subscription_state {
#   type: string
#   sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
# }

# dimension: contract_id {
#   type: string
#   sql: ${TABLE}."CONTRACT_ID" ;;
# }

# dimension: status {
#   type: string
#   sql: ${TABLE}."STATUS" ;;
# }

# dimension: paid_status {
#   type: string
#   sql: ${TABLE}."PAID_STATUS" ;;
# }

# set: detail {
#   fields: [
#     day,
#     user_sso_guid,
#     local_time_time,
#     _start,
#     _end,
#     subscription_state,
#     contract_id,
#     status,
#     paid_status
#   ]
# }
# }
