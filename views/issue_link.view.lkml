include: "issue_link.base"
include: "/base/common_includes.lkml"

explore: issue_link{
  hidden: yes
  extends: [root]

  join:issue_link {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +issue_link{
  extends: [common_hidden_fields]
  dimension: pk {
    primary_key:yes
    hidden: yes
    sql: hash(${issue_id},${related_issue_id},${relationship}) ;;
  }
  dimension: issue_id {hidden:yes}
  dimension: related_issue_id {hidden:yes}

  dimension: relationship {
      label: "Relationship to Primary Issue"
  }

  measure: count {hidden:yes}

}
