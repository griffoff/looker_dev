- dashboard: cu_statistics
  title: Cengage Unlimited Metrics
  layout: newspaper
  elements:
  - name: Products_Daily_ByState
      state
    title: C1. Number of provisioned products for all users, for each day, by subscription
      state
    model: cu_statistics
    explore: a_p_p
    type: looker_column
    fields:
    - a_p_p.count_e
    - a_p_p.state
    - a_p_p.local_time_date
    pivots:
    - a_p_p.state
    fill_fields:
    - a_p_p.local_time_date
    filters:
      a_p_p.local_time_date: 30 days
      a_p_p.sourse: unlimited
      a_p_p.user_type: student
    sorts:
    - a_p_p.local_time_date
    - a_p_p.state 0
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: normal
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_colors:
      full_access - a_p_p.count_e: "#66BB6A"
      trial_access - a_p_p.count_e: "#FFA726"
      a - a_p_p.count_e: "#8ed9f4"
      b - a_p_p.count_e: "#003865"
      c - a_p_p.count_e: "#c61d23"
      a:EMPTY - a_p_p.count_e: "#8ed9f4"
      b:TRIAL - a_p_p.count_e: "#003865"
      c:FULL - a_p_p.count_e: "#c61d23"
    series_labels:
      a - a_p_p.count_e: Other users
      b - a_p_p.count_e: Trial access users
      c - a_p_p.count_e: Full access users
      a:EMPTY - a_p_p.count_e: Other users
      b:TRIAL - a_p_p.count_e: Trial access users
      c:FULL - a_p_p.count_e: Full access users
    series_types: {}
    limit_displayed_rows: false
    x_padding_left: 25
    x_padding_right: 25
    y_axes:
    - label: Number of provisioned products
      orientation: left
      series:
      - id: full_access - a_p_p.count_e
        name: full_access
        axisId: a_p_p.count_e
      - id: trial_access - a_p_p.count_e
        name: trial_access
        axisId: a_p_p.count_e
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
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
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    row: 34
    col: 0
    width: 24
    height: 8
  - name: Subscribers_Daily_ByState
    title: Number of CU users subscribed per day, by state
    model: cu_statistics
    explore: switch_state_prod
    type: looker_column
    fields:
    - switch_state_prod.idd
    - switch_state_prod._start_date
    - switch_state_prod.Number_of_users
    pivots:
    - switch_state_prod.idd
    fill_fields:
    - switch_state_prod._start_date
    filters:
      switch_state_prod._start_date: 30 days
    sorts:
    - switch_state_prod.idd 0
    - switch_state_prod._start_date
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: normal
    colors:
    - 'palette: Santa Cruz'
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_colors:
      only full - switch_state_prod.Number_of_users: "#fc4c02"
      only trial - switch_state_prod.Number_of_users: "#003865"
      trial to full long - switch_state_prod.Number_of_users: "#92278f"
      a - switch_state_prod.Number_of_users: "#003865"
      b - switch_state_prod.Number_of_users: "#fc4c02"
      d - switch_state_prod.Number_of_users: "#f8cc35"
      a:TRIAL - switch_state_prod.Number_of_users: "#003865"
      b:Full Access - Direct Purchase - switch_state_prod.Number_of_users: "#fc4c02"
      d:Full Access - Upgraded - switch_state_prod.Number_of_users: "#f8cc35"
    series_labels:
      only full - switch_state_prod.count_m: Users with only full subscription
      only trial - switch_state_prod.count_m: Users with only trial subscription
      trial to full - switch_state_prod.count_m: Users that changed their subscription
        from trial to full
      only trial - switch_state_prod.Number_of_users: Trial access users
      trial to full long - switch_state_prod.Number_of_users: Full access users A
      only full - switch_state_prod.Number_of_users: Full access users B
      a - switch_state_prod.Number_of_users: Trial access users
      b - switch_state_prod.Number_of_users: Full Access - Direct Purchase
      d - switch_state_prod.Number_of_users: Full Access - Upgraded
      a:TRIAL - switch_state_prod.Number_of_users: Trial access users
      b:Full Access - Direct Purchase - switch_state_prod.Number_of_users: Full Access
        - Direct Purchase
      d:Full Access - Upgraded - switch_state_prod.Number_of_users: Full Access -
        Upgraded
    series_types: {}
    limit_displayed_rows: false
    hidden_series: []
    x_padding_left: 25
    x_padding_right: 25
    y_axes:
    - label: Number of subscriptions
      orientation: left
      series:
      - id: only full - switch_state_prod.count_m
        name: Users with only full subscription
        axisId: switch_state_prod.count_m
      - id: only trial - switch_state_prod.count_m
        name: Users with only trial subscription
        axisId: switch_state_prod.count_m
      - id: trial to full - switch_state_prod.count_m
        name: Users that changed their subscription from trial to full
        axisId: switch_state_prod.count_m
      showLabels: true
      showValues: true
      valueFormat: ''
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    column_group_spacing_ratio: 0.05
    show_totals_labels: true
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
    row: 25
    col: 0
    width: 20
    height: 7
  - name: Legend
    type: text
    title_text: Legend
    subtitle_text: Types of full access users
    body_text: |-
      Full Access - Direct Purchase - the users with full access which never had trial access

      Full Access - Upgraded - the users with full access which upgraded from trial access subscription
    row: 25
    col: 20
    width: 4
    height: 7
  - name: CUMULATIVE_Active_ByState
    title: Total number of active CU users,  by state
    model: cu_statistics
    explore: a_subscriptions
    type: looker_column
    fields:
    - a_subscriptions.day
    - a_subscriptions.subscription_state
    - a_subscriptions.count_users
    pivots:
    - a_subscriptions.subscription_state
    fill_fields:
    - a_subscriptions.day
    filters:
      a_subscriptions.subscription_state: trial^_access,full^_access
      a_subscriptions.day: 30 days
    sorts:
    - a_subscriptions.day
    - a_subscriptions.subscription_state desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: normal
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: circle
    series_colors:
      trial_access - a_subscriptions.count_users: "#003865"
      full_access - a_subscriptions.count_users: "#c61d23"
      provisional_locker - a_subscriptions.count_users: "#8ed9f4"
    series_labels:
      trial_access - a_subscriptions.count_users: Trial access users
      full_access - a_subscriptions.count_users: Full access users
      provisional_locker - a_subscriptions.count_users: Provisional locker users
    series_types: {}
    limit_displayed_rows: false
    x_padding_left: 25
    x_padding_right: 25
    y_axes:
    - label: Number of users
      orientation: left
      series:
      - id: full_access - a_subscriptions.count_users
        name: Full access users
        axisId: a_subscriptions.count_users
      - id: trial_access - a_subscriptions.count_users
        name: Trial access users
        axisId: a_subscriptions.count_users
      showLabels: true
      showValues: true
      valueFormat: ''
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    column_group_spacing_ratio: 0.05
    show_dropoff: false
    show_totals_labels: true
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
    row: 49
    col: 0
    width: 24
    height: 9
  - name: Products_FullAccess_ByProductType
    title: C3. Provisioned to full access users, by product type
    model: cu_statistics
    explore: a_p_p
    type: looker_column
    fields:
    - a_p_p.count_e
    - a_p_p.local_time_date
    - a_p_p.platform
    pivots:
    - a_p_p.platform
    fill_fields:
    - a_p_p.local_time_date
    filters:
      a_p_p.local_time_date: 30 days
      a_p_p.sourse: unlimited
      a_p_p.user_type: student
      a_p_p.state: c:FULL
    sorts:
    - a_p_p.local_time_date
    - a_p_p.platform 0
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: normal
    colors:
    - 'palette: Looker Classic'
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_colors:
      MTC - a_p_p.count_e: "#e0004d"
      MTR - a_p_p.count_e: " #92278f"
      SAMCU - a_p_p.count_e: "#198ec4"
      SMART - a_p_p.count_e: "#8ed9f4"
      SMEB - a_p_p.count_e: "#e4422b"
      APLIA - a_p_p.count_e: "#e8ac25"
      COURSEMATE - a_p_p.count_e: "#c61d23"
      DEV-MATH - a_p_p.count_e: "#1f3e5a"
      CSFI - a_p_p.count_e: "#9fdee0"
      WA3P - a_p_p.count_e: "#c5ebec"
      OWL - a_p_p.count_e: "#3add47"
    series_labels:
      a - a_p_p.count_e: Other users
      b - a_p_p.count_e: Trial access users
      c - a_p_p.count_e: Full access users
      a:EMPTY - a_p_p.count_e: Other users
      b:TRIAL - a_p_p.count_e: Trial access users
      c:FULL - a_p_p.count_e: Full access users
    series_types: {}
    limit_displayed_rows: false
    hidden_series: []
    x_padding_left: 25
    x_padding_right: 25
    y_axes:
    - label: Number of provisioned products
      orientation: left
      series:
      - id: full_access - a_p_p.count_e
        name: full_access
        axisId: a_p_p.count_e
      - id: trial_access - a_p_p.count_e
        name: trial_access
        axisId: a_p_p.count_e
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
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
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    row: 42
    col: 12
    width: 12
    height: 7
  - name: Products_TrialAccess_ByProductType
    title: C2. Provisioned to trial access users, by product type
    model: cu_statistics
    explore: a_p_p
    type: looker_column
    fields:
    - a_p_p.count_e
    - a_p_p.local_time_date
    - a_p_p.platform
    pivots:
    - a_p_p.platform
    fill_fields:
    - a_p_p.local_time_date
    filters:
      a_p_p.local_time_date: 30 days
      a_p_p.sourse: unlimited
      a_p_p.user_type: student
      a_p_p.state: b:TRIAL
    sorts:
    - a_p_p.local_time_date
    - a_p_p.platform 0
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: normal
    colors:
    - 'palette: Looker Classic'
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_colors:
      MTC - a_p_p.count_e: "#e0004d"
      MTR - a_p_p.count_e: " #92278f"
      SAMCU - a_p_p.count_e: "#198ec4"
      SMART - a_p_p.count_e: "#8ed9f4"
      SMEB - a_p_p.count_e: "#e4422b"
      APLIA - a_p_p.count_e: "#e8ac25"
      other - a_p_p.count_e: "#928fb4"
      SAM - a_p_p.count_e: "#9fc190"
      WA - a_p_p.count_e: "#bebebe"
      OWL - a_p_p.count_e: "#3add47"
    series_labels:
      a - a_p_p.count_e: Other users
      b - a_p_p.count_e: Trial access users
      c - a_p_p.count_e: Full access users
      a:EMPTY - a_p_p.count_e: Other users
      b:TRIAL - a_p_p.count_e: Trial access users
      c:FULL - a_p_p.count_e: Full access users
    series_types: {}
    limit_displayed_rows: false
    hidden_series: []
    x_padding_left: 25
    x_padding_right: 25
    y_axes:
    - label: Number of provisioned products
      orientation: left
      series:
      - id: full_access - a_p_p.count_e
        name: full_access
        axisId: a_p_p.count_e
      - id: trial_access - a_p_p.count_e
        name: trial_access
        axisId: a_p_p.count_e
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
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
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    row: 42
    col: 0
    width: 12
    height: 7
  - name: Products_Header
    type: text
    title_text: Number of provisioned products
    subtitle_text: in the last 30 days
    row: 32
    col: 0
    width: 24
    height: 2
  - name: Enrollments_Header
    type: text
    title_text: Information about user enrollments
    subtitle_text: in the last 30 days
    row: 0
    col: 0
    width: 24
    height: 2
  - name: Enrollments_Total_ByPaymentType
    title: A2. Total number of enrollments, by payment type
    model: cu_statistics
    explore: a_no_cu_pay
    type: looker_column
    fields:
    - a_no_cu_pay.day
    - a_no_cu_pay.count_e
    - a_no_cu_pay.status_2
    pivots:
    - a_no_cu_pay.status_2
    fill_fields:
    - a_no_cu_pay.day
    filters:
      a_no_cu_pay.enroll_user_environment: production
      a_no_cu_pay.enroll_platform_environment: production
    sorts:
    - a_no_cu_pay.day
    - a_no_cu_pay.status_2 desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: normal
    show_value_labels: true
    label_density: 25
    font_size: '10'
    legend_position: center
    x_axis_gridlines: true
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_colors:
      Unpaid - a_no_cu_pay.count_e: "#003865"
      Paid - a_no_cu_pay.count_e: "#f8cc35"
      No CU Paid - a_no_cu_pay.count_e: "#fc4c02"
      CU Paid - a_no_cu_pay.count_e: "#f8cc35"
      Paid no CU PAC - a_no_cu_pay.count_e: "#8ed9f4"
      Paid no CU other - a_no_cu_pay.count_e: "#c61d23"
      Paid no CU IAC - a_no_cu_pay.count_e: "#929292"
      Paid no CU - a_no_cu_pay.count_e: "#fc4c02"
    series_labels:
      No CU Paid - a_no_cu_pay.count_e: Paid without CU (regular payment)
      CU Paid - a_no_cu_pay.count_e: Paid via CU
      Paid no CU - a_no_cu_pay.count_e: Paid without CU
    series_types: {}
    limit_displayed_rows: false
    hidden_series: []
    x_padding_left: 25
    x_padding_right: 25
    y_axes:
    - label: Number of enrollment
      orientation: left
      series:
      - id: Unpaid - a_no_cu_pay.count_e
        name: Unpaid
        axisId: a_no_cu_pay.count_e
      - id: Paid - a_no_cu_pay.count_e
        name: Paid
        axisId: a_no_cu_pay.count_e
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    column_group_spacing_ratio: 0.05
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Time range: a_no_cu_pay.day
    row: 13
    col: 0
    width: 24
    height: 12
  - name: Enrollments_Daily_ByPaymentType
    title: A1. Number of new enrollments, for each day, by payment type
    model: cu_statistics
    explore: a_no_cu_pay
    type: looker_column
    fields:
    - a_no_cu_pay.enroll_local_time_date
    - a_no_cu_pay.count_e
    - a_no_cu_pay.status_2
    pivots:
    - a_no_cu_pay.status_2
    fill_fields:
    - a_no_cu_pay.enroll_local_time_date
    filters:
      a_no_cu_pay.enroll_platform_environment: production
      a_no_cu_pay.enroll_user_environment: production
    sorts:
    - a_no_cu_pay.enroll_local_time_date
    - a_no_cu_pay.status_2 desc
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: normal
    show_value_labels: true
    label_density: 25
    legend_position: center
    hide_legend: false
    x_axis_gridlines: true
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_colors:
      Paid - a_no_cu_pay.count_e: "#f8cc35"
      Unpaid - a_no_cu_pay.count_e: "#003865"
      CU Paid - a_no_cu_pay.count_e: "#f8cc35"
      No CU Paid - a_no_cu_pay.count_e: "#fc4c02"
      Paid no CU PAC - a_no_cu_pay.count_e: "#8ed9f4"
      Paid no CU other - a_no_cu_pay.count_e: "#c61d23"
      Paid no CU IAC - a_no_cu_pay.count_e: "#929292"
      Paid no CU - a_no_cu_pay.count_e: "#fc4c02"
    series_labels:
      No CU Paid - a_no_cu_pay.count_e: Paid without CU (regular payment)
      CU Paid - a_no_cu_pay.count_e: Paid, via CU
      Paid no CU - a_no_cu_pay.count_e: Paid, without CU
    series_types: {}
    limit_displayed_rows: false
    hidden_series: []
    x_padding_left: 25
    x_padding_right: 25
    y_axes:
    - label: Number of enrollment
      orientation: left
      series:
      - id: Unpaid - a_no_cu_pay.count_e
        name: Unpaid
        axisId: a_no_cu_pay.count_e
      - id: Paid - a_no_cu_pay.count_e
        name: Paid
        axisId: a_no_cu_pay.count_e
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    x_axis_datetime_label: ''
    x_axis_scale: ordinal
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    column_group_spacing_ratio: 0.05
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Time range: a_no_cu_pay.enroll_local_time_date
    row: 2
    col: 0
    width: 24
    height: 11
  filters:
  - name: Time range
    title: Time range
    type: field_filter
    default_value: 30 days
    allow_multiple_values: true
    required: true
    model: cu_statistics
    explore: a_no_cu_pay
    listens_to_filters: []
    field: a_no_cu_pay.day
