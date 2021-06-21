include: "project_role_actor.view"
include: "project.view"
include: "project_role.view"
include: "user.view"
include: "user_group.view"

explore: +project_role_actor {

  join: project_role {
    sql_on: ${project_role_actor.project_role_id} = ${project_role.id} ;;
    relationship: many_to_one
  }

  join: user_group {
    view_label: "Project Role User Group"
    sql_on: ${project_role_actor.group_name} = ${user_group.group_name}
      and ${project_role_actor.user_id} = ${user_group.user_id} ;;
    relationship: many_to_one
  }

  join: project_role_user {
    from: user
    sql_on: ${user_group.user_id} = ${project_role_user.id} ;;
    relationship: many_to_one
  }

  join: project {
    sql_on: ${project_role_actor.project_id} = ${project.id} ;;
    relationship: many_to_one
  }

}
