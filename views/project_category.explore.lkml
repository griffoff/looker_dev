include: "project_category.view"

explore: +project_category {}

view: +project_category {
  dimension_group: _fivetran_synced {hidden:yes}
}
