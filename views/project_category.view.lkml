include: "project_category.base"
include: "/base/common_includes.lkml"

explore: project_category{
  hidden: yes
  extends: [root]

  join:project_category {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +project_category{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
}
