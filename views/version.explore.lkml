include: "version.view"
include: "project.view"

explore: +version {
  extends: [project]

  join: project {
    sql_on: ${version.project_id} = ${project.id} ;;
    relationship: many_to_one
  }
}
