include: "project.view"
include: "project_role_actor.explore"
include: "user.explore"
include: "component.explore"
include: "issue.explore"
include: "project_board.explore"
include: "version.explore"
include: "project_category.explore"


explore: +project {
  extends: [project_role_actor,project_board]

  join: project_role_actor {
    sql_on: ${project.id} = ${project_role_actor.project_id} ;;
    relationship: one_to_many
  }

  join: lead {
    from: user
    sql_on: ${project.lead_id} = ${lead.id} ;;
    relationship: many_to_one
    view_label: "Project Lead"
  }

  join: component {
    sql_on: ${project.id} = ${component.project_id} ;;
    relationship: one_to_many
  }

  join: issue {
    sql_on: ${project.id} = ${issue.project} ;;
    relationship: one_to_many
  }

  join: project_board {
    sql_on: ${project.id} = ${project_board.project_id} ;;
    relationship: one_to_many
  }

  join: version {
    view_label: "Project Version"
    sql_on: ${project.id} = ${version.project_id} ;;
    relationship: one_to_many
  }

  join: project_category {
    sql_on: ${project.project_category_id} = ${project_category.id} ;;
    relationship: many_to_one
  }

}

view: +project {
  dimension: lead_id {hidden:yes}
  dimension: project_category_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
