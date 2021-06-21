include: "component.view"
include: "project.view"
include: "issue.view"

explore: +component {

  join: project {
    sql_on: ${component.project_id} = ${project.id} ;;
    relationship: many_to_one
  }

}
