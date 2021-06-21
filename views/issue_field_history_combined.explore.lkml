include: "issue_field_history_combined.view"
include: "user.view"
include: "field.view"
include: "issue.view"
include: "issue_field_history.view"
include: "issue_multiselect_history.view"

explore: +issue_field_history_combined {

  join: issue_field_history_combined_author {
    from: user
    sql_on: ${issue_field_history_combined_author.id} = ${issue_field_history_combined.author_id} ;;
    relationship: many_to_one
  }

  join: field {
    sql_on: ${field.id} = ${issue_field_history_combined.field_id} ;;
    relationship: many_to_one
  }

  join: issue {
    sql_on: ${issue.id} = ${issue_field_history_combined.issue_id} ;;
    relationship: many_to_one
  }

  # join: issue_field_history {
  #   sql_on: ${issue_field_history_combined.field_id} = ${issue_field_history.field_id}
  #     and ${issue_field_history_combined.issue_id} = ${issue_field_history.issue_id}
  #   ;;
  # }

  # join: issue_multiselect_history {
  #   sql_on: ${issue_field_history_combined.field_id} = ${issue_multiselect_history.field_id}
  #     and ${issue_field_history_combined.issue_id} = ${issue_multiselect_history.issue_id}
  #   ;;
  # }
}
