# view: cu_raw_olr_extended_iac {
#   sql_table_name: prod.UNLIMITED.RAW_OLR_EXTENDED_IAC ;;

#   dimension_group: _ldts {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     sql: ${TABLE}."_LDTS" ;;
#   }

#   dimension: _rsrc {
#     type: string
#     sql: ${TABLE}."_RSRC" ;;
#   }

#   dimension: ccp_atr_type_id {
#     type: string
#     sql: ${TABLE}."CCP_ATR_TYPE_ID" ;;
#   }

#   dimension: ccp_atr_value {
#     type: string
#     sql: ${TABLE}."CCP_ATR_VALUE" ;;
#   }

#   dimension: ccp_isbn_13 {
#     type: string
#     sql: ${TABLE}."CCP_ISBN_13" ;;
#   }

#   dimension: ccp_ldapg_group_name {
#     type: string
#     sql: ${TABLE}."CCP_LDAPG_GROUP_NAME" ;;
#   }

#   dimension: ccp_name {
#     type: string
#     sql: ${TABLE}."CCP_NAME" ;;
#   }

#   dimension: ccp_part_id {
#     type: string
#     sql: ${TABLE}."CCP_PART_ID" ;;
#   }

#   dimension: ccp_pid {
#     type: number
#     value_format_name: id
#     sql: ${TABLE}."CCP_PID" ;;
#   }

#   dimension: ccp_product_type {
#     type: string
#     sql: ${TABLE}."CCP_PRODUCT_TYPE" ;;
#   }

#   dimension: cp_atr_type_id {
#     type: string
#     sql: ${TABLE}."CP_ATR_TYPE_ID" ;;
#   }

#   dimension: cp_atr_value {
#     type: string
#     sql: ${TABLE}."CP_ATR_VALUE" ;;
#   }

#   dimension: cp_isbn_13 {
#     type: string
#     sql: ${TABLE}."CP_ISBN_13" ;;
#   }

#   dimension: cp_ldapg_group_name {
#     type: string
#     sql: ${TABLE}."CP_LDAPG_GROUP_NAME" ;;
#   }

#   dimension: cp_name {
#     type: string
#     sql: ${TABLE}."CP_NAME" ;;
#   }

#   dimension: cp_part_id {
#     type: string
#     sql: ${TABLE}."CP_PART_ID" ;;
#   }

#   dimension: cp_pid {
#     type: number
#     value_format_name: id
#     sql: ${TABLE}."CP_PID" ;;
#   }

#   dimension: cp_product_type {
#     type: string
#     sql: ${TABLE}."CP_PRODUCT_TYPE" ;;
#   }

#   dimension: olr_prod_rel_skey {
#     type: number
#     sql: ${TABLE}."OLR_PROD_REL_SKEY" ;;
#   }

#   dimension: pp_atr_type_id {
#     type: string
#     sql: ${TABLE}."PP_ATR_TYPE_ID" ;;
#   }

#   dimension: pp_atr_value {
#     type: string
#     sql: ${TABLE}."PP_ATR_VALUE" ;;
#   }

#   dimension: pp_isbn_13 {
#     type: string
#     sql: ${TABLE}."PP_ISBN_13" ;;
#   }

#   dimension: pp_ldap_group_name {
#     type: string
#     sql: ${TABLE}."PP_LDAP_GROUP_NAME" ;;
#   }

#   dimension: pp_name {
#     type: string
#     sql: ${TABLE}."PP_NAME" ;;
#   }

#   dimension: pp_part_id {
#     type: string
#     sql: ${TABLE}."PP_PART_ID" ;;
#   }

#   dimension: pp_pid {
#     type: number
#     value_format_name: id
#     sql: ${TABLE}."PP_PID" ;;
#   }

#   dimension: pp_product_type {
#     type: string
#     sql: ${TABLE}."PP_PRODUCT_TYPE" ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   # ----- Sets of fields for drilling ------
#   set: detail {
#     fields: [
#       pp_name,
#       pp_ldap_group_name,
#       cp_name,
#       cp_ldapg_group_name,
#       ccp_name,
#       ccp_ldapg_group_name
#     ]
#   }
# }
