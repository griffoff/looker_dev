# view: vw_escal_categories {
#   view_label: "Escal Categories"
#   #sql_table_name: ESCAL.VW_ESCAL_CATEGORIES ;;
#   derived_table: {
#     sql:
#       select
#           detail.key
#           ,j.value:value::string as category
#       from ${vw_escal_detail.SQL_TABLE_NAME} detail
#       cross join lateral flatten(categories) j
#     ;;
#   }

#   dimension: category {
#     type: string
#     sql: ${TABLE}.CATEGORY ;;
#   #  link: {
#   #    label: "Show Aging"
#   #    url: "https://cengage.looker.com/dashboards/37?Category=%25{{category}}%25"
#   #  }
#   #  link: {
#   #    label: "Show Newly Opened"
#   #    url: "https://cengage.looker.com/dashboards/39?Category=%25{{category}}%25"
#   #  }
#   }

#   dimension: key {
#     type: string
#     hidden: yes
#     sql: ${TABLE}.KEY ;;
#   }

#   measure: count {
#     description: "Keep in mind that a ticket can have a few category."
#     type: count
#     drill_fields: []
#   }
# }
