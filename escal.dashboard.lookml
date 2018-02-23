- dashboard: escal
  title: Escal
  layout: newspaper
  # refresh_interval: 1 day
  elements:
  - name: ESCALs created per week, by current status - resolved or not
    title: ESCALs created per week, by current status - resolved or not
    model: jira
    explore: vw_escal_detail_prod
    type: looker_column
    fields:
    - vw_escal_detail_prod.count
    - vw_escal_detail_prod.created_week
    - vw_escal_detail_prod.resolutionStatus
    pivots:
    - vw_escal_detail_prod.resolutionStatus
    fill_fields:
    - vw_escal_detail_prod.created_week
    - vw_escal_detail_prod.resolutionStatus
    filters:
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
      # dim_date.governmentdefinedacademicterm: Fall 2018
      # vw_escal_categories_prod.category: Software
      # vw_escal_components_prod.topSystem: 'Yes'
    sorts:
    - vw_escal_detail_prod.created_week desc
    - vw_escal_detail_prod.resolutionStatus desc
    limit: 500
    column_limit: 50
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Number of issues
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: 'Yes'
        name: Closed issues
        axisId: vw_escal_detail_prod.count
      - id: 'No'
        name: Open issues
        axisId: vw_escal_detail_prod.count
    x_axis_label: Week start
    totals_rotation: 0
    series_labels:
      No - vw_escal_detail_prod.count: Not resolved
      Yes - vw_escal_detail_prod.count: Resolved
    listen:
      Data range: dim_date.governmentdefinedacademicterm
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 33
    col: 0
    width: 15
    height: 8
  - name: ESCALs created per week, comparison between Fall 2017 and Fall 2018
    title: ESCALs created per week, comparison between Fall 2017 and Fall 2018
    model: jira
    explore: vw_escal_detail_prod
    type: looker_line
    fields:
    - vw_escal_detail_prod.count
    - dim_date.governmentdefinedacademicterm
    - dim_date.isoweekofyearid
    pivots:
    - dim_date.governmentdefinedacademicterm
    filters:
      dim_date.governmentdefinedacademicterm: Fall 2017,Fall 2018
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
    sorts:
    - dim_date.governmentdefinedacademicterm 0
    - dim_date.isoweekofyearid
    limit: 500
    column_limit: 50
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Number of issues
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom:
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: Fall 2017
        name: Fall 2017
        axisId: vw_escal_detail_prod.count
      - id: Fall 2018
        name: Fall 2018
        axisId: vw_escal_detail_prod.count
    x_axis_label: Week start
    totals_rotation: 0
    listen:
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 41
    col: 0
    width: 13
    height: 8
  - name: ESCALs created per day for the past month, by current 'resolved' status
    title: ESCALs created per day for the past month, by current 'resolved' status
    model: jira
    explore: vw_escal_detail_prod
    type: looker_column
    fields:
    - vw_escal_detail_prod.count
    - vw_escal_detail_prod.resolutionStatus
    - dim_date.datevalue_date
    pivots:
    - vw_escal_detail_prod.resolutionStatus
    fill_fields:
    - vw_escal_detail_prod.resolutionStatus
    - dim_date.datevalue_date
    filters:
      dim_date.datevalue_date: 31 days
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
      # dim_date.governmentdefinedacademicterm: Fall 2018
      # vw_escal_categories_prod.category: Software
      # vw_escal_components_prod.topSystem: 'Yes'
    sorts:
    - vw_escal_detail_prod.resolutionStatus desc
    - dim_date.datevalue_date desc
    limit: 500
    column_limit: 50
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Number of issues
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: 'Yes'
        name: Closed issues
        axisId: vw_escal_detail_prod.count
      - id: 'No'
        name: Open issues
        axisId: vw_escal_detail_prod.count
    x_axis_label: Day
    totals_rotation: 0
    series_labels:
      No - vw_escal_detail_prod.count: Not resolved
      Yes - vw_escal_detail_prod.count: Resolved
    listen:
      Data range: dim_date.governmentdefinedacademicterm
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 26
    col: 6
    width: 18
    height: 7
  - name: ESCALs created per day for the past month, by priority
    title: ESCALs created per day for the past month, by priority
    model: jira
    explore: vw_escal_detail_prod
    type: looker_column
    fields:
    - dim_date.datevalue_date
    - vw_escal_detail_prod.priority
    - vw_escal_detail_prod.count
    pivots:
    - vw_escal_detail_prod.priority
    fill_fields:
    - dim_date.datevalue_date
    filters:
      dim_date.datevalue_date: 31 days
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
    sorts:
    - dim_date.datevalue_date desc
    - vw_escal_detail_prod.priority
    limit: 500
    column_limit: 50
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Total issues
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: P1 Escalation
        name: P1 Escalation
        axisId: vw_escal_detail_prod.count
      - id: P2 Escalation
        name: P2 Escalation
        axisId: vw_escal_detail_prod.count
      - id: P3 Escalation
        name: P3 Escalation
        axisId: vw_escal_detail_prod.count
    x_axis_label: Date
    totals_rotation: 0
    listen:
      Data range: dim_date.governmentdefinedacademicterm
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 18
    col: 6
    width: 18
    height: 8
  - name: ESCALs created per day, by current 'resolved' status
    title: ESCALs created per day, by current 'resolved' status
    model: jira
    explore: vw_escal_detail_prod
    type: looker_column
    fields:
    - vw_escal_detail_prod.count
    - vw_escal_detail_prod.resolutionStatus
    - dim_date.datevalue_date
    pivots:
    - vw_escal_detail_prod.resolutionStatus
    fill_fields:
    - vw_escal_detail_prod.resolutionStatus
    - dim_date.datevalue_date
    filters:
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
      # dim_date.governmentdefinedacademicterm: Fall 2018
      # vw_escal_categories_prod.category: Software
      # vw_escal_components_prod.topSystem: 'Yes'
    sorts:
    - vw_escal_detail_prod.resolutionStatus desc
    - dim_date.datevalue_date desc
    limit: 500
    column_limit: 50
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Number of issues created
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: 'Yes'
        name: Closed issues
        axisId: vw_escal_detail_prod.count
      - id: 'No'
        name: Open issues
        axisId: vw_escal_detail_prod.count
    x_axis_label: Day
    totals_rotation: 0
    series_labels:
      No - vw_escal_detail_prod.count: Not resolved
      Yes - vw_escal_detail_prod.count: Resolved
    column_group_spacing_ratio:
    listen:
      Data range: dim_date.governmentdefinedacademicterm
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 12
    col: 0
    width: 21
    height: 6
  - name: ESCALs created per day, by priority
    title: ESCALs created per day, by priority
    model: jira
    explore: vw_escal_detail_prod
    type: looker_column
    fields:
    - dim_date.datevalue_date
    - vw_escal_detail_prod.priority
    - vw_escal_detail_prod.count
    pivots:
    - vw_escal_detail_prod.priority
    fill_fields:
    - dim_date.datevalue_date
    filters:
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
    sorts:
    - dim_date.datevalue_date desc
    - vw_escal_detail_prod.priority
    limit: 500
    column_limit: 50
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    column_spacing_ratio:
    column_group_spacing_ratio:
    y_axes:
    - label: Number of issues created
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: P1 Escalation
        name: P1 Escalation
        axisId: vw_escal_detail_prod.count
      - id: P2 Escalation
        name: P2 Escalation
        axisId: vw_escal_detail_prod.count
      - id: P3 Escalation
        name: P3 Escalation
        axisId: vw_escal_detail_prod.count
    x_axis_label: Day
    totals_rotation: 0
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    listen:
      Data range: dim_date.governmentdefinedacademicterm
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 5
    col: 0
    width: 21
    height: 7
  - name: ESCALs Still unresolved by System and Priority
    title: ESCALs Still unresolved by System and Priority
    model: jira
    explore: vw_escal_detail_prod
    type: table
    fields:
    - vw_escal_components_prod.component
    - vw_escal_detail_prod.priority
    - vw_escal_detail_prod.count
    filters:
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
      vw_escal_detail_prod.resolutionStatus: 'No'
      # vw_escal_components_prod.topSystem: 'Yes'
    sorts:
    - vw_escal_components_prod.component
    limit: 500
    column_limit: 50
    total: true
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Total issues
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom:
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: Fall 2017
        name: Fall 2017
        axisId: vw_escal_detail_prod.count
      - id: Fall 2018
        name: Fall 2018
        axisId: vw_escal_detail_prod.count
    x_axis_label: Week
    totals_rotation: 0
    series_labels:
      vw_escal_components_prod.component: Component
      vw_escal_detail_prod.priority: Priority
      vw_escal_detail_prod.count: Issues
      vw_escal_categories_prod.category: Category
    listen:
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 49
    col: 0
    width: 11
    height: 9
  - name: ESCALs Aging Table
    title: ESCALs Aging Table
    model: jira
    explore: vw_escal_detail_prod
    type: table
    fields:
    - vw_escal_components_prod.component
    - vw_escal_detail_prod.priority
    - vw_escal_detail_prod.count
    - vw_escal_detail_prod.age_bins
    pivots:
    - vw_escal_detail_prod.age_bins
    fill_fields:
    - vw_escal_detail_prod.age_bins
    filters:
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation,P4
        Escalation
      vw_escal_detail_prod.resolutionStatus: 'No'
    sorts:
    - vw_escal_detail_prod.age_bins 0
    - vw_escal_components_prod.component
    limit: 500
    column_limit: 50
    show_view_names: true
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Total issues
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom:
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: Fall 2017
        name: Fall 2017
        axisId: vw_escal_detail_prod.count
      - id: Fall 2018
        name: Fall 2018
        axisId: vw_escal_detail_prod.count
    x_axis_label: Week
    totals_rotation: 0
    series_labels:
      vw_escal_components_prod.component: Component
      vw_escal_detail_prod.priority: Priority
      vw_escal_detail_prod.count: Issues
      vw_escal_detail_prod.age_bins: Age, hours
    listen:
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 49
    col: 11
    width: 13
    height: 9
  - name: ESCAL tickets statistics
    type: text
    title_text: ESCAL tickets statistics
    subtitle_text: Number of issues created, closed in time, etc.
    body_text: |-
      The ESCAL project tracks the issues raised by customers of Cengage products.

      Each ticket logged is assigned priority, or Escalation, from P1 to P4. The ones with escalation P1 are the most important. Each escalation category has some maximum time set it should take to resolve the ticket.

      Note: here the notation is used in which 'Fall 2018' is the period from September to December of 2017.
    row: 0
    col: 0
    width: 24
    height: 5
  - name: Escals created per day
    type: text
    title_text: Escals created per day
    subtitle_text: for the current semester
    body_text: |-
      On these two graphs we show the total number of issues created during each day of the current semester.

      On the first chart those tickets are distinguished by priority - P1, P2 or P3 (P4 are not shown).

      On the second chart the same issues are distinguished by whether they have been resolved up to now: they are considered Resolved, if their 'Resolved' date field is not empty (null).

      Click on a chip below the chart to toggle displaying any category
    row: 5
    col: 21
    width: 3
    height: 13
  - name: ESCALs created per day
    type: text
    title_text: ESCALs created per day
    subtitle_text: for the past month
    body_text: |-
      The same charts as above but for the past month only, for better visibility.

      On the first chart the tickets are grouped by priority, on the second chart by the current status, 'resolved' or not.

      Click on a chip below the chart to toggle displaying any category
    row: 18
    col: 0
    width: 6
    height: 15
  - name: ESCALS created per week
    type: text
    title_text: ESCALS created per week
    subtitle_text: for the current semester
    body_text: "The chart shows the total number of tickets logged in a week from\
      \ the start of the current semester. \n\nOn the first chart the issues are grouped\
      \ by their current status - resolved or not.\n\nOn the second chart the same\
      \ data is compared with that for the previous year.\n\nClick on a chip to toggle\
      \ displaying a category."
    row: 33
    col: 15
    width: 9
    height: 8
  - name: ESCALs created per week, comparison between Spring 2017 and Spring 2018
    title: ESCALs created per week, comparison between Spring 2017 and Spring 2018
    model: jira
    explore: vw_escal_detail_prod
    type: looker_line
    fields:
    - vw_escal_detail_prod.count
    - dim_date.governmentdefinedacademicterm
    - dim_date.isoweekofyearid
    pivots:
    - dim_date.governmentdefinedacademicterm
    filters:
      dim_date.governmentdefinedacademicterm: Spring 2017,Spring 2018
      vw_escal_detail_prod.priority: P1 Escalation,P2 Escalation,P3 Escalation
    sorts:
    - dim_date.governmentdefinedacademicterm 0
    - dim_date.isoweekofyearid
    limit: 500
    column_limit: 50
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_ignored_fields: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    column_spacing_ratio:
    y_axes:
    - label: Number of issues
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom:
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: Fall 2017
        name: Fall 2017
        axisId: vw_escal_detail_prod.count
      - id: Fall 2018
        name: Fall 2018
        axisId: vw_escal_detail_prod.count
    x_axis_label: Week start
    totals_rotation: 0
    listen:
      Category: vw_escal_categories_prod.category
      System: vw_escal_components_prod.topSystem
      Component: vw_escal_components_prod.component
    row: 41
    col: 13
    width: 11
    height: 8
  filters:
  - name: Data range
    title: Data range
    type: field_filter
    default_value: Spring 2018
    model: jira
    explore: vw_escal_detail_prod
    field: dim_date.governmentdefinedacademicterm
    listens_to_filters: []
    allow_multiple_values: true
    required: false
  - name: Category
    title: Category
    type: field_filter
    default_value: Software
    model: jira
    explore: vw_escal_detail_prod
    field: vw_escal_categories_prod.category
    listens_to_filters: []
    allow_multiple_values: true
    required: false
  - name: System
    title: System
    type: field_filter
    default_value: 'Yes'
    model: jira
    explore: vw_escal_detail_prod
    field: vw_escal_components_prod.topSystem
    listens_to_filters: []
    allow_multiple_values: true
    required: false
  - name: Component
    title: Component
    type: field_filter
    default_value: "-NULL"
    model: jira
    explore: vw_escal_detail_prod
    field: vw_escal_components_prod.component
    listens_to_filters: []
    allow_multiple_values: true
    required: false
