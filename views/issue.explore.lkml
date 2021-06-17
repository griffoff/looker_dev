include: "issue.view"
include: "priority.explore"
include: "resolution.explore"
include: "status.explore"
include: "epic.explore"

include: "project.explore"
include: "comment.explore"
include: "issue_link.explore"
include: "worklog.explore"
include: "issue_field_history.explore"
include: "issue_multiselect_history.explore"
include: "field.explore"


explore: +issue {
  hidden: yes
  extends: [project,issue_link,status,worklog,comment]

  join: project {
    sql_on: ${issue.project} = ${project.id} ;;
    relationship: many_to_one
  }

  join: issue_link {
    view_label: "Related Issue"
    sql_on: ${issue.id} = ${issue_link.issue_id} ;;
    relationship: one_to_many
  }

  join: parent_issue {
    from: issue
    sql_on: ${issue.parent_id} = ${parent_issue.parent_id}  ;;
    relationship: many_to_many
  }

  join: priority {
    view_label: "Issue Priority"
    sql_on: ${issue.priority} = ${priority.id} ;;
    relationship: many_to_one
  }

  join: resolution {
    view_label: "Issue Resolution"
    sql_on: ${issue.resolution} = ${resolution.id} ;;
    relationship: many_to_one
  }

  join: status {
    view_label: "Issue Status"
    sql_on: ${issue.status} = ${status.id} ;;
    relationship: many_to_one
  }

  join: status_category {
    view_label: "Issue Status Category"
  }

  join: epic {
    sql_on: ${issue.parent_id} = ${epic.id} ;;
    relationship: many_to_one
  }

  join: worklog {
    sql_on: ${issue.id} = ${worklog.issue_id};;
    relationship: one_to_many
  }

  join: issue_field_history {
    sql_on: ${issue.id} = ${issue_field_history.issue_id} ;;
    relationship: one_to_many
  }

  join: issue_multiselect_history {
    sql_on: ${issue.id} = ${issue_multiselect_history.issue_id} ;;
    relationship: one_to_many
  }

  join: field {
    sql_on: coalesce(${issue_field_history.field_id},${issue_multiselect_history.field_id}) = ${field.id} ;;
    relationship: many_to_one
  }

  join: issue_field_history_author {
    from: user
    sql_on: coalesce(${issue_field_history.author_id},${issue_multiselect_history.author_id}) = ${issue_field_history_author.id} ;;
    relationship: many_to_one
  }

  join: comment {
    sql_on: ${issue.id} = ${comment.issue_id} ;;
    relationship: one_to_many
  }



}

view: +issue {
  dimension: parent_id {hidden:yes}
  dimension: project {hidden:yes}
  dimension: priority {hidden:yes}
  dimension: resolution {hidden:yes}
  dimension: status {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}

view: +issue_link {
  dimension: relationship {
    label: "Relationship to Primary Issue"
  }
}
