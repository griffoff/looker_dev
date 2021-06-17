include: "board.base"
include: "/base/common_includes.lkml"

explore: board {
  hidden: yes
  extends: [root]

  join: board {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +board {
  dimension: id {primary_key:yes}
}
