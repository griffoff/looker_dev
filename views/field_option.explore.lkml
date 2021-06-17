include: "field_option.view"

explore: +field_option {
  join: parent_field_option {
    from: field_option
    sql_on: ${field_option.parent_id} = ${parent_field_option.id}  ;;
    relationship: many_to_one
  }
}

view: +field_option {
  dimension: parent_id {hidden:yes}
  dimension_group: _fivetran_synced {hidden:yes}
}
