include: "status.base"
include: "/base/common_includes.lkml"

explore: status{
  hidden: yes
  extends: [root]

  join:status {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +status{
  dimension: id {primary_key:yes}
}
