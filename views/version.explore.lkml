include: "version.view"
include: "project.explore"

explore: +version {
  extends: [project]

  join: project {
    sql_on: ${version.project_id} = ${project.id} ;;
    relationship: many_to_one
  }
}

view: +version {
  dimension: project_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
