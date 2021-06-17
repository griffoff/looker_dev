include: "field.view"
include: "issue_field_history.explore"
include: "issue_multiselect_history.explore"
include: "issue.explore"

explore: +field {
  join: issue_field_history {
    sql_on: ${field.id} = ${issue_field_history.field_id} ;;
    relationship: one_to_many
  }

  join: issue_multiselect_history {
    sql_on: ${field.id} = ${issue_multiselect_history.field_id} ;;
    relationship: one_to_many
  }

  join: issue {
    sql_on: coalesce(${issue_field_history.issue_id},${issue_multiselect_history.issue_id}) = ${issue.id} ;;
    relationship: many_to_one
  }

}

view: +field {
  dimension_group: _fivetran_synced {hidden:yes}
}
