include: "issue.view"
include: "priority.view"
include: "resolution.view"
include: "status.view"
include: "status_category.view"
include: "epic.view"
include: "user.view"

include: "project.view"
include: "comment.view"
include: "issue_link.view"
include: "worklog.view"
include: "issue_field_history_combined.view"
include: "field.view"
include: "issue_type.view"
include: "issue_custom_fields.view"


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
    sql_on: ${status.status_category_id} = ${status_category.id} ;;
    relationship: many_to_one
  }

  join: epic {
    sql_on: ${issue.parent_id} = ${epic.id} ;;
    relationship: many_to_one
  }

  join: worklog {
    sql_on: ${issue.id} = ${worklog.issue_id};;
    relationship: one_to_many
  }

  join: issue_field_history_combined {
    sql_on: ${issue.id} = ${issue_field_history_combined.issue_id} ;;
    relationship: one_to_many
  }

  join: field {
    sql_on: ${issue_field_history_combined.field_id} = ${field.id} ;;
    relationship: many_to_one
  }

  join: issue_field_history_author {
    from: user
    sql_on: ${issue_field_history_combined.author_id} = ${issue_field_history_author.id} ;;
    relationship: many_to_one
  }

  join: comment {
    sql_on: ${issue.id} = ${comment.issue_id} ;;
    relationship: one_to_many
  }

  join: issue_type {
    sql_on: ${issue.issue_type} = ${issue_type.id} ;;
    relationship: many_to_one
  }

  join: issue_custom_fields {
    sql_on: ${issue.id} = ${issue_custom_fields.issue_id} ;;
    relationship: one_to_one
  }

}
