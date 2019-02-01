view: cu_vw_enrollment_payments_30 {
  derived_table: {
    sql: with
        report_days AS (
          SELECT
            DATEVALUE AS report_date
          FROM
            ${dim_date.SQL_TABLE_NAME}
          WHERE
            DATEKEY BETWEEN (TO_CHAR(date_part(year,current_date())) || '0101') AND (TO_CHAR(date_part(year,current_date())) || TO_CHAR(RIGHT('00' || DATE_PART(month,current_date()),2)) || TO_CHAR(RIGHT('00' || DATE_PART(day,current_date()),2)))
          ORDER BY
            DATEVALUE
        )
        , res AS (
          SELECT
            report_days.report_date as report_date
            , _all.*
          FROM
            report_days, ${cu_vw_enrollment_payments.SQL_TABLE_NAME} _all
          WHERE _all.local_time <= report_days.report_date
        )

        SELECT * FROM res

        ;;
  }

  dimension: report_date {
    type: date
    sql: ${TABLE}.report_date ;;

  }

  dimension: report_status {
    type: string
    sql: ${TABLE}.report_status ;;
  }

  dimension: _hash {
    type: string
    sql: ${TABLE}._hash ;;
  }


  dimension: access_role {
    type: string
    sql: ${TABLE}.access_role ;;
  }

  dimension: course_key {
    type: string
    sql: ${TABLE}.course_key ;;
  }

  dimension_group: local_time {
    type: time
    sql: ${TABLE}.local_time ;;
  }


  dimension: product_platform {
    type: string
    sql: ${TABLE}.product_platform ;;
  }



  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}.user_sso_guid ;;
  }

  set: detail {
    fields: [
      report_date,
      report_status,
      _hash,

      access_role,
      course_key,
      local_time_date,

      product_platform,

      user_sso_guid
    ]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  measure: count_distinct {
    type: count_distinct
    drill_fields: [detail*]
    sql: ${_hash} ;;
  }

}
