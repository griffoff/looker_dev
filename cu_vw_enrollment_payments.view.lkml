view: cu_vw_enrollment_payments {
  derived_table: {
    sql: with
      paid AS (
        SELECT DISTINCT
          CASE WHEN pp."source" like 'unlimited' THEN 'Paid via CU'
            WHEN (pp."source" like 'gateway' AND pp.code_type like 'Site License User Access') THEN 'Paid via Gateway Site license'
            WHEN (pp."source" is null AND  pp.code_type is null) THEN 'Paid via K12 Site License'
            ELSE 'Other Payment' END AS report_status
          , e._hash
          , e._ldts
          , e._rsrc
          , e.access_role
          , e.course_key
          , e.local_time
          , e.message_format_version
          , e.message_type
          , e.platform_environment
          , e.product_platform
          , e.user_environment
          , e.user_sso_guid
        FROM
          ${cu_vw_enrollment_base.SQL_TABLE_NAME} e
          INNER JOIN ${cu_raw_olr_provisioned_product.SQL_TABLE_NAME} pp ON e.user_sso_guid = pp.user_sso_guid AND e.course_key = pp.context_id
        WHERE
          pp.USER_ENVIRONMENT like 'production'
          AND pp.PLATFORM_ENVIRONMENT like 'production'
          AND (pp.SOURCE_ID is null or pp.SOURCE_ID <> 'Something') -- Filter out testing data from published results
      )
      , paid_no_cu AS (
        SELECT DISTINCT
          'Paid, without CU' as report_status
          , e._hash
          , e._ldts
          , e._rsrc
          , e.access_role
          , e.course_key
          , e.local_time
          , e.message_format_version
          , e.message_type
          , e.platform_environment
          , e.product_platform
          , e.user_environment
          , e.user_sso_guid
        FROM
          ${cu_vw_enrollment_base.SQL_TABLE_NAME} e
          INNER JOIN prod.STG_CLTS.ACTIVATIONS_OLR_V a ON e.user_sso_guid = a.user_guid AND e.course_key = a.context_id
          LEFT OUTER JOIN paid ON e.user_sso_guid = paid.user_sso_guid AND e.course_key = paid.course_key
        WHERE
          paid.user_sso_guid is null
      )
      , unpaid AS (
        SELECT DISTINCT
          'Unpaid' as report_status
          , e._hash
          , e._ldts
          , e._rsrc
          , e.access_role
          , e.course_key
          , e.local_time
          , e.message_format_version
          , e.message_type
          , e.platform_environment
          , e.product_platform
          , e.user_environment
          , e.user_sso_guid
        FROM
          ${cu_vw_enrollment_base.SQL_TABLE_NAME} e
          LEFT OUTER JOIN paid ON e.user_sso_guid = paid.user_sso_guid AND e.course_key = paid.course_key
          LEFT OUTER JOIN paid_no_cu ON e.user_sso_guid = paid_no_cu.user_sso_guid AND e.course_key = paid_no_cu.course_key
        WHERE
          paid.user_sso_guid is null
          AND paid_no_cu.user_sso_guid is null
      )
      , _all AS (
        SELECT * FROM paid
        UNION
        SELECT * FROM paid_no_cu
        UNION
        SELECT * FROM unpaid
      )

      SELECT * FROM _all

      ;;
    }

  dimension: report_status {
    type: string
    sql: ${TABLE}."report_status" ;;
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
      report_status,
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
