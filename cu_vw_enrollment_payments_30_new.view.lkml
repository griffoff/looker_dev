view: cu_vw_enrollment_payments_30_new {
  derived_table: {
    sql: with
      paid AS (
        SELECT DISTINCT
          CASE WHEN pp."source" like 'unlimited' THEN 'Paid via CU'
            WHEN (pp."source" like 'gateway' AND pp.code_type like 'Site License User Access') THEN 'Paid via Gateway Site license'
            WHEN (pp."source" is null AND  pp.code_type is null) THEN 'Paid via K12 Site License'
            ELSE 'Other Payment' END AS report_status
          , pp.user_sso_guid as user_sso_guid
          , pp.context_id as course_key
        FROM
          ${cu_vw_provisioned_product_base.SQL_TABLE_NAME} pp
        WHERE
          pp.USER_ENVIRONMENT like 'production'
          AND pp.PLATFORM_ENVIRONMENT like 'production'
          AND (pp.SOURCE_ID is null or pp.SOURCE_ID <> 'Something') -- Filter out testing data from published results
      )
      , paid_no_cu AS (
        SELECT DISTINCT
          'Paid, without CU' as report_status
          , a.user_guid as user_sso_guid
          , a.context_id as course_key
        FROM
          prod.STG_CLTS.ACTIVATIONS_OLR_V a
          LEFT OUTER JOIN paid ON user_sso_guid = paid.user_sso_guid AND course_key = paid.course_key
        WHERE
          paid.user_sso_guid is null
      )
      , unpaid AS (
        SELECT DISTINCT
          'Unpaid' as report_status
          , e.user_sso_guid as user_sso_guid
          , e.course_key as course_key
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
    sql: ${TABLE}."REPORT_STATUS" ;;
  }



  dimension: course_key {
    type: string
    sql: ${TABLE}."COURSE_KEY" ;;
  }




  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  set: detail {
    fields: [
      report_status,
      course_key,
      user_sso_guid
    ]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
}
