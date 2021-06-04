# view: ra_prov_v2 {
# derived_table: {
#   sql: with success as (SELECT DATAVAULT.HUB_USER.UID as uid

#           , DATAVAULT.SAT_PROVISIONED_PRODUCT.DATE_ADDED as prod_DATE_ADDED
#           , DATAVAULT.SAT_PROVISIONED_PRODUCT.EXPIRATION_DATE as prod_EXPIRATION_DATE
#           , DATAVAULT.SAT_PROVISIONED_PRODUCT.CONTEXT_ID as prod_CONTEXT_ID
#           , DATAVAULT.SAT_PROVISIONED_PRODUCT.SOURCE as prod_SOURCE
#           , DATAVAULT.SAT_PROVISIONED_PRODUCT.CODE_TYPE as prod_CODE_TYPE
#           , DATAVAULT.SAT_PROVISIONED_PRODUCT.DELETED as prod_DELETED
#           , DATAVAULT.HUB_PRODUCT.PID as prod_PID
#           , DATAVAULT.HUB_ISBN.ISBN13 as prod_ISBN13
#           , DATAVAULT.SAT_PRODUCT.TYPE as prod_type
#           , UNLIMITED.SCENARIO_DETAILS.UID as email
#           , 1 as success

#           FROM DATAVAULT.HUB_USER
#           INNER JOIN DATAVAULT.LINK_USER_PRODUCT on LINK_USER_PRODUCT.HUB_USER_KEY = HUB_USER.HUB_USER_KEY
#           INNER JOIN DATAVAULT.SAT_PROVISIONED_PRODUCT on DATAVAULT.SAT_PROVISIONED_PRODUCT.LINK_USER_PRODUCT_KEY = DATAVAULT.LINK_USER_PRODUCT.LINK_USER_PRODUCT_KEY
#           INNER JOIN DATAVAULT.HUB_PRODUCT on DATAVAULT.HUB_PRODUCT.HUB_PRODUCT_KEY = LINK_USER_PRODUCT.HUB_PRODUCT_KEY
#           INNER JOIN DATAVAULT.LINK_PRODUCT_ISBN on DATAVAULT.LINK_PRODUCT_ISBN.HUB_PRODUCT_KEY = DATAVAULT.HUB_PRODUCT.HUB_PRODUCT_KEY
#           INNER JOIN DATAVAULT.HUB_ISBN on DATAVAULT.HUB_ISBN.HUB_ISBN_KEY = DATAVAULT.LINK_PRODUCT_ISBN.HUB_ISBN_KEY
#           INNER JOIN DATAVAULT.SAT_PRODUCT on DATAVAULT.SAT_PRODUCT.HUB_PRODUCT_KEY = DATAVAULT.HUB_PRODUCT.HUB_PRODUCT_KEY

#           INNER JOIN UNLIMITED.SCENARIO_DETAILS on UNLIMITED.SCENARIO_DETAILS.GUID = DATAVAULT.HUB_USER.UID
#           INNER JOIN UNLIMITED.SCENARIO_PROVISIONING on UNLIMITED.SCENARIO_PROVISIONING.UID = UNLIMITED.SCENARIO_DETAILS.UID and DATAVAULT.HUB_ISBN.ISBN13 = UNLIMITED.SCENARIO_PROVISIONING.IAC_ISBN
#           )

#           , fail as(
#           select UNLIMITED.SCENARIO_DETAILS.guid as uid

#           , UNLIMITED.SCENARIO_PROVISIONING.CREATED_ON as prod_DATE_ADDED
#           , null as prod_EXPIRATION_DATE
#           , null as prod_CONTEXT_ID
#           , null as prod_SOURCE
#           , null as prod_CODE_TYPE
#           , null as prod_DELETED
#           , null as prod_PID
#           , UNLIMITED.SCENARIO_PROVISIONING.IAC_ISBN as prod_ISBN13
#           , UNLIMITED.SCENARIO_PROVISIONING.PRODUCT_TYPE as prod_type
#           , UNLIMITED.SCENARIO_DETAILS.UID as email
#           , 0 as success


#           from UNLIMITED.SCENARIO_PROVISIONING
#           INNER JOIN UNLIMITED.SCENARIO_DETAILS on UNLIMITED.SCENARIO_DETAILS.uid = UNLIMITED.SCENARIO_PROVISIONING.uid
#           left outer join success on success.email = UNLIMITED.SCENARIO_PROVISIONING.uid and success.prod_ISBN13 = UNLIMITED.SCENARIO_PROVISIONING.IAC_ISBN
#           where success.email is null
#           and success.prod_ISBN13 is null
#           )

#           select * from fail
#           union
#           select * from success
#           ;;
# }

# measure: count {
#   type: count
#   drill_fields: [detail*]

# }

#   measure: success_sum {
#     type: sum
#     sql: ${success} ;;
#     drill_fields: [detail*]
#   }

#   measure: count_good {
#     type: count
#     filters: {
#       field: success
#       value: "1"
#     }
#     drill_fields: [detail*]
#   }

#   measure: count_bad {
#     type: count
#     filters: {
#       field: success
#       value: "0"
#     }
#     drill_fields: [detail*]
#   }

# dimension: uid {
#   type: string
#   sql: ${TABLE}."UID" ;;
# }

# dimension_group: prod_date_added {
#   type: time
#   sql: ${TABLE}."PROD_DATE_ADDED" ;;
# }

# dimension_group: prod_expiration_date {
#   type: time
#   sql: ${TABLE}."PROD_EXPIRATION_DATE" ;;
# }

# dimension: prod_context_id {
#   type: string
#   sql: ${TABLE}."PROD_CONTEXT_ID" ;;
# }

# dimension: prod_source {
#   type: string
#   sql: ${TABLE}."PROD_SOURCE" ;;
# }

# dimension: prod_code_type {
#   type: string
#   sql: ${TABLE}."PROD_CODE_TYPE" ;;
# }

# dimension: prod_deleted {
#   type: string
#   sql: ${TABLE}."PROD_DELETED" ;;
# }
#   dimension: access {
#     type: string
#     sql: case when ${TABLE}."EMAIL" like '%full%' then 'FULL' when ${TABLE}."EMAIL" like '%trial%' then 'TRIAL' else 'NO_CU' end ;;
#   }

# dimension: prod_pid {
#   type: string
#   sql: ${TABLE}."PROD_PID" ;;
# }

# dimension: prod_isbn13 {
#   type: string
#   sql: ${TABLE}."PROD_ISBN13" ;;
# }

# dimension: prod_type {
#   type: string
#   sql: ${TABLE}."PROD_TYPE" ;;
# }

# dimension: email {
#   type: string
#   sql: ${TABLE}."EMAIL" ;;
# }

# dimension: success {
#   type: number
#   sql: ${TABLE}."SUCCESS" ;;
# }

# set: detail {
#   fields: [
#     uid,
#     prod_date_added_time,
#     prod_expiration_date_time,
#     prod_context_id,
#     prod_source,
#     prod_code_type,
#     prod_deleted,
#     prod_pid,
#     prod_isbn13,
#     prod_type,
#     email,
#     success
#   ]
# }
# }
