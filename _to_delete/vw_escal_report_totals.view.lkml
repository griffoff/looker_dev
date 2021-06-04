# view: vw_escal_report_totals {
#   derived_table: {
#     sql: (
#       select d.key
#         , iff(datediff(day, d.created, current_date()) <= 2,1,0) as recentlyCreated
#         , iff(d.last_resolved is null, 0, iff(datediff(day, d.LAST_RESOLVED, current_date()) <= 2,1,0)) as recentlyResolved
#         , iff(d.LAST_RESOLVED is null, 1,0) as isUnresolved
#         , d.priority
#         , cat.category
#         , comp.component
#         , d.key || '-' || cat.category || '-' || comp.component as unique_key
# from escal.vw_escal_detail d, escal.vw_escal_categories cat, escal.vw_escal_components comp
# where d.key = cat.key and d.key = comp.key
#     ) ;;
#   }

#   dimension: key {
#     type:  string
#     sql: ${TABLE}.key ;;

#   }
#   dimension: unique_key {
#     type:  string
#     primary_key: yes
#     sql: ${TABLE}.unique_key ;;

#   }
#   dimension: category {
#     type:  string
#     sql: ${TABLE}.category ;;
#   }

#   dimension: component{
#     type:  string
#     sql: ${TABLE}.component ;;
#   }

#   dimension: priority {
#     type:  string
#     sql: ${TABLE}.priority ;;
#   }

#   dimension: recently_created {
#     type:  number
#     sql: ${TABLE}.recentlyCreated ;;
#   }

#   dimension: recently_resolved {
#     type:  number
#     sql: ${TABLE}.recentlyResolved ;;
#   }

#   dimension: isUnresolved {
#     type:  number
#     sql: ${TABLE}.isUnresolved ;;
#   }

#   measure: sum_created {
#     label: "# of Recently Closed"
#     type:  sum
#     sql: ${recently_created} ;;
#     sql_distinct_key: ${unique_key} ;;
#   }

#   measure: sum_resolved {
#     label: "# of Recently Resolved"
#     type:  sum
#     sql: ${recently_resolved} ;;
#     sql_distinct_key: ${unique_key} ;;
#     }

#   measure: sum_unresolved {
#     label: "# of Unresolved"
#     type:  sum
#     drill_fields: [unique_key, key, priority,category, component, recently_created, recently_resolved, isUnresolved]
#     sql: ${isUnresolved} ;;
#     sql_distinct_key: ${unique_key} ;;

#   }
# }
