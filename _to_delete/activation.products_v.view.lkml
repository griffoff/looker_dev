# view: activation_products_v {
#   label: "Products"
#   sql_table_name: STG_CLTS.PRODUCTS_V ;;



#   dimension: discipline_de {
#     type: string
#     sql: ${TABLE}.DISCIPLINE_DE ;;
#   }

#   dimension: hed_discipline_nm {
#     type: string
#     sql: ${TABLE}.HED_DISCIPLINE_NM ;;
#   }

#   dimension: imprint_de {
#     type: string
#     sql: ${TABLE}.IMPRINT_DE ;;
#   }

#   dimension: isbn10 {
#     type: string
#     sql: ${TABLE}.ISBN10 ;;
#   }

#   dimension: isbn13 {
#     type: string
#     sql: ${TABLE}.ISBN13 ;;
#     primary_key: yes
#   }

#   dimension: platform {
#     type: string
#     sql: ${TABLE}.PLATFORM ;;
#   }

#   dimension: production_ed_de {
#     type: string
#     sql: ${TABLE}.PRODUCTION_ED_DE ;;
#   }

#   dimension: pt_course_area {
#     type: string
#     sql: ${TABLE}.PT_COURSE_AREA ;;
#   }

#   dimension: title {
#     type: string
#     sql: ${TABLE}.TITLE ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
# }
