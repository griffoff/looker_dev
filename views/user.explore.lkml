include: "user.view"
include: "user_group.view"
include: "comment.view"

explore: +user {
  extends: [user_group,comment]

  join: user_group {
    sql_on: ${user.id} = ${user_group.user_id} ;;
    relationship: one_to_many
  }

}
