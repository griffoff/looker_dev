include: "project_board.view"
include: "board.explore"
include: "project.explore"

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

view: +project_board {
  dimension: board_id {hidden:yes}
  dimension: project_id {hidden:yes}
  measure: count {hidden:yes}
  dimension: _fivetran_synced {hidden:yes}
}
