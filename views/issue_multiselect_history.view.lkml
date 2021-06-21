include: "issue_multiselect_history.base"
include: "/base/common_includes.lkml"

explore: issue_multiselect_history{
  hidden: yes
  extends: [root]

  join:issue_multiselect_history {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +issue_multiselect_history{
  extends: [common_hidden_fields]
  dimension: _fivetran_id {primary_key:yes}
  dimension: author_id {hidden:yes}
  dimension: field_id {hidden:yes}
  dimension: issue_id {hidden:yes}

  measure: sample_value {
    sql: any_value(${value}) ;;
  }
}
