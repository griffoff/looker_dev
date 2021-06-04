# view: cu_vw_provisioned_product_base {
#   derived_table: {
#     sql:SELECT distinct
#       pp.user_sso_guid,
#       pp.context_id,
#       FIRST_VALUE(pp._hash) OVER (PARTITION BY pp.user_sso_guid, pp.CONTEXT_ID ORDER BY pp.LOCAL_TIME) AS _hash
#       , pp."source"
#       , pp.code_type
#     FROM prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT pp--${cu_raw_olr_provisioned_product.SQL_TABLE_NAME}
#     LEFT OUTER JOIN prod.unlimited.EXCLUDED_USERS exc ON pp.user_sso_guid = exc.user_sso_guid
#     where exc.user_sso_guid is null
#     and pp.USER_ENVIRONMENT like 'production'
#     AND pp.PLATFORM_ENVIRONMENT like 'production'
#     AND (pp.SOURCE_ID is null or pp.SOURCE_ID <> 'Something')
# ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: user_sso_guid {
#     type: string
#     sql: ${TABLE}."USER_SSO_GUID" ;;
#   }

#   dimension: context_id {
#     type: string
#     sql: ${TABLE}."CONTEXT_ID" ;;
#   }

#   dimension: _hash {
#     type: string
#     sql: ${TABLE}."_HASH" ;;
#   }

#   dimension: source {
#     type: string
#     sql: ${TABLE}."source" ;;
#   }

#   dimension: code_type {
#     type: string
#     sql: ${TABLE}."CODE_TYPE" ;;
#   }

#   set: detail {
#     fields: [user_sso_guid, context_id, _hash, source, code_type]
#   }
# }
