include: "user_group.base"
include: "/base/common_includes.lkml"

explore: user_group{
  hidden: yes
  extends: [root]

  join:user_group {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +user_group{
  extends: [common_hidden_fields]
  dimension: pk {
    primary_key:yes
    hidden: yes
    sql: hash(${user_id},${group_name}) ;;
  }
  dimension: user_id {hidden:yes}
}
