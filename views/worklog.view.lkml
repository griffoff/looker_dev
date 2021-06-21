include: "worklog.base"
include: "/base/common_includes.lkml"

explore: worklog{
  hidden: yes
  extends: [root]

  join:worklog {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +worklog{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: author_id {hidden:yes}
  dimension: update_author_id {hidden:yes}
  dimension: issue_id {hidden:yes}
}
