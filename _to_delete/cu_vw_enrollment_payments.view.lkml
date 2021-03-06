# view: cu_vw_enrollment_payments {
#   derived_table: {
#     sql: with
#       paid AS (
#         SELECT DISTINCT
#           CASE WHEN pp."source" like 'unlimited' THEN 'Paid via CU'
#             WHEN (pp."source" like 'gateway' AND pp.code_type like 'Site License User Access') THEN 'Paid via Gateway Site license'
#             WHEN (pp."source" is null AND  pp.code_type is null) THEN 'Paid via K12 Site License'
#             ELSE 'Other Payment' END AS report_status
#           , e._hash
#           , e.access_role
#           , e.course_key
#           , e.local_time
#           , e.product_platform
#           , e.user_sso_guid
#         FROM
#           ${cu_vw_enrollment_base.SQL_TABLE_NAME} e
#           INNER JOIN ${cu_vw_provisioned_product_base.SQL_TABLE_NAME} pp ON e.user_sso_guid = pp.user_sso_guid AND e.course_key = pp.context_id
#       )
#       , paid_no_cu AS (
#         SELECT DISTINCT
#           'Paid, without CU' as report_status
#           , e._hash
#           , e.access_role
#           , e.course_key
#           , e.local_time
#           , e.product_platform
#           , e.user_sso_guid
#         FROM
#           ${cu_vw_enrollment_base.SQL_TABLE_NAME} e
#           INNER JOIN prod.STG_CLTS.ACTIVATIONS_OLR_V a ON e.user_sso_guid = a.user_guid AND e.course_key = a.context_id
#           LEFT OUTER JOIN paid ON e.user_sso_guid = paid.user_sso_guid AND e.course_key = paid.course_key
#         WHERE
#           paid.user_sso_guid is null
#       )
#       , unpaid AS (
#         SELECT DISTINCT
#           'Unpaid' as report_status
#           , e._hash
#           , e.access_role
#           , e.course_key
#           , e.local_time
#           , e.product_platform
#           , e.user_sso_guid
#         FROM
#           ${cu_vw_enrollment_base.SQL_TABLE_NAME} e
#           LEFT OUTER JOIN paid ON e.user_sso_guid = paid.user_sso_guid AND e.course_key = paid.course_key
#           LEFT OUTER JOIN paid_no_cu ON e.user_sso_guid = paid_no_cu.user_sso_guid AND e.course_key = paid_no_cu.course_key
#         WHERE
#           paid.user_sso_guid is null
#           AND paid_no_cu.user_sso_guid is null
#       )
#       , _all AS (
#         SELECT * FROM paid
#         UNION
#         SELECT * FROM paid_no_cu
#         UNION
#         SELECT * FROM unpaid
#       )

#       SELECT * FROM _all

#       ;;
#     }

#   dimension: report_status {
#     type: string
#     sql: ${TABLE}."report_status" ;;
#   }

#   dimension: _hash {
#     type: string
#     sql: ${TABLE}."_hash" ;;
#   }


#   dimension: access_role {
#     type: string
#     sql: ${TABLE}."access_role" ;;
#   }

#   dimension: course_key {
#     type: string
#     sql: ${TABLE}."course_key" ;;
#   }

#   dimension_group: local_time {
#     type: time
#     sql: ${TABLE}."local_time" ;;
#   }



#   dimension: product_platform {
#     type: string
#     sql: ${TABLE}."product_platform" ;;
#   }


#   dimension: user_sso_guid {
#     type: string
#     sql: ${TABLE}."user_sso_guid" ;;
#   }

#   set: detail {
#     fields: [
#       report_status,
#       _hash,
#       access_role,
#       course_key,
#       local_time_time,
#       product_platform,
#       user_sso_guid
#     ]
#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }
# }
