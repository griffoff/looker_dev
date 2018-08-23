- dashboard: test
  title: Test
  layout: tile
  tile_size: 100

  filters:

  elements:
    - name: add_a_unique_name_1535013157
  title: Untitled Visualization
  model: jira
  explore: escal_2_new_copy
  type: looker_donut_multiples
  fields: [escal_2_new_copy.opening_status, escal_2_new_copy.count]
  pivots: [escal_2_new_copy.opening_status]
  filters:
    escal_2_new_copy.category: Digital Production,Not set,Software,Content Source
    escal_2_new_copy.component: ''
    escal_2_new_copy.opening_status: "-NULL"
  sorts: [escal_2_new_copy.opening_status]
  limit: 500
  filter_expression: diff_days(${escal_2_new_copy.updated_date}, now()) = 1
  query_timezone: America/Los_Angeles
  show_value_labels: true
  font_size: 12
  colors: ["#c61d23", "#5edf4e", "#929292", "#9fdee0", "#1f3e5a", "#90c8ae", "#92818d",
    "#c5c6a6", "#82c2ca", "#cee0a0", "#928fb4", "#9fc190"]
  series_colors: {}
  series_types: {}
