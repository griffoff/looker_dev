include: "status_category.base"
include: "/base/common_includes.lkml"

explore: status_category{
  hidden: yes
  extends: [root]

  join:status_category {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +status_category{
  dimension: id {primary_key:yes}
}
