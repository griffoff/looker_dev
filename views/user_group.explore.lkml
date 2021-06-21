include: "user_group.view"
include: "user.view"

explore: +user_group {
  join: user {
    sql_on: ${user_group.user_id} = ${user.id} ;;
    relationship: many_to_one
  }
}
