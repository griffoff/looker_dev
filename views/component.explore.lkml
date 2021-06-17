include: "component.view"
include: "project.explore"
include: "issue.explore"


explore: +component {

  join: project {
    sql_on: ${component.project_id} = ${project.id} ;;
    relationship: many_to_one
  }

}

view: +component {
  dimension: project_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
