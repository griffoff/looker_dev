# view: dim_institution {
#   sql_table_name: DW_DEVMATH.DIM_INSTITUTION ;;

#   dimension: active {
#     type: string
#     sql: ${TABLE}.ACTIVE ;;
#   }

#   dimension_group: enddate {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     sql: ${TABLE}.ENDDATE ;;
#   }

#   dimension: institutionid {
#     type: string
#     sql: ${TABLE}.INSTITUTIONID ;;
#   }

#   dimension: institutionname {
#     type: string
#     sql: ${TABLE}.INSTITUTIONNAME ;;
#   }

#   dimension_group: ldts {
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
#     sql: ${TABLE}.LDTS ;;
#   }

#   dimension: originalinstitutionname {
#     type: string
#     sql: ${TABLE}.ORIGINALINSTITUTIONNAME ;;
#   }

#   dimension: rsrc {
#     type: string
#     sql: ${TABLE}.RSRC ;;
#   }

#   dimension: sso_entity_id {
#     type: string
#     sql: ${TABLE}.SSO_ENTITY_ID ;;
#   }

#   dimension_group: startdate {
#     type: time
#     timeframes: [
#       raw,
#       date,
#       week,
#       month,
#       quarter,
#       year
#     ]
#     convert_tz: no
#     sql: ${TABLE}.STARTDATE ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: [institutionname, originalinstitutionname]
#   }
# }
