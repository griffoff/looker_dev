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
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: board_id {hidden:yes}
}
