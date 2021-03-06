include: "user.base"
include: "/base/common_includes.lkml"

explore: user{
  hidden: yes
  extends: [root]

  join:user {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +user{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
}
