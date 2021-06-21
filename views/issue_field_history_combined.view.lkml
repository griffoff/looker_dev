include: "issue_field_history.view"
include: "issue_multiselect_history.view"
include: "/base/common_includes.lkml"
include: "/datagroups.lkml"

explore: issue_field_history_combined {
  hidden: yes
  extends: [root]

  join: issue_field_history_combined {
    sql_on: TRUE ;;
    relationship: one_to_many
  }
}

view: issue_field_history_combined {
  extends: [common_hidden_fields]
  derived_table: {
    publish_as_db_view: yes
    sql:
      select
        field_id
        , issue_id
        , time
        , author_id
        , _fivetran_synced
        , value
        , lead(time) over(partition by field_id,issue_id order by time) is null as _latest
      from ${issue_field_history.SQL_TABLE_NAME}
      union all
      select
        field_id
        , issue_id
        , time
        , author_id
        , _fivetran_synced
        , nullif(listagg(distinct value,', ') within group(order by value),'') as value
        , lead(time) over(partition by field_id,issue_id order by time) is null as _latest
      from ${issue_multiselect_history.SQL_TABLE_NAME}
      group by 1,2,3,4,5
    ;;
    datagroup_trigger: issue_field_history_combined_trigger
  }

  dimension: field_id {hidden:yes}

  dimension: issue_id {hidden:yes}

  dimension_group: time {
    label: "Updated"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}.time AS TIMESTAMP_NTZ) ;;
  }

  dimension: author_id {hidden:yes}

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}._fivetran_synced AS TIMESTAMP_NTZ) ;;
  }

  dimension: value {label:"Value(s)"}

  dimension: _latest {type:yesno hidden:no label:"Latest Field Entry"}

  dimension: pk {
    primary_key: yes
    sql: hash(${field_id},${issue_id},${time_raw},${author_id}${_fivetran_synced_raw},${value});;
    hidden: yes
  }

  measure: count {hidden:yes}

  measure: sample_value {
    sql: any_value(${value}) ;;
  }


}
