include: "epic.view"
include: "issue.explore"

explore: +epic {
  join: issue {
    sql_on: ${epic.id} = ${issue.parent_id} ;;
    relationship: one_to_many
  }
}

view: +epic {
  dimension_group: _fivetran_synced {hidden:yes}
}
