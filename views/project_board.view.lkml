include: "project_board.base"
include: "/base/common_includes.lkml"

explore: project_board{
  hidden: yes
  extends: [root]

  join:project_board {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +project_board{
  dimension: pk {
    primary_key:yes
    hidden:yes
    sql: hash(${board_id},${project_id}) ;;
    }
}
