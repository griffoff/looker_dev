include: "sprint.base"
include: "/base/common_includes.lkml"

explore: sprint{
  hidden: yes
  extends: [root]

  join:sprint {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +sprint{
  dimension: id {primary_key:yes}
}
