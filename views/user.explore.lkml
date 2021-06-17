include: "user.view"
include: "user_group.explore"
include: "comment.explore"

explore: +user {
  extends: [user_group,comment]

  join: user_group {
    sql_on: ${user.id} = ${user_group.user_id} ;;
    relationship: one_to_many
  }


}

view: +user {
  dimension_group: _fivetran_synced {hidden:yes}
}
