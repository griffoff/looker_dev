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
  dimension: pk {
    primary_key:yes
    hidden:yes
    sql: hash(${author_id},${field_id},${issue_id},${time_raw},${value} ;;
    }
}
