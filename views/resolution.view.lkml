include: "resolution.base"
include: "/base/common_includes.lkml"

explore: resolution{
  hidden: yes
  extends: [root]

  join:resolution {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +resolution{
  dimension: id {primary_key:yes}
}
