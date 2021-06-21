include: "issue_type.base"
include: "/base/common_includes.lkml"

explore: issue_type{
  hidden: yes
  extends: [root]

  join: issue_type {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +issue_type {
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
}
