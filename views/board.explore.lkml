include: "board.view"
include: "sprint.view"
include: "project_board.view"

explore: +board {
  extends: [sprint,project_board]

  join: sprint {
    sql_on: ${sprint.board_id} = ${board.id} ;;
    relationship: many_to_one
  }

  join: project_board {
    sql_on: ${board.id} = ${project_board.board_id} ;;
    relationship: one_to_many
  }

}
