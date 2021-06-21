include: "sprint.view"
include: "board.view"

explore: +sprint {
  extends: [board]
  join: board {
    sql_on: ${sprint.board_id} = ${sprint.id} ;;
    relationship: many_to_one
  }
}
