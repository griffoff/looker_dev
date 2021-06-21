include: "status.base"
include: "/base/common_includes.lkml"

explore: status{
  hidden: yes
  extends: [root]

  join:status {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +status{
  extends: [common_hidden_fields]
  dimension: id {primary_key:yes}
  dimension: status_category_id {hidden:yes}
}
