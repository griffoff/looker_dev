include: "fivetran_audit.base"
include: "/base/common_includes.lkml"

explore: fivetran_audit{
  hidden: yes
  extends: [root]

  join:fivetran_audit {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: +fivetran_audit{
  dimension: id {primary_key:yes}
}
