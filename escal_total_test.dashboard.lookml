- dashboard: escal_total_test
  title: Escal Total Test
  layout: tile
  tile_size: 100

  filters:

  elements:
- name: add_a_unique_name_1525941545
  title: Untitled Visualization
  model: jira.dev
  explore: escal_2_total
  type: table
  fields: [escal_2_total.component_priority, escal_2_total.count, escal_2_total.category,
    escal_2_total.count_created_yesterday, escal_2_total.count_resolved_yesterday]
  pivots: [escal_2_total.category]
  filters:
    escal_2_total.priority: P3 Escalation,P1 Escalation,P2 Escalation
    escal_2_total.topSystem: 'Yes'
  sorts: [escal_2_total.category 0, escal_2_total.component_priority]
  limit: 500
  dynamic_fields:
  - table_calculation: unresolved
    label: Unresolved
    expression: coalesce(${escal_2_total.count},0)-1
    value_format:
    value_format_name:
    _kind_hint: measure
    _type_hint: number
  - table_calculation: total_created
    label: Total Created
    expression: pivot_index(${escal_2_total.count_created_yesterday},1)+pivot_index(${escal_2_total.count_created_yesterday},2)+pivot_index(${escal_2_total.count_created_yesterday},3)+pivot_index(${escal_2_total.count_created_yesterday},4)
    value_format:
    value_format_name:
    _kind_hint: supermeasure
    _type_hint: number
  - table_calculation: total_resolved
    label: Total Resolved
    expression: pivot_index(${escal_2_total.count_resolved_yesterday},1)+pivot_index(${escal_2_total.count_resolved_yesterday},2)+pivot_index(${escal_2_total.count_resolved_yesterday},3)+pivot_index(${escal_2_total.count_resolved_yesterday},4)
    value_format:
    value_format_name:
    _kind_hint: supermeasure
    _type_hint: number
  - table_calculation: total_unresolved
    label: Total Unresolved
    expression: pivot_index(${unresolved},1)+pivot_index(${unresolved},2)+pivot_index(${unresolved},3)+pivot_index(${unresolved},4)
    value_format:
    value_format_name:
    _kind_hint: supermeasure
    _type_hint: number
  query_timezone: America/Los_Angeles
  show_view_names: true
  show_row_numbers: true
  truncate_column_names: false
  hide_totals: false
  hide_row_totals: false
  table_theme: editable
  limit_displayed_rows: false
  enable_conditional_formatting: true
  conditional_formatting_include_totals: false
  conditional_formatting_include_nulls: true
  hidden_fields: [escal_2_total.count]
  series_labels:
    escal_2_total.count_created_yesterday: Created
    escal_2_total.count_resolved_yesterday: Resolved
  conditional_formatting: [{type: high to low, value: !!null '', background_color: !!null '',
      font_color: !!null '', palette: {name: Red to White, colors: ["#F36254", "#FFFFFF"]},
      bold: false, italic: false, strikethrough: false, fields: !!null ''}]
