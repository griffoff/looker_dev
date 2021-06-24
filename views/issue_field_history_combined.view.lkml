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
        ifh.field_id as field_id
        , ifh.issue_id as issue_id
        , ifh.time as time
        , ifh.author_id as author_id
        , ifh._fivetran_synced as _fivetran_synced
        , coalesce(e.key, s.name, sp.name, c.name, fo.name, ifh.value) as value
        , lead(ifh.time) over(partition by ifh.field_id,ifh.issue_id order by ifh.time) is null as _latest
      from ${issue_field_history.SQL_TABLE_NAME} ifh
      left join ${field.SQL_TABLE_NAME} f on f.id = ifh.field_id
      left join ${epic.SQL_TABLE_NAME} e on e.id = case when f.name = 'Epic Link' then ifh.value::string end
      left join ${status.SQL_TABLE_NAME} s on s.id = case when f.name = 'Status' then ifh.value::string end
      left join ${sprint.SQL_TABLE_NAME} sp on sp.id = case when f.name = 'Sprint' then ifh.value::string end
      left join ${component.SQL_TABLE_NAME} c on c.id = case when f.name = 'Component/s' then ifh.value::string end
      left join ${field_option.SQL_TABLE_NAME} fo on fo.id::string = ifh.value::string
      union all
      select
        imh.field_id
        , imh.issue_id
        , imh.time
        , imh.author_id
        , max(imh._fivetran_synced) as _fivetran_synced
        , nullif(listagg(distinct coalesce(e.key, s.name, sp.name, c.name, fo.name, imh.value),', ')
            within group(order by coalesce(e.key, s.name, sp.name, c.name, fo.name, imh.value)),'') as value
        , lead(imh.time) over(partition by imh.field_id,imh.issue_id order by imh.time) is null as _latest
      from ${issue_multiselect_history.SQL_TABLE_NAME} imh
      left join ${field.SQL_TABLE_NAME} f on f.id = imh.field_id
      left join ${epic.SQL_TABLE_NAME} e on e.id = case when f.name = 'Epic Link' then imh.value::string end
      left join ${status.SQL_TABLE_NAME} s on s.id = case when f.name = 'Status' then imh.value::string end
      left join ${sprint.SQL_TABLE_NAME} sp on sp.id = case when f.name = 'Sprint' then imh.value::string end
      left join ${component.SQL_TABLE_NAME} c on c.id = case when f.name = 'Component/s' then imh.value::string end
      left join ${field_option.SQL_TABLE_NAME} fo on fo.id::string = imh.value::string
      group by 1,2,3,4
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
