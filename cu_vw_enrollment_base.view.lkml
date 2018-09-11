view: cu_vw_enrollment_base {
  derived_table: {
    sql: with
      base AS (
        SELECT DISTINCT
          sub.user_sso_guid AS user_sso_guid
          , sub.course_key AS course_key
          , MIN(sub.local_time) AS earliest_local_time
        FROM
          ${cu_raw_olr_enrollment.SQL_TABLE_NAME} sub
          LEFT OUTER JOIN prod.unlimited.VW_USER_BLACKLIST exc
            ON sub.user_sso_guid = exc.user_sso_guid
        WHERE
          exc.user_sso_guid is null -- not found in exclusions table
        GROUP BY
          sub.user_sso_guid, sub.course_key
      )
      , enrollment AS (
        SELECT DISTINCT
        e._hash
        , e._ldts
        , e._rsrc
        , e.access_role
        , e.course_key
        , to_date(e.local_time) AS local_time
        , e.message_format_version
        , e.message_type
        , e.platform_environment
        , e.product_platform
        , e.user_environment
        , e.user_sso_guid
        FROM
          ${cu_raw_olr_enrollment.SQL_TABLE_NAME} AS e
          INNER JOIN base
            ON e.user_sso_guid = base.user_sso_guid AND e.course_key = base.course_key AND e.local_time = base.earliest_local_time
          INNER JOIN prod.STG_CLTS.OLR_COURSES c
            ON e.course_key = c."#CONTEXT_ID"
        WHERE
          e.access_role like 'STUDENT'  -- only count students
          --AND (c.instructor_guid is null or e.user_sso_guid != c.instructor_guid)  -- disregard instructors who make student accounts
      )

      SELECT * FROM enrollment
      ;;
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
      _hash,
      _ldts_time,
      _rsrc,
      access_role,
      course_key,
      local_time_time,
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
