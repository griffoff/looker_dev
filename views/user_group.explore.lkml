include: "user_group.view"
include: "user.view"

explore: +user_group {
  join: user {
    sql_on: ${user_group.user_id} = ${user.id} ;;
    relationship: many_to_one
  }
}

view: +user_group {
  dimension: user_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
