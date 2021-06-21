include: "status.view"
include: "status_category.view"

explore: +status {
  join: status_category {
    sql_on: ${status.status_category_id} = ${status_category.id} ;;
    relationship: many_to_one
  }
}
