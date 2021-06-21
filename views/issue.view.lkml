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
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: parent_id {hidden:yes}
  dimension: project {hidden:yes}
  dimension: priority {hidden:yes}
  dimension: resolution {hidden:yes}
  dimension: status {hidden:yes}
  dimension: issue_type {hidden:yes}
}
