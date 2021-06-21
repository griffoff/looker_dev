include: "project_board.view"
include: "board.view"
include: "project.view"

explore: +project_board {
  extends: [project,board]

  join: board {
    sql_on: ${project_board.board_id} = ${board.id} ;;
    relationship: many_to_one
  }

  join: project {
    sql_on: ${project_board.project_id} = ${project.id} ;;
    relationship: many_to_one
  }
}
