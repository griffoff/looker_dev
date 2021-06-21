include: "field.view"
include: "issue_field_history_combined.view"
include: "issue.view"

explore: +field {
  join: issue_field_history_combined {
    sql_on: ${field.id} = ${issue_field_history_combined.field_id} ;;
    relationship: one_to_many
  }

  join: issue {
    sql_on: ${issue_field_history_combined.issue_id} = ${issue.id} ;;
    relationship: many_to_one
  }

}
