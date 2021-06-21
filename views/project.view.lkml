include: "project.base"
include: "/base/common_includes.lkml"

explore: project{
  hidden: yes
  extends: [root]

  join:project {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +project{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: lead_id {hidden:yes}
  dimension: project_category_id {hidden:yes}
}
