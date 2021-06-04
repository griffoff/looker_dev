# view: vw_topsystem {
#     view_label: "Cengage systems"
#     derived_table: {
#       sql:
#       SELECT
#           PRODUCTGROUP::string as PRODUCTGROUP
#       , SYSTEMNAME::string as SYSTEMNAME
#       , DISPLAYORDER::number as DISPLAYORDER
#       , ISTOPSYSTEM::boolean as ISTOPSYSTEM
#       FROM JIRA.TOPSYSTEM
#           ;;
#     }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: productgroup {
#     type: string
#     sql: ${TABLE}."PRODUCTGROUP" ;;
#   }

#   dimension: systemname {
#     type: string
#     sql: ${TABLE}."SYSTEMNAME" ;;
#   }

#   dimension: displayorder {
#     type: number
#     sql: ${TABLE}."DISPLAYORDER" ;;
#   }

#   dimension: istopsystem {
#     type: string
#     sql: ${TABLE}."ISTOPSYSTEM" ;;
#   }

#   set: detail {
#     fields: [productgroup, systemname, displayorder, istopsystem]
#   }
# }
