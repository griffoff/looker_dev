view: cu_vw_enrollment_payments_30 {
  derived_table: {
    sql: with
        days AS (
          SELECT
            DATEVALUE AS day
          FROM
            ${dim_date.SQL_TABLE_NAME}
          WHERE
            DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2)))
          ORDER BY
            DATEVALUE
        )
        , res AS (
          SELECT
            days.day
            , _all.*
          FROM
            days, ${cu_vw_enrollment_payments.SQL_TABLE_NAME} _all
          WHERE _all.local_time <= days.day
        )

        SELECT * FROM res

        ;;
  }

  dimension: day {
    type: date
    sql: ${TABLE}."day" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension: _hash {
    type: string
    sql: ${TABLE}."_hash" ;;
  }

  dimension_group: _ldts {
    type: time
    sql: ${TABLE}."_ldts" ;;
  }

  dimension: _rsrc {
    type: string
    sql: ${TABLE}."_rsrc" ;;
  }

  dimension: access_role {
    type: string
    sql: ${TABLE}."access_role" ;;
  }

  dimension: course_key {
    type: string
    sql: ${TABLE}."course_key" ;;
  }

  dimension_group: local_time {
    type: time
    sql: ${TABLE}."local_time" ;;
  }

  dimension: message_format_version {
    type: number
    sql: ${TABLE}."message_format_version" ;;
  }

  dimension: message_type {
    type: string
    sql: ${TABLE}."message_type" ;;
  }

  dimension: platform_environment {
    type: string
    sql: ${TABLE}."platform_environment" ;;
  }

  dimension: product_platform {
    type: string
    sql: ${TABLE}."product_platform" ;;
  }

  dimension: user_environment {
    type: string
    sql: ${TABLE}."user_environment" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."user_sso_guid" ;;
  }

  set: detail {
    fields: [
      day,
      status,
      _hash,
      _ldts_time,
      _rsrc,
      access_role,
      course_key,
      local_time_date,
      message_format_version,
      message_type,
      platform_environment,
      product_platform,
      user_environment,
      user_sso_guid
    ]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
}
