include: "version.base"
include: "/base/common_includes.lkml"

explore: version{
  hidden: yes
  extends: [root]

  join:version {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +version{
  dimension: id {primary_key:yes}
}
