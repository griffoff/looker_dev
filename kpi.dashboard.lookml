- dashboard: kpi
  title: KPI (Cengage systems’ key performance indicators)
  layout: newspaper
  elements:
  - name: Statistics for yesterday
    type: text
    title_text: Statistics for yesterday
    subtitle_text: All charts for the checks run during  yesterday
    body_text: ''
    row: 8
    col: 0
    width: 24
    height: 3
  - name: Number of good and bad statuses by location, for yesterday
    title: Number of good and bad statuses by location, for yesterday
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 2 days
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.LOCATION_NAME
    limit: 500
    column_limit: 50
    stacking: normal
    show_value_labels: true
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
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
      2017-10-23 - vw_kpi_data.count_location_bad: Non-ok statuses
      2017-10-23 - vw_kpi_data.count_location_good: Ok statuses
      2017-11-19 - vw_kpi_data.count_location_bad: non-ok statuses
      2017-11-19 - vw_kpi_data.count_location_good: ok statuses
    series_types: {}
    hidden_fields:
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Number of non-ok statuses
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
      - id: 2017-10-23 - KPI count_location_bad
        name: 2017-10-23 - KPI count_location_bad
      - id: 2017-10-23 - KPI count_location_good
        name: 2017-10-23 - KPI count_location_good
    x_axis_label: Location name
    row: 35
    col: 7
    width: 17
    height: 8
  - name: Number of bad locations' statuses by monitor, for yesterday
    title: Number of bad locations' statuses by monitor, for yesterday
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_services.SERVICE_Long
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 2 days
      vw_kpi_data.count_bad: ">0"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_services.SERVICE
    limit: 500
    column_limit: 50
    stacking: normal
    show_value_labels: true
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
    show_x_axis_ticks: false
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: true
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
      2017-10-23 - vw_kpi_data.count_bad: Non-ok statuses
      2017-10-23 - vw_kpi_data.count_good: Ok statuses
      2017-11-19 - vw_kpi_data.count_good: ok statuses
      2017-11-19 - vw_kpi_data.count_bad: non-ok statuses
    series_types: {}
    hidden_fields:
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Number of non-ok statuses
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
      - id: 2017-10-23 - KPI count_bad
        name: 2017-10-23 - KPI count_bad
      - id: 2017-10-23 - KPI count_good
        name: 2017-10-23 - KPI count_good
    x_axis_label: Service id - name (in alphabetical order)
    x_axis_label_rotation: -22
    label_rotation: 0
    note_state: collapsed
    note_display: above
    note_text: zero values not show
    row: 19
    col: 0
    width: 18
    height: 8
  - name: Statistics for the past week
    type: text
    title_text: Statistics for the past week
    subtitle_text: Monitors and locations
    row: 51
    col: 0
    width: 24
    height: 3
  - name: Average server access time by location, for past week
    title: Average server access time by location, for past week
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_date
    - vw_kpi_data.average_SERVER_TIME
    pivots:
    - vw_kpi_data.LOCATION_NAME
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
      vw_kpi_data.average_TOTAL_TIME: ">10"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.LOCATION_NAME
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average server time
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Location name
    row: 112
    col: 0
    width: 24
    height: 6
  - name: D) Average total access time by location
    title: D) Average total access time by location
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_date
    - vw_kpi_data.average_TOTAL_TIME
    pivots:
    - vw_kpi_data.LOCATION_NAME
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
      vw_kpi_data.average_TOTAL_TIME: ">10"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.average_TOTAL_TIME desc 0
    - vw_kpi_data.LOCATION_NAME
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    ordering: none
    show_null_labels: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average total time, ms
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Location name
    row: 80
    col: 9
    width: 9
    height: 8
  - name: A) Percentage of bad statuses by monitor for past week - alternate view
    title: A) Percentage of bad statuses by monitor for past week - alternate view
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_services.SERVICE_Long
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 7 days
      vw_kpi_data.count_bad: ">5"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_services.SERVICE desc
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_bad}/(${vw_kpi_data.count_good}+${vw_kpi_data.count_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_services.SERVICE
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of bad statuses"
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
      - id: '2018-02-13'
        name: '2018-02-13'
        axisId: calculation_1
      - id: '2018-02-14'
        name: '2018-02-14'
        axisId: calculation_1
      - id: '2018-02-15'
        name: '2018-02-15'
        axisId: calculation_1
      - id: '2018-02-16'
        name: '2018-02-16'
        axisId: calculation_1
      - id: '2018-02-17'
        name: '2018-02-17'
        axisId: calculation_1
      - id: '2018-02-18'
        name: '2018-02-18'
        axisId: calculation_1
    x_axis_label: Service name
    row: 88
    col: 4
    width: 20
    height: 9
  - name: C1) Percentage of bad statuses by location (for past week) - alternate view
    title: C1) Percentage of bad statuses by location (for past week) - alternate
      view
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - calculation_1 desc 0
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of bad statuses"
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
      - id: '2018-02-12'
        name: '2018-02-12'
        axisId: calculation_1
      - id: '2018-02-13'
        name: '2018-02-13'
        axisId: calculation_1
      - id: '2018-02-14'
        name: '2018-02-14'
        axisId: calculation_1
      - id: '2018-02-15'
        name: '2018-02-15'
        axisId: calculation_1
      - id: '2018-02-16'
        name: '2018-02-16'
        axisId: calculation_1
      - id: '2018-02-17'
        name: '2018-02-17'
        axisId: calculation_1
      - id: '2018-02-18'
        name: '2018-02-18'
        axisId: calculation_1
    x_axis_label: Location name
    row: 97
    col: 4
    width: 20
    height: 8
  - name: C) Percentage of bad statuses by location
    title: C) Percentage of bad statuses by location
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.LOCATION_NAME
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
      vw_kpi_data.count_location_good: ">1"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.LOCATION_NAME
    - calculation_1 desc 0
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of bad statuses"
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Location name
    row: 80
    col: 0
    width: 9
    height: 8
  - name: C2) Percentage of bad statuses by location (for past week) - alternate view
      2
    title: C2) Percentage of bad statuses by location (for past week) - alternate
      view 2
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - calculation_1 desc 0
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of bad statuses"
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
      - id: '2018-02-12'
        name: '2018-02-12'
        axisId: calculation_1
      - id: '2018-02-13'
        name: '2018-02-13'
        axisId: calculation_1
      - id: '2018-02-14'
        name: '2018-02-14'
        axisId: calculation_1
      - id: '2018-02-15'
        name: '2018-02-15'
        axisId: calculation_1
      - id: '2018-02-16'
        name: '2018-02-16'
        axisId: calculation_1
      - id: '2018-02-17'
        name: '2018-02-17'
        axisId: calculation_1
      - id: '2018-02-18'
        name: '2018-02-18'
        axisId: calculation_1
    x_axis_label: Location name
    row: 105
    col: 4
    width: 20
    height: 7
  - name: Statistics for the past month
    type: text
    title_text: Statistics for the past month
    subtitle_text: For monitors and locations, statuses and access times
    body_text: ''
    row: 118
    col: 0
    width: 24
    height: 4
  - name: Percentage of bad statuses for the past month, history graph for each location
      - alternate view
    title: Percentage of bad statuses for the past month, history graph for each location
      - alternate view
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - calculation_1 desc 0
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of bad statuses"
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
      - id: '2018-01-20'
        name: '2018-01-20'
        axisId: calculation_1
      - id: '2018-01-21'
        name: '2018-01-21'
        axisId: calculation_1
      - id: '2018-01-22'
        name: '2018-01-22'
        axisId: calculation_1
      - id: '2018-01-23'
        name: '2018-01-23'
        axisId: calculation_1
      - id: '2018-01-24'
        name: '2018-01-24'
        axisId: calculation_1
      - id: '2018-01-25'
        name: '2018-01-25'
        axisId: calculation_1
      - id: '2018-01-26'
        name: '2018-01-26'
        axisId: calculation_1
      - id: '2018-01-27'
        name: '2018-01-27'
        axisId: calculation_1
      - id: '2018-01-28'
        name: '2018-01-28'
        axisId: calculation_1
      - id: '2018-01-29'
        name: '2018-01-29'
        axisId: calculation_1
      - id: '2018-01-30'
        name: '2018-01-30'
        axisId: calculation_1
      - id: '2018-01-31'
        name: '2018-01-31'
        axisId: calculation_1
      - id: '2018-02-01'
        name: '2018-02-01'
        axisId: calculation_1
      - id: '2018-02-02'
        name: '2018-02-02'
        axisId: calculation_1
      - id: '2018-02-03'
        name: '2018-02-03'
        axisId: calculation_1
      - id: '2018-02-04'
        name: '2018-02-04'
        axisId: calculation_1
      - id: '2018-02-05'
        name: '2018-02-05'
        axisId: calculation_1
      - id: '2018-02-06'
        name: '2018-02-06'
        axisId: calculation_1
      - id: '2018-02-07'
        name: '2018-02-07'
        axisId: calculation_1
      - id: '2018-02-08'
        name: '2018-02-08'
        axisId: calculation_1
      - id: '2018-02-09'
        name: '2018-02-09'
        axisId: calculation_1
      - id: '2018-02-10'
        name: '2018-02-10'
        axisId: calculation_1
      - id: '2018-02-11'
        name: '2018-02-11'
        axisId: calculation_1
      - id: '2018-02-12'
        name: '2018-02-12'
        axisId: calculation_1
      - id: '2018-02-13'
        name: '2018-02-13'
        axisId: calculation_1
      - id: '2018-02-14'
        name: '2018-02-14'
        axisId: calculation_1
      - id: '2018-02-15'
        name: '2018-02-15'
        axisId: calculation_1
      - id: '2018-02-16'
        name: '2018-02-16'
        axisId: calculation_1
      - id: '2018-02-17'
        name: '2018-02-17'
        axisId: calculation_1
      - id: '2018-02-18'
        name: '2018-02-18'
        axisId: calculation_1
    x_axis_label: Location name
    row: 159
    col: 0
    width: 24
    height: 8
  - name: C) Percentage of bad statuses by location, for the past month
    title: C) Percentage of bad statuses by location, for the past month
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.LOCATION_NAME
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
      vw_kpi_data.count_location_good: ">1"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.LOCATION_NAME
    - calculation_1 desc 0
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of bad statuses"
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Location name
    row: 149
    col: 0
    width: 9
    height: 10
  - name: Location average server access time, for past month
    title: Location average server access time, for past month
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_date
    - vw_kpi_data.average_SERVER_TIME
    pivots:
    - vw_kpi_data.LOCATION_NAME
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
      vw_kpi_data.average_TOTAL_TIME: ">10"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.LOCATION_NAME
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average server time
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Location name
    row: 167
    col: 0
    width: 24
    height: 7
  - name: A) Percentage of bad statuses by monitor
    title: A) Percentage of bad statuses by monitor
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_services.SERVICE
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
      vw_kpi_data.count_bad: ">5"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_services.SERVICE
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_bad}/(${vw_kpi_data.count_good}+${vw_kpi_data.count_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    x_axis_reversed: false
    hidden_series:
    - '2017-10-19'
    y_axes:
    - label: "% of bad statuses"
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
      - id: 1002 - MyCengage
        name: 1002 - MyCengage
        axisId: calculation_1
      - id: 1003 - SSOOLR.EST-Student.Cloud
        name: 1003 - SSOOLR.EST-Student.Cloud
        axisId: calculation_1
      - id: 1006 - CengageBrain Shop
        name: 1006 - CengageBrain Shop
        axisId: calculation_1
      - id: 1009 - MindTap Techcheck
        name: 1009 - MindTap Techcheck
        axisId: calculation_1
      - id: 1011 - Aplia
        name: 1011 - Aplia
        axisId: calculation_1
      - id: 1015 - CNOWv8 Techcheck
        name: 1015 - CNOWv8 Techcheck
        axisId: calculation_1
      - id: 1022 - SSOOLR.EST-Admin.Cloud
        name: 1022 - SSOOLR.EST-Admin.Cloud
        axisId: calculation_1
      - id: 1023 - SSOOLR.EST-Instructor.Cloud
        name: 1023 - SSOOLR.EST-Instructor.Cloud
        axisId: calculation_1
      - id: 1028 - SAM Techcheck
        name: 1028 - SAM Techcheck
        axisId: calculation_1
      - id: 1032 - Aplia Techcheck
        name: 1032 - Aplia Techcheck
        axisId: calculation_1
      - id: 1033 - CengageBrain Techcheck
        name: 1033 - CengageBrain Techcheck
        axisId: calculation_1
      - id: 1034 - JIRA
        name: 1034 - JIRA
        axisId: calculation_1
      - id: 1036 - 4LTR Press Online v2 Techcheck
        name: 1036 - 4LTR Press Online v2 Techcheck
        axisId: calculation_1
      - id: 1037 - CNOWv7 CVG Techcheck
        name: 1037 - CNOWv7 CVG Techcheck
        axisId: calculation_1
      - id: 1038 - CNOWv7 SJC Techcheck
        name: 1038 - CNOWv7 SJC Techcheck
        axisId: calculation_1
      - id: 1039 - CNOWv7 EAST Techcheck
        name: 1039 - CNOWv7 EAST Techcheck
        axisId: calculation_1
      - id: 1040 - CNOWv7 WEST Techcheck
        name: 1040 - CNOWv7 WEST Techcheck
        axisId: calculation_1
      - id: 1041 - OWLv2 CVG Techcheck
        name: 1041 - OWLv2 CVG Techcheck
        axisId: calculation_1
      - id: 1042 - MindTapMath-DevMath Techcheck
        name: 1042 - MindTapMath-DevMath Techcheck
        axisId: calculation_1
      - id: 1043 - OWLv2 SJC Techcheck
        name: 1043 - OWLv2 SJC Techcheck
        axisId: calculation_1
      - id: 1044 - OWLv2 EAST Techcheck
        name: 1044 - OWLv2 EAST Techcheck
        axisId: calculation_1
      - id: 1045 - OWLv2 WEST Techcheck
        name: 1045 - OWLv2 WEST Techcheck
        axisId: calculation_1
      - id: 1046 - Questia Techcheck
        name: 1046 - Questia Techcheck
        axisId: calculation_1
      - id: 1048 - WebAssign Techcheck
        name: 1048 - WebAssign Techcheck
        axisId: calculation_1
      - id: 1157 - Pathbrite Techcheck
        name: 1157 - Pathbrite Techcheck
        axisId: calculation_1
      - id: 1282 - Techcheck
        name: 1282 - Techcheck
        axisId: calculation_1
      - id: 1314 - myNGconnect Techcheck
        name: 1314 - myNGconnect Techcheck
        axisId: calculation_1
      - id: 1320 - Gateway Health Techcheck
        name: 1320 - Gateway Health Techcheck
        axisId: calculation_1
      - id: 1329 - MindTap School Techcheck
        name: 1329 - MindTap School Techcheck
        axisId: calculation_1
      - id: 1339 - Companion Sites Techcheck
        name: 1339 - Companion Sites Techcheck
        axisId: calculation_1
      - id: 1369 - MindTapMath-DevMath Techcheck
        name: 1369 - MindTapMath-DevMath Techcheck
        axisId: calculation_1
      - id: 1383 - Student Dashboard Techcheck
        name: 1383 - Student Dashboard Techcheck
        axisId: calculation_1
      - id: "∅ - ∅"
        name: "∅ - ∅"
        axisId: calculation_1
    x_axis_label: Date
    row: 70
    col: 0
    width: 9
    height: 10
  - name: A) Percentage of bad statuses by monitor, for the past month
    title: A) Percentage of bad statuses by monitor, for the past month
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_services.SERVICE
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
      vw_kpi_data.count_bad: ">5"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_services.SERVICE
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(100*${vw_kpi_data.count_bad}/(${vw_kpi_data.count_good}+${vw_kpi_data.count_bad}),1)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    x_axis_reversed: false
    hidden_series:
    - '2017-10-19'
    y_axes:
    - label: "% of bad statuses"
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
      - id: 1002 - MyCengage
        name: 1002 - MyCengage
        axisId: calculation_1
      - id: 1003 - SSOOLR.EST-Student.Cloud
        name: 1003 - SSOOLR.EST-Student.Cloud
        axisId: calculation_1
      - id: 1006 - CengageBrain Shop
        name: 1006 - CengageBrain Shop
        axisId: calculation_1
      - id: 1009 - MindTap Techcheck
        name: 1009 - MindTap Techcheck
        axisId: calculation_1
      - id: 1011 - Aplia
        name: 1011 - Aplia
        axisId: calculation_1
      - id: 1015 - CNOWv8 Techcheck
        name: 1015 - CNOWv8 Techcheck
        axisId: calculation_1
      - id: 1018 - Natgeo-dashboard-p
        name: 1018 - Natgeo-dashboard-p
        axisId: calculation_1
      - id: 1022 - SSOOLR.EST-Admin.Cloud
        name: 1022 - SSOOLR.EST-Admin.Cloud
        axisId: calculation_1
      - id: 1023 - SSOOLR.EST-Instructor.Cloud
        name: 1023 - SSOOLR.EST-Instructor.Cloud
        axisId: calculation_1
      - id: 1028 - SAM Techcheck
        name: 1028 - SAM Techcheck
        axisId: calculation_1
      - id: 1032 - Aplia Techcheck
        name: 1032 - Aplia Techcheck
        axisId: calculation_1
      - id: 1033 - CengageBrain Techcheck
        name: 1033 - CengageBrain Techcheck
        axisId: calculation_1
      - id: 1034 - JIRA
        name: 1034 - JIRA
        axisId: calculation_1
      - id: 1036 - 4LTR Press Online v2 Techcheck
        name: 1036 - 4LTR Press Online v2 Techcheck
        axisId: calculation_1
      - id: 1037 - CNOWv7 CVG Techcheck
        name: 1037 - CNOWv7 CVG Techcheck
        axisId: calculation_1
      - id: 1038 - CNOWv7 SJC Techcheck
        name: 1038 - CNOWv7 SJC Techcheck
        axisId: calculation_1
      - id: 1039 - CNOWv7 EAST Techcheck
        name: 1039 - CNOWv7 EAST Techcheck
        axisId: calculation_1
      - id: 1040 - CNOWv7 WEST Techcheck
        name: 1040 - CNOWv7 WEST Techcheck
        axisId: calculation_1
      - id: 1041 - OWLv2 CVG Techcheck
        name: 1041 - OWLv2 CVG Techcheck
        axisId: calculation_1
      - id: 1042 - MindTapMath-DevMath Techcheck
        name: 1042 - MindTapMath-DevMath Techcheck
        axisId: calculation_1
      - id: 1043 - OWLv2 SJC Techcheck
        name: 1043 - OWLv2 SJC Techcheck
        axisId: calculation_1
      - id: 1044 - OWLv2 EAST Techcheck
        name: 1044 - OWLv2 EAST Techcheck
        axisId: calculation_1
      - id: 1045 - OWLv2 WEST Techcheck
        name: 1045 - OWLv2 WEST Techcheck
        axisId: calculation_1
      - id: 1046 - Questia Techcheck
        name: 1046 - Questia Techcheck
        axisId: calculation_1
      - id: 1048 - WebAssign Techcheck
        name: 1048 - WebAssign Techcheck
        axisId: calculation_1
      - id: 1157 - Pathbrite Techcheck
        name: 1157 - Pathbrite Techcheck
        axisId: calculation_1
      - id: 1282 - Techcheck
        name: 1282 - Techcheck
        axisId: calculation_1
      - id: 1314 - myNGconnect Techcheck
        name: 1314 - myNGconnect Techcheck
        axisId: calculation_1
      - id: 1320 - Gateway Health Techcheck
        name: 1320 - Gateway Health Techcheck
        axisId: calculation_1
      - id: 1329 - MindTap School Techcheck
        name: 1329 - MindTap School Techcheck
        axisId: calculation_1
      - id: 1339 - Companion Sites Techcheck
        name: 1339 - Companion Sites Techcheck
        axisId: calculation_1
      - id: 1369 - MindTapMath-DevMath Techcheck
        name: 1369 - MindTapMath-DevMath Techcheck
        axisId: calculation_1
      - id: 1383 - Student Dashboard Techcheck
        name: 1383 - Student Dashboard Techcheck
        axisId: calculation_1
      - id: "∅ - ∅"
        name: "∅ - ∅"
        axisId: calculation_1
    x_axis_label: Date
    row: 137
    col: 0
    width: 9
    height: 12
  - name: Average access times by location, for yesterday
    title: Average access times by location, for yesterday
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.average_SERVER_TIME
    - vw_kpi_data.MODIFIED_date
    - vw_kpi_data.average_NETWORK_TIME
    - vw_kpi_data.average_BROWSER_TIME
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 2 days
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.LOCATION_NAME
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: round(${vw_kpi_data.average_BROWSER_TIME}+${vw_kpi_data.average_NETWORK_TIME}+${vw_kpi_data.average_SERVER_TIME},0)
      value_format:
      value_format_name:
      _kind_hint: measure
      _type_hint: number
    stacking: normal
    show_value_labels: false
    label_density: 22
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
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
      2017-10-22 - vw_kpi_data.average_SERVER_TIME: Server access time
      2017-10-22 - calculation_1: Total access time
      2017-10-23 - vw_kpi_data.average_SERVER_TIME: Average SERVER TIME
      2017-10-23 - vw_kpi_data.average_NETWORK_TIME: Average NETWORK TIME
      2017-10-23 - vw_kpi_data.average_BROWSER_TIME: Average BROWSER TIME
    series_types: {}
    hidden_fields:
    - calculation_1
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average time, ms
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
      - id: 2017-10-22 - KPI Average SERVER_TIME
        name: Server access time
      - id: 2017-10-22 - Calculation 1
        name: Total access time
    x_axis_label: Location name
    column_spacing_ratio:
    show_dropoff: false
    row: 43
    col: 0
    width: 17
    height: 8
  - name: Average server access time, by day of week
    title: Average server access time, by day of week
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.average_SERVER_TIME
    - vw_kpi_data.MODIFIED_day_of_week
    pivots:
    - vw_kpi_data.LOCATION_NAME
    fill_fields:
    - vw_kpi_data.MODIFIED_day_of_week
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
    sorts:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.average_SERVER_TIME desc 0
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
      2017-10-22 - vw_kpi_data.average_SERVER_TIME: Server access time
      2017-10-22 - calculation_1: Total access time
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average server time
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Day of week
    column_spacing_ratio:
    show_dropoff: false
    row: 177
    col: 6
    width: 18
    height: 7
  - name: Average server access time, by hour of day
    title: Average server access time, by hour of day
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_hour_of_day
    - vw_kpi_data.average_SERVER_TIME
    pivots:
    - vw_kpi_data.LOCATION_NAME
    fill_fields:
    - vw_kpi_data.MODIFIED_hour_of_day
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
    sorts:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_hour_of_day
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
      2017-10-22 - vw_kpi_data.average_SERVER_TIME: Server access time
      2017-10-22 - calculation_1: Total access time
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average server time
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Hour of day
    column_spacing_ratio:
    show_dropoff: false
    row: 200
    col: 0
    width: 18
    height: 8
  - name: Average total access time, by hour of day
    title: Average total access time, by hour of day
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_hour_of_day
    - vw_kpi_data.average_TOTAL_TIME
    pivots:
    - vw_kpi_data.LOCATION_NAME
    fill_fields:
    - vw_kpi_data.MODIFIED_hour_of_day
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
    sorts:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_hour_of_day
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
      2017-10-22 - vw_kpi_data.average_SERVER_TIME: Server access time
      2017-10-22 - calculation_1: Total access time
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average total time
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Hour of day
    column_spacing_ratio:
    show_dropoff: false
    row: 192
    col: 0
    width: 18
    height: 8
  - name: Average total access time, by day of week
    title: Average total access time, by day of week
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_day_of_week
    - vw_kpi_data.average_TOTAL_TIME
    pivots:
    - vw_kpi_data.LOCATION_NAME
    fill_fields:
    - vw_kpi_data.MODIFIED_day_of_week
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
    sorts:
    - vw_kpi_data.LOCATION_NAME 0
    - vw_kpi_data.MODIFIED_day_of_week
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
      2017-10-22 - vw_kpi_data.average_SERVER_TIME: Server access time
      2017-10-22 - calculation_1: Total access time
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average total time
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Day of week
    column_spacing_ratio:
    show_dropoff: false
    row: 184
    col: 6
    width: 18
    height: 8
  - name: Average access times during the past month
    type: text
    title_text: Average access times during the past month
    subtitle_text: by hours of day and by days of the week
    body_text: ''
    row: 174
    col: 0
    width: 24
    height: 3
  - name: Percentage of bad locations' statuses by monitor, for yesterday
    title: Percentage of bad locations' statuses by monitor, for yesterday
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_services.SERVICE_Long
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 2 days
      vw_kpi_data.count_bad: ">0"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_services.SERVICE
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: "${vw_kpi_data.count_bad}/(${vw_kpi_data.count_good}+${vw_kpi_data.count_bad})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    stacking: ''
    show_value_labels: true
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
    show_x_axis_ticks: false
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: true
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of non-ok statuses"
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
      - id: '2017-11-19'
        name: '2017-11-19'
        axisId: calculation_1
    x_axis_label: Service id - name (in alphabetical order)
    x_axis_label_rotation: -22
    label_rotation: 0
    row: 11
    col: 0
    width: 18
    height: 8
  - name: Percentage of bad statuses by location, for yesterday
    title: Percentage of bad statuses by location, for yesterday
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    - vw_kpi_data.MODIFIED_date
    pivots:
    - vw_kpi_data.MODIFIED_date
    filters:
      vw_kpi_data.MODIFIED_date: 2 days
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.LOCATION_NAME
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: "${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    stacking: ''
    show_value_labels: true
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
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of non-ok statuses"
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
      - id: '2018-02-18'
        name: '2018-02-18'
        axisId: calculation_1
    x_axis_label: Location name
    row: 27
    col: 7
    width: 17
    height: 8
  - name: D) Average total access time by location, for the past month
    title: D) Average total access time by location, for the past month
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.MODIFIED_date
    - vw_kpi_data.average_TOTAL_TIME
    pivots:
    - vw_kpi_data.LOCATION_NAME
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
      vw_kpi_data.average_TOTAL_TIME: ">10"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.average_TOTAL_TIME desc 0
    - vw_kpi_data.LOCATION_NAME
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    ordering: none
    show_null_labels: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average total time
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
      - id: anexia-atlanta
        name: anexia-atlanta
      - id: anexia-chicago
        name: anexia-chicago
      - id: anexia-dallas
        name: anexia-dallas
      - id: anexia-denver
        name: anexia-denver
      - id: anexia-los-angeles
        name: anexia-los-angeles
      - id: anexia-miami
        name: anexia-miami
      - id: anexia-new-york-city
        name: anexia-new-york-city
      - id: aws-us-east-1
        name: aws-us-east-1
      - id: aws-us-west-1
        name: aws-us-west-1
      - id: kyindpath-wan02
        name: kyindpath-wan02
      - id: mabospath-wan02
        name: mabospath-wan02
      - id: mifampath-wan02
        name: mifampath-wan02
      - id: ohcinpath-cust01
        name: ohcinpath-cust01
      - id: ohcinpath-inet01
        name: ohcinpath-inet01
    x_axis_label: Location name
    row: 149
    col: 9
    width: 9
    height: 10
  - name: B) Average total access time by monitor, for the past month
    title: B) Average total access time by monitor, for the past month
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.MODIFIED_date
    - vw_kpi_data.average_TOTAL_TIME
    - vw_kpi_services.SERVICE_Long
    pivots:
    - vw_kpi_services.SERVICE_Long
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
      vw_kpi_data.average_TOTAL_TIME: ">10"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.average_TOTAL_TIME desc 0
    - vw_kpi_services.SERVICE_Long
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
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    ordering: none
    show_null_labels: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average total time, ms
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
      - id: 1002 - MyCengage
        name: 1002 - MyCengage
      - id: 1003 - SSOOLR.EST-Student.Cloud
        name: 1003 - SSOOLR.EST-Student.Cloud
      - id: 1006 - CengageBrain Shop
        name: 1006 - CengageBrain Shop
      - id: 1007 - CengageBrain DPS
        name: 1007 - CengageBrain DPS
      - id: 1008 - CengageBrain SPS
        name: 1008 - CengageBrain SPS
      - id: 1009 - MindTap Techcheck
        name: 1009 - MindTap Techcheck
      - id: 1010 - ALSv2
        name: 1010 - ALSv2
      - id: 1011 - Aplia
        name: 1011 - Aplia
      - id: 1015 - CNOWv8 Techcheck
        name: 1015 - CNOWv8 Techcheck
      - id: 1016 - Gateway PROD -- Deployment Tool Scenarios
        name: 1016 - Gateway PROD -- Deployment Tool Scenarios
      - id: 1018 - Natgeo-dashboard-p
        name: 1018 - Natgeo-dashboard-p
      - id: 1022 - SSOOLR.EST-Admin.Cloud
        name: 1022 - SSOOLR.EST-Admin.Cloud
      - id: 1023 - SSOOLR.EST-Instructor.Cloud
        name: 1023 - SSOOLR.EST-Instructor.Cloud
      - id: 1024 - SSOOLR.EST-OLRws.Cloud
        name: 1024 - SSOOLR.EST-OLRws.Cloud
      - id: 1025 - SSOOLR.EST-SSOws.Cloud
        name: 1025 - SSOOLR.EST-SSOws.Cloud
      - id: 1028 - SAM Techcheck
        name: 1028 - SAM Techcheck
      - id: 1032 - Aplia Techcheck
        name: 1032 - Aplia Techcheck
      - id: 1033 - CengageBrain Techcheck
        name: 1033 - CengageBrain Techcheck
      - id: 1034 - JIRA
        name: 1034 - JIRA
      - id: 1036 - 4LTR Press Online v2 Techcheck
        name: 1036 - 4LTR Press Online v2 Techcheck
      - id: 1037 - CNOWv7 CVG Techcheck
        name: 1037 - CNOWv7 CVG Techcheck
      - id: 1038 - CNOWv7 SJC Techcheck
        name: 1038 - CNOWv7 SJC Techcheck
      - id: 1039 - CNOWv7 EAST Techcheck
        name: 1039 - CNOWv7 EAST Techcheck
      - id: 1040 - CNOWv7 WEST Techcheck
        name: 1040 - CNOWv7 WEST Techcheck
      - id: 1041 - OWLv2 CVG Techcheck
        name: 1041 - OWLv2 CVG Techcheck
      - id: 1042 - MindTapMath-DevMath Techcheck
        name: 1042 - MindTapMath-DevMath Techcheck
      - id: 1043 - OWLv2 SJC Techcheck
        name: 1043 - OWLv2 SJC Techcheck
      - id: 1044 - OWLv2 EAST Techcheck
        name: 1044 - OWLv2 EAST Techcheck
      - id: 1045 - OWLv2 WEST Techcheck
        name: 1045 - OWLv2 WEST Techcheck
      - id: 1046 - Questia Techcheck
        name: 1046 - Questia Techcheck
      - id: 1047 - LO Difference Engine Techcheck
        name: 1047 - LO Difference Engine Techcheck
      - id: 1048 - WebAssign Techcheck
        name: 1048 - WebAssign Techcheck
      - id: 1157 - Pathbrite Techcheck
        name: 1157 - Pathbrite Techcheck
      - id: 1249 - SSOOLR.EST-OLRws.Cloud STAGE
        name: 1249 - SSOOLR.EST-OLRws.Cloud STAGE
      - id: 1250 - SSOOLR.EST-OLRws.Cloud STAGE
        name: 1250 - SSOOLR.EST-OLRws.Cloud STAGE
      - id: 1252 - SSOOLR.EST-SSOws.Cloud STAGE
        name: 1252 - SSOOLR.EST-SSOws.Cloud STAGE
      - id: 1254 - SSOOLR.EST-SSOws.Cloud STAGE
        name: 1254 - SSOOLR.EST-SSOws.Cloud STAGE
      - id: 1282 - Techcheck
        name: 1282 - Techcheck
      - id: 1311 - LO Difference Engine Ed2go Techcheck
        name: 1311 - LO Difference Engine Ed2go Techcheck
      - id: 1314 - myNGconnect Techcheck
        name: 1314 - myNGconnect Techcheck
      - id: 1317 - IP Geo Locator
        name: 1317 - IP Geo Locator
      - id: 1320 - Gateway Health Techcheck
        name: 1320 - Gateway Health Techcheck
      - id: 1329 - MindTap School Techcheck
        name: 1329 - MindTap School Techcheck
      - id: 1339 - Companion Sites Techcheck
        name: 1339 - Companion Sites Techcheck
      - id: 1369 - MindTapMath-DevMath Techcheck
        name: 1369 - MindTapMath-DevMath Techcheck
      - id: 1383 - Student Dashboard Techcheck
        name: 1383 - Student Dashboard Techcheck
    x_axis_label: Service name
    row: 137
    col: 9
    width: 9
    height: 12
  - name: B) Average total access time by monitor
    title: B) Average total access time by monitor
    model: jira.dev
    explore: vw_kpi_data
    type: looker_line
    fields:
    - vw_kpi_data.MODIFIED_date
    - vw_kpi_data.average_TOTAL_TIME
    - vw_kpi_services.SERVICE_Long
    pivots:
    - vw_kpi_services.SERVICE_Long
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
      vw_kpi_data.average_TOTAL_TIME: ">10"
    sorts:
    - vw_kpi_data.MODIFIED_date 0
    - vw_kpi_data.average_TOTAL_TIME desc 0
    - vw_kpi_services.SERVICE_Long
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
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    ordering: none
    show_null_labels: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields: []
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: Average total time, ms
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
      - id: 1002 - MyCengage
        name: 1002 - MyCengage
      - id: 1003 - SSOOLR.EST-Student.Cloud
        name: 1003 - SSOOLR.EST-Student.Cloud
      - id: 1006 - CengageBrain Shop
        name: 1006 - CengageBrain Shop
      - id: 1007 - CengageBrain DPS
        name: 1007 - CengageBrain DPS
      - id: 1008 - CengageBrain SPS
        name: 1008 - CengageBrain SPS
      - id: 1009 - MindTap Techcheck
        name: 1009 - MindTap Techcheck
      - id: 1010 - ALSv2
        name: 1010 - ALSv2
      - id: 1011 - Aplia
        name: 1011 - Aplia
      - id: 1015 - CNOWv8 Techcheck
        name: 1015 - CNOWv8 Techcheck
      - id: 1016 - Gateway PROD -- Deployment Tool Scenarios
        name: 1016 - Gateway PROD -- Deployment Tool Scenarios
      - id: 1018 - Natgeo-dashboard-p
        name: 1018 - Natgeo-dashboard-p
      - id: 1022 - SSOOLR.EST-Admin.Cloud
        name: 1022 - SSOOLR.EST-Admin.Cloud
      - id: 1023 - SSOOLR.EST-Instructor.Cloud
        name: 1023 - SSOOLR.EST-Instructor.Cloud
      - id: 1024 - SSOOLR.EST-OLRws.Cloud
        name: 1024 - SSOOLR.EST-OLRws.Cloud
      - id: 1025 - SSOOLR.EST-SSOws.Cloud
        name: 1025 - SSOOLR.EST-SSOws.Cloud
      - id: 1028 - SAM Techcheck
        name: 1028 - SAM Techcheck
      - id: 1032 - Aplia Techcheck
        name: 1032 - Aplia Techcheck
      - id: 1033 - CengageBrain Techcheck
        name: 1033 - CengageBrain Techcheck
      - id: 1034 - JIRA
        name: 1034 - JIRA
      - id: 1036 - 4LTR Press Online v2 Techcheck
        name: 1036 - 4LTR Press Online v2 Techcheck
      - id: 1037 - CNOWv7 CVG Techcheck
        name: 1037 - CNOWv7 CVG Techcheck
      - id: 1038 - CNOWv7 SJC Techcheck
        name: 1038 - CNOWv7 SJC Techcheck
      - id: 1039 - CNOWv7 EAST Techcheck
        name: 1039 - CNOWv7 EAST Techcheck
      - id: 1040 - CNOWv7 WEST Techcheck
        name: 1040 - CNOWv7 WEST Techcheck
      - id: 1041 - OWLv2 CVG Techcheck
        name: 1041 - OWLv2 CVG Techcheck
      - id: 1042 - MindTapMath-DevMath Techcheck
        name: 1042 - MindTapMath-DevMath Techcheck
      - id: 1043 - OWLv2 SJC Techcheck
        name: 1043 - OWLv2 SJC Techcheck
      - id: 1044 - OWLv2 EAST Techcheck
        name: 1044 - OWLv2 EAST Techcheck
      - id: 1045 - OWLv2 WEST Techcheck
        name: 1045 - OWLv2 WEST Techcheck
      - id: 1046 - Questia Techcheck
        name: 1046 - Questia Techcheck
      - id: 1047 - LO Difference Engine Techcheck
        name: 1047 - LO Difference Engine Techcheck
      - id: 1048 - WebAssign Techcheck
        name: 1048 - WebAssign Techcheck
      - id: 1157 - Pathbrite Techcheck
        name: 1157 - Pathbrite Techcheck
      - id: 1249 - SSOOLR.EST-OLRws.Cloud STAGE
        name: 1249 - SSOOLR.EST-OLRws.Cloud STAGE
      - id: 1250 - SSOOLR.EST-OLRws.Cloud STAGE
        name: 1250 - SSOOLR.EST-OLRws.Cloud STAGE
      - id: 1252 - SSOOLR.EST-SSOws.Cloud STAGE
        name: 1252 - SSOOLR.EST-SSOws.Cloud STAGE
      - id: 1254 - SSOOLR.EST-SSOws.Cloud STAGE
        name: 1254 - SSOOLR.EST-SSOws.Cloud STAGE
      - id: 1282 - Techcheck
        name: 1282 - Techcheck
      - id: 1311 - LO Difference Engine Ed2go Techcheck
        name: 1311 - LO Difference Engine Ed2go Techcheck
      - id: 1314 - myNGconnect Techcheck
        name: 1314 - myNGconnect Techcheck
      - id: 1317 - IP Geo Locator
        name: 1317 - IP Geo Locator
      - id: 1320 - Gateway Health Techcheck
        name: 1320 - Gateway Health Techcheck
      - id: 1329 - MindTap School Techcheck
        name: 1329 - MindTap School Techcheck
      - id: 1339 - Companion Sites Techcheck
        name: 1339 - Companion Sites Techcheck
      - id: 1369 - MindTapMath-DevMath Techcheck
        name: 1369 - MindTapMath-DevMath Techcheck
      - id: 1383 - Student Dashboard Techcheck
        name: 1383 - Student Dashboard Techcheck
    x_axis_label: Service name
    row: 70
    col: 9
    width: 9
    height: 10
  - name: Percentage of bad statuses by monitor, for the past week
    title: Percentage of bad statuses by monitor, for the past week
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_services.SERVICE_Long
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
      vw_kpi_data.count_bad: ">0"
    sorts:
    - vw_kpi_services.SERVICE
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: "${vw_kpi_data.count_bad}/(${vw_kpi_data.count_good}+${vw_kpi_data.count_bad})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    stacking: ''
    show_value_labels: true
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
    show_x_axis_ticks: false
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: true
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of non-ok statuses"
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
      - id: calculation_1
        name: "% of bad status"
    x_axis_label: Service id - name
    x_axis_label_rotation: -22
    label_rotation: 0
    row: 54
    col: 6
    width: 18
    height: 8
  - name: Percentage of bad statuses by monitor, for the past month
    title: Percentage of bad statuses by monitor, for the past month
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_services.SERVICE_Long
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
      vw_kpi_data.count_bad: ">0"
    sorts:
    - vw_kpi_services.SERVICE
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: "${vw_kpi_data.count_bad}/(${vw_kpi_data.count_good}+${vw_kpi_data.count_bad})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    stacking: ''
    show_value_labels: true
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
    show_x_axis_ticks: false
    x_axis_scale: auto
    y_axis_scale_mode: linear
    ordering: none
    show_null_labels: true
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_bad
    - vw_kpi_data.count_good
    - vw_kpi_services.SERVICE
    - vw_kpi_services.SERVICE_ID
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of non-ok statuses"
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
      - id: calculation_1
        name: "% of bad status"
    x_axis_label: Service id - name
    x_axis_label_rotation: -22
    label_rotation: 0
    row: 122
    col: 6
    width: 18
    height: 8
  - name: Percentage of bad statuses by location, for the past month
    title: Percentage of bad statuses by location, for the past month
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    filters:
      vw_kpi_data.MODIFIED_date: 31 days
    sorts:
    - vw_kpi_data.LOCATION_NAME
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: "${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    stacking: ''
    show_value_labels: true
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
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of non-ok statuses"
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
      - id: calculation_1
        name: "% of bad status"
        axisId: calculation_1
    x_axis_label: Location name
    row: 130
    col: 6
    width: 18
    height: 7
  - name: Percentage of bad statuses by location, for the past week
    title: Percentage of bad statuses by location, for the past week
    model: jira.dev
    explore: vw_kpi_data
    type: looker_column
    fields:
    - vw_kpi_data.LOCATION_NAME
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    filters:
      vw_kpi_data.MODIFIED_date: 8 days
    sorts:
    - vw_kpi_data.LOCATION_NAME
    limit: 500
    column_limit: 50
    dynamic_fields:
    - table_calculation: calculation_1
      label: Calculation 1
      expression: "${vw_kpi_data.count_location_bad}/(${vw_kpi_data.count_location_good}+${vw_kpi_data.count_location_bad})"
      value_format:
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: number
    stacking: ''
    show_value_labels: true
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
    show_null_points: true
    point_style: none
    interpolation: linear
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: editable
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      calculation_1: "% of bad status"
    series_types: {}
    hidden_fields:
    - vw_kpi_data.count_location_bad
    - vw_kpi_data.count_location_good
    x_axis_reversed: false
    hidden_series: []
    y_axes:
    - label: "% of non-ok statuses"
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
      - id: calculation_1
        name: "% of bad status"
        axisId: calculation_1
    x_axis_label: Location name
    row: 62
    col: 6
    width: 18
    height: 8
  - name: Portion of bad locations' statuses by monitor
    type: text
    title_text: Portion of bad locations' statuses by monitor
    subtitle_text: Percentages and absolute numbers for yesterday
    body_text: |-
      A monitor's health is the ratio of locations reporting status 'OK' during some check cycle to the total number of its locations. For a monitor with N locations there are 288*N checks run daily.

      The first chart shows the percentage of all the checks run yesterday which returned 'bad' status, i.e. the status different from 'OK', for each monitor.

      The second chart show the absolute numbers of those check’s reported statuses, good (‘OK’) versus bad (any other status), during yesterday, and their total number, for each monitor.

      The systems are arranged on the charts in alphabetical order. Hover the mouse over a bar to see the system's name and Service ID.

      Click on a chip under the chart to toggle showing corresponding data
    row: 11
    col: 18
    width: 6
    height: 16
  - name: Portion of bad location responses by location
    type: text
    title_text: Portion of bad location responses by location
    subtitle_text: Percentages and absolute numbers, for yesterday
    body_text: |-
      In these two charts we present the same data aggregated for each location instead of per monitor:

      The first chart shows the percentage of bad responses for each of the available locations (summed over all monitors), for the checks run yesterday

      The second chart shows the absolute numbers of good ('OK') reported statuses versus the bad ones (all other statuses), and the total number of checks.

      Click on a chip under the chart to toggle showing corresponding data
    row: 27
    col: 0
    width: 7
    height: 16
  - name: Location average access times, for yesterday
    type: text
    title_text: Location average access times, for yesterday
    subtitle_text: Total time = server time + network time + browser time
    body_text: |-
      For each location we show the total access time and its constituents, averaged over yesterday and all monitors

      Hover over a bar to see the numerical values of average server, network, and browser times.

      Click on a chip under the graph to toggle showing the corresponding times.
    row: 43
    col: 17
    width: 7
    height: 8
  - name: Access times by hour of day
    type: text
    title_text: Access times by hour of day
    subtitle_text: averaged over the past month
    body_text: |-
      For each location we take the access times measured during all the checks run during a particular hour of the day, e.g. from 15 pm to 16 pm, for the past month, and take the average.

      The first chart shows the average total access time for each location versus the hour of the day the check was run on.

      The second chart shows the average server access time for each location versus the hour of the day the check was run on.

      You can click on any location's chip below the chart to toggle showing that location's line on it.
    row: 192
    col: 18
    width: 6
    height: 16
  - name: Access times by day of the week
    type: text
    title_text: Access times by day of the week
    subtitle_text: averaged over the past month
    body_text: |-
      For each location we take the access times measured during all the checks run during a particular day of the week, e.g. Wednesday, for the past month, and take the average.

      The first chart shows the average total access time for each location versus the day of the week the check was run on.

      The second chart shows the average server access time for each location versus the day of the week the check was run on.

      You can click on any location’s chip below the chart to toggle showing that location’s line on it.
    row: 177
    col: 0
    width: 6
    height: 15
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      Each check reports on the system's availability, and also the total access time to the system, which is the sum of server time, network time, and browser time.

      During a day, there are 288 checks run from each location for a monitor. So for a monitor with N locations there are 288xN checks run daily, 2016xN weekly, and 8640xN monthly.

      This dashboard shows by default the statistics for pubic facing systems. You can change that to view all non-public facing systems instead using the filter at the top of the page
    row: 0
    col: 12
    width: 12
    height: 8
  - name: The KPI dashboard
    type: text
    title_text: The KPI dashboard
    subtitle_text: Statistics for key performance indicators of Cengage's systems
    body_text: "A monitor is a collection of scripts which run regularly to check\
      \ and report on the status of a platform or system. \n\nEach such script is\
      \ run on a server in one of the available locations, to check for accessibility\
      \ of that platform from different geographical locations, one script for a monitor\
      \ per location. Different monitors have different numbers of locations configured,\
      \ ranging from 1 to 8.\n\nThe scripts are run in cycles, one cycle each 5-minute\
      \ time interval, e.g. from 10:25 am to 10:30 am. So for a monitor with N locations\
      \ there are N*288 such scripts run daily.\n\nA monitor's status for a given\
      \ check cycle is determined primarily by its 'health', which is the ratio of\
      \ locations having reported status 'OK' to the total number of that monitor's\
      \ configured locations."
    row: 0
    col: 0
    width: 12
    height: 8
  - name: Overall average status for the past week
    type: text
    title_text: Overall average status for the past week
    subtitle_text: Per monitor and per location
    body_text: |-
      The two charts show the percentage of bad responses (i.e. all different from 'OK') reported during all of the past week.

      The first chart shows the data for monitors, summed over all locations. The systems are arranged in alphabetical order. Hover the mouse over a bar to see the system’s name and Service ID.

      The second chart shows the data for locations, summed over all monitors
    row: 54
    col: 0
    width: 6
    height: 16
  - name: Dynamics for the past week
    type: text
    title_text: Dynamics for the past week
    subtitle_text: Statuses and total access times
    body_text: |-
      The four charts showing dynamics of systems performance: the statuses and total access times, reported on average for all locations and for all monitors.

      A (top left): percentage of bad statuses reported for each monitor daily, as function of time (for each day, summed over all locations)

      B (top right): total access time to a monitor, averaged over a day and for all locations

      C (bottom left): percentage of bad statuses reported for each location daily, as function of time (for each day, summed over all monitors)

      D (bottom right): total access time reported by a location, averaged over a day and for all monitors

      Click on any chip under a chart to toggle displaying the corresponding line on the chart. Hover the mouse over any line to see the legend
    row: 70
    col: 18
    width: 6
    height: 18
  - name: Alternate views
    type: text
    title_text: Alternate views
    subtitle_text: Percentage of bad statuses
    body_text: |-
      Each bar group shows the dynamics for the past week of the percentage of bad statuses

      A: by monitors, summed over all locations

      C1: by locations, summed over all monitors

      C2: the same as above but with one common timeline
    row: 88
    col: 0
    width: 4
    height: 24
  - name: Overall average status for the past month
    type: text
    title_text: Overall average status for the past month
    subtitle_text: By monitors and by locations
    body_text: |-
      The two charts show the percentage of bad responses (i.e. all different from ‘OK’) reported during all of the past month.

      The first chart shows the data for monitors, summed over all locations. The systems are arranged in alphabetical order. Hover the mouse over a bar to see the system’s name and Service ID.

      The second chart shows the data for locations, summed over all monitors
    row: 122
    col: 0
    width: 6
    height: 15
  - name: Dynamics for the past month
    type: text
    title_text: Dynamics for the past month
    subtitle_text: Statuses and total access times
    body_text: |-
      The four charts showing dynamics of systems performance: the statuses and total access times, reported on average for all locations and for all monitors.

      A (top left): percentage of bad statuses reported for each monitor daily, as function of time (for each day, summed over all locations)

      B (top right): total access time to a monitor, averaged over a day and for all locations

      C (bottom left): percentage of bad statuses reported for each location daily, as function of time (for each day, summed over all monitors)

      D (bottom right): total access time reported by a location, averaged over a day and for all monitors

      Click on any chip under a chart to toggle displaying the corresponding line on the chart. Hover the mouse over any line to see the legend
    row: 137
    col: 18
    width: 6
    height: 22
