view: cu_vw_provisioned_product_base {
  derived_table: {
    sql: with
    first AS (
    SELECT distinct
      user_sso_guid,
      context_id,
      FIRST_VALUE(_hash) OVER (PARTITION BY user_sso_guid, CONTEXT_ID ORDER BY LOCAL_TIME) AS first_hash
    FROM prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT --${cu_raw_olr_provisioned_product.SQL_TABLE_NAME}

    )

    SELECT
      pp.*
    FROM
      prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT pp
      --${cu_raw_olr_provisioned_product.SQL_TABLE_NAME} pp
      INNER JOIN first ON pp.user_sso_guid like first.user_sso_guid AND case when (pp.context_id is null and first.context_id is null) or pp.context_id = first.context_id then true else false end  AND pp._hash like first.first_hash
      LEFT OUTER JOIN prod.unlimited.EXCLUDED_USERS exc ON pp.user_sso_guid = exc.user_sso_guid
      where exc.user_sso_guid is null
      ;;
  }

  dimension: _hash {
    type: string
    sql: ${TABLE}."_HASH" ;;
  }

  dimension_group: _ldts {
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
    sql: ${TABLE}."_LDTS" ;;
  }

  dimension: _rsrc {
    type: string
    sql: ${TABLE}."_RSRC" ;;
  }

  dimension: code_type {
    type: string
    sql: ${TABLE}."CODE_TYPE" ;;
  }

  dimension: context_id {
    type: string
    sql: ${TABLE}."CONTEXT_ID" ;;
  }

  dimension: core_text_isbn {
    type: string
    sql: ${TABLE}."CORE_TEXT_ISBN" ;;
  }

  dimension_group: date_added {
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
    sql: ${TABLE}."DATE_ADDED" ;;
  }

  dimension_group: expiration {
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
    sql: ${TABLE}."EXPIRATION_DATE" ;;
  }

  dimension: iac_isbn {
    type: string
    sql: ${TABLE}."IAC_ISBN" ;;
  }

  dimension: institution_id {
    type: string
    sql: ${TABLE}."INSTITUTION_ID" ;;
  }

  dimension_group: local {
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
    sql: ${TABLE}."LOCAL_TIME" ;;
  }

  dimension: message_format_version {
    type: number
    sql: ${TABLE}."MESSAGE_FORMAT_VERSION" ;;
  }

  dimension: message_type {
    type: string
    sql: ${TABLE}."MESSAGE_TYPE" ;;
  }

  dimension: platform_environment {
    type: string
    sql: ${TABLE}."PLATFORM_ENVIRONMENT" ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: product_platform {
    type: string
    sql: ${TABLE}."PRODUCT_PLATFORM" ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}."REGION" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  dimension: source_id {
    type: string
    sql: ${TABLE}."SOURCE_ID" ;;
  }

  dimension: user_environment {
    type: string
    sql: ${TABLE}."USER_ENVIRONMENT" ;;
  }

  dimension: user_sso_guid {
    type: string
    sql: ${TABLE}."USER_SSO_GUID" ;;
  }

  dimension: user_type {
    type: string
    sql: ${TABLE}."USER_TYPE" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
