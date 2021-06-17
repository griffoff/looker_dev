include: "sprint.view"
include: "board.explore"

explore: +sprint {
  extends: [board]
  join: board {
    sql_on: ${sprint.board_id} = ${sprint.id} ;;
    relationship: many_to_one
  }
}

view:+sprint {
  dimension: board_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
