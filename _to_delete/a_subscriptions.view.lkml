# view: a_subscriptions {
#   derived_table: {
#     sql: with days as (
#       SELECT DATEVALUE as day FROM DW_DEVMATH.DIM_DATE WHERE DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2))) ORDER BY DATEVALUE
#                   )
#             , actual_sub as (
#             select sub.user_sso_guid
#             , max(sub.local_time) as local_time
#             from prod.unlimited.RAW_SUBSCRIPTION_EVENT sub left outer join prod.unlimited.CLTS_EXCLUDED_USERS exc on sub.user_sso_guid = exc.user_sso_guid
#             where exc.user_sso_guid is null
#             group by sub.user_sso_guid
#             )
#             , sub as (
#             select distinct days.day as day
#             , case when subscription_state like 'trial_access' then 'unpaid' else
#                 case  when (subscription_state like 'full_access'  and  actual_sub.user_sso_guid in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020'))) then 'PAC' else
#                   case when (subscription_state like 'full_access'and  actual_sub.user_sso_guid not in (select user_guid from prod.STG_CLTS.ACTIVATIONS_OLR_V where actv_isbn in ('9780357700006','9780357700013','9780357700020'))) then 'Commerce'
#                   end
#                 end
#             end as status
#             , actual_sub.user_sso_guid as user_sso_guid
#             , se.subscription_state as subscription_state
#             , se.contract_id as contract_id
#             , se.subscription_start as subscription_start
#             , se.subscription_end as subscription_end
#             , se._ldts
#             , se._rsrc
#             , se.message_format_version
#             , se.message_type
#             , se.platform_environment
#             , se.product_platform
#             , se.user_environment
#             , se._hash
#             from prod.unlimited.RAW_SUBSCRIPTION_EVENT as se , actual_sub, days
#             where actual_sub.user_sso_guid = se.user_sso_guid
#             and actual_sub.local_time = se.local_time
#             and se.subscription_start <= days.day
#             and se.subscription_end >= days.day
#             )


#             select * from sub
#       ;;
#   }
#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   measure: count_users {
#     type: count_distinct
#     sql: ${user_sso_guid} ;;
#     drill_fields: [detail*]
#   }

#   measure: count_trial {
#     type: count_distinct
#     sql: ${user_sso_guid} ;;
#     filters: {
#       field: subscription_state
#       value: "trial_access"
#     }
#     drill_fields: [detail*]
#   }



#   dimension: day {
#     type: date
#     sql: ${TABLE}."DAY" ;;
#   }

#   dimension: status {
#     type: string
#     sql: ${TABLE}."STATUS" ;;
#   }

#   dimension: user_sso_guid {
#     type: string
#     sql: ${TABLE}."USER_SSO_GUID" ;;
#   }

#   dimension: subscription_state {
#     type: string
#     sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
#   }

#   dimension: contract_id {
#     type: string
#     sql: ${TABLE}."CONTRACT_ID" ;;
#   }

#   dimension_group: subscription_start {
#     type: time
#     sql: ${TABLE}."SUBSCRIPTION_START" ;;
#   }

#   dimension_group: subscription_end {
#     type: time
#     sql: ${TABLE}."SUBSCRIPTION_END" ;;
#   }

#   dimension_group: _ldts {
#     type: time
#     sql: ${TABLE}."_LDTS" ;;
#   }

#   dimension: _rsrc {
#     type: string
#     sql: ${TABLE}."_RSRC" ;;
#   }

#   dimension: message_format_version {
#     type: number
#     sql: ${TABLE}."MESSAGE_FORMAT_VERSION" ;;
#   }

#   dimension: message_type {
#     type: string
#     sql: ${TABLE}."MESSAGE_TYPE" ;;
#   }

#   dimension: platform_environment {
#     type: string
#     sql: ${TABLE}."PLATFORM_ENVIRONMENT" ;;
#   }

#   dimension: product_platform {
#     type: string
#     sql: ${TABLE}."PRODUCT_PLATFORM" ;;
#   }

#   dimension: user_environment {
#     type: string
#     sql: ${TABLE}."USER_ENVIRONMENT" ;;
#   }

#   dimension: _hash {
#     type: string
#     sql: ${TABLE}."_HASH" ;;
#   }

#   set: detail {
#     fields: [
#       day,
#       status,
#       user_sso_guid,
#       subscription_state,
#       contract_id,
#       subscription_start_time,
#       subscription_end_time,
#       _ldts_time,
#       _rsrc,
#       message_format_version,
#       message_type,
#       platform_environment,
#       product_platform,
#       user_environment,
#       _hash
#     ]
#   }
# }
