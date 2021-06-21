include: "issue_field_history.base"
include: "/base/common_includes.lkml"

explore: issue_field_history{
  hidden: yes
  extends: [root]

  join:issue_field_history {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +issue_field_history{
  extends: [common_hidden_fields]
  dimension: pk {
    sql: hash(${value},${time_raw},${issue_id},${field_id},${author_id}) ;;
    primary_key: yes
    hidden: yes
  }
  dimension: author_id {hidden:yes}
  dimension: field_id {hidden:yes}
  dimension: issue_id {hidden:yes}

  measure: sample_value {
    sql: any_value(${value}) ;;
  }
}
