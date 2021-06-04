# view: dim_scorecategory {
#   sql_table_name: DW_DEVMATH.DIM_SCORECATEGORY ;;

#   dimension: color {
#     type: string
#     sql: ${TABLE}.COLOR ;;
#   }

#   dimension: max_score {
#     type: number
#     sql: ${TABLE}.MAX_SCORE ;;
#   }

#   dimension: min_score {
#     type: number
#     sql: ${TABLE}.MIN_SCORE ;;
#   }

#   dimension: score_category {
#     type: string
#     sql: ${TABLE}.SCORE_CATEGORY ;;
#   }

#   dimension: score_category_id {
#     type: string
#     sql: ${TABLE}.SCORE_CATEGORY_ID ;;
#   }

#   dimension: score_subcategory {
#     type: string
#     sql: ${TABLE}.SCORE_SUBCATEGORY ;;
#   }

#   measure: count {
#     type: count
#     drill_fields: []
#   }
# }
