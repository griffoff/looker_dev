view: a_temporary_problem {
  derived_table: {
    sql: with temp as(SELECT _hash, user_sso_guid, iac_isbn, context_id, source_id, local_time FROM prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT where source_id like 'TEMPORARY'
      and platform_environment like 'production'
      and user_environment like 'production'
      and user_type like 'student')

      , not_temp as (select
      'Contract_ID updated later to valid value' as _type
      , temp._hash as old_hash
      , pp._hash as new_hash
      ,  temp.user_sso_guid,
      temp.iac_isbn
      , temp.context_id
      , temp.source_id as old_source
      , pp.source_id as new_source
      , temp.local_time as temp_time
      , pp.local_time  as new_time
      FROM prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT pp, temp
      where pp.user_sso_guid = temp.user_sso_guid
      and temp.iac_isbn = pp.iac_isbn
      and temp.context_id = pp.context_id
      and new_time > temp_time
      )

      , bad as (
      select 'Contract_ID never updated' as _type
      , temp._hash as old_hash
      , null as new_hash
      ,  temp.user_sso_guid,
      temp.iac_isbn
      , temp.context_id
      , temp.source_id as old_source
      , null as new_source
      , temp.local_time as temp_time
      , null  as new_time
      from temp where user_sso_guid not in (select user_sso_guid from not_temp))

      , res as (
      select * from not_temp
      union
      select * from bad

      )

      select * from res
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: _type {
    type: string
    sql: ${TABLE}."_TYPE" ;;
  }

  dimension: old_hash {
    type: string
    sql: ${TABLE}."OLD_HASH" ;;
  }

  dimension: new_hash {
    type: string
    sql: ${TABLE}."NEW_HASH" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: iac_isbn {
    type: string
    sql: ${TABLE}."IAC_ISBN" ;;
  }

  dimension: context_id {
    type: string
    sql: ${TABLE}."CONTEXT_ID" ;;
  }

  dimension: old_source {
    type: string
    sql: ${TABLE}."OLD_SOURCE" ;;
  }

  dimension: new_source {
    type: string
    sql: ${TABLE}."NEW_SOURCE" ;;
  }

  dimension_group: temp_time {
    type: time
    sql: ${TABLE}."TEMP_TIME" ;;
  }

  dimension_group: new_time {
    type: time
    sql: ${TABLE}."NEW_TIME" ;;
  }

  set: detail {
    fields: [
      _type,
      old_hash,
      new_hash,
      user_sso_guid,
      iac_isbn,
      context_id,
      old_source,
      new_source,
      temp_time_time,
      new_time_time
    ]
  }
}
