include: "issue.base"
include: "/base/common_includes.lkml"

explore: issue{
  hidden: yes
  extends: [root]

  join:issue {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +issue{
  dimension: id {primary_key:yes}
}
