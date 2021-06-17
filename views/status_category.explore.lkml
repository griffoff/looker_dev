include: "status_category.view"

explore: +status_category {}

view: +status_category {
  dimension_group: _fivetran_synced {hidden:yes}
}
