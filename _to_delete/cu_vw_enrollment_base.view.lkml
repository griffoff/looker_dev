# view: cu_vw_enrollment_base {
#   derived_table: {
#     sql: SELECT DISTINCT
#         first_value(e._hash) over (partition by e.user_sso_guid, e.course_key order by e.local_time) as _hash
#         -- e._hash
#         , e.access_role
#         , e.course_key
#         , to_date(first_value(e.local_time) over (partition by e.user_sso_guid, e.course_key order by e.local_time))  as local_time
#         --, MIN(e.local_time) AS local_time
#         , e.product_platform
#         , e.user_sso_guid
#         FROM
#           UNLIMITED.RAW_OLR_ENROLLMENT AS e
#         INNER JOIN prod.STG_CLTS.OLR_COURSES c
#             ON e.course_key = c."#CONTEXT_ID"
#         LEFT OUTER JOIN prod.unlimited.EXCLUDED_USERS exc
#             ON e.user_sso_guid = exc.user_sso_guid
#         WHERE
#         e.access_role like 'STUDENT'
#         and e.PLATFORM_ENVIRONMENT like 'production'
#         and e.USER_ENVIRONMENT like 'production'
#         and exc.user_sso_guid is null
#         and local_time > '2019-01-01'
#       ;;
#   }

#   dimension: _hash {
#     type: string
#     sql: ${TABLE}."_HASH" ;;
#   }


#   dimension: access_role {
#     type: string
#     sql: ${TABLE}."ACCESS_ROLE" ;;
#   }

#   dimension: course_key {
#     type: string
#     sql: ${TABLE}."COURSE_KEY" ;;
#   }

#   dimension_group: local_time {
#     type: time
#     sql: ${TABLE}."LOCAL_TIME" ;;
#   }




#   dimension: product_platform {
#     type: string
#     sql: ${TABLE}."PRODUCT_PLATFORM" ;;
#   }



#   dimension: user_sso_guid {
#     type: string
#     sql: ${TABLE}."USER_SSO_GUID" ;;
#   }

#   set: detail {
#     fields: [
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
