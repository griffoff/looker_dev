view: check_script {
  derived_table: {
    sql: with fa as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
      SUBSCRIPTION_CONTRACT_ID as SUBSCRIPTION_CONTRACT_ID,
      COURSE_KEY as COURSE_KEY,
      VS_ISBN as vbid
      , CREATED_ON as date_c
      from int.UNLIMITED.SCENARIO_DETAILS
      WHERE CONTAINS(id, 'full_access')
      and CREATED_ON = (select max(CREATED_ON) from int.UNLIMITED.SCENARIO_DETAILS)
      )
      , ta as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
      SUBSCRIPTION_CONTRACT_ID as SUBSCRIPTION_CONTRACT_ID,
      COURSE_KEY as COURSE_KEY,
      VS_ISBN as vbid
      , CREATED_ON as date_c
      from int.UNLIMITED.SCENARIO_DETAILS
      WHERE CONTAINS(id, 'trial_access')
      and CREATED_ON = (select max(CREATED_ON) from int.UNLIMITED.SCENARIO_DETAILS)
      )
      , na as (
      select guid as user_sso_guid,
      uid as id,
      SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
      SUBSCRIPTION_CONTRACT_ID as SUBSCRIPTION_CONTRACT_ID,
      COURSE_KEY as COURSE_KEY,
      VS_ISBN as vbid
      , CREATED_ON as date_c
      from int.UNLIMITED.SCENARIO_DETAILS
      WHERE CONTAINS(id, 'no_cu')
      and CREATED_ON = (select max(CREATED_ON) from int.UNLIMITED.SCENARIO_DETAILS)
      )
      , res_users as(
      select * from fa
      union
      select * from ta
      union
      select * from na
      )
      , res_fa_ta as (

      select distinct res_users.id  as id
      , res_users.user_sso_guid as guid

            , en.course_key as enrollment_course_key
            , res_users.COURSE_KEY as true_courese_key
            , case when enrollment_course_key = true_courese_key then 1 else 0 end as ennrollment_check
            , se.subscription_state as subscription_state
            , res_users.SUBSCRIPTION_STATE_u as true_subscription_state
            , case when subscription_state = true_subscription_state then 1 else 0 end as subscription_check1
            , se.contract_id as contrtact_id
            , res_users.SUBSCRIPTION_CONTRACT_ID as true_contrtact_id
            , case when contrtact_id = true_contrtact_id then 1 else 0 end as subscription_check2
            , pp.iac_isbn as product_iac_isbn
            , res_users.vbid as true_isbn
            , b.pp_name as book
            , case when product_iac_isbn = true_isbn then 1 else 0 end as PROVISIONED_PRODUCT_check
            , (ennrollment_check + subscription_check1 + subscription_check2 + PROVISIONED_PRODUCT_check) * 25 as total_health
            , pp._hash as pp_hash
            , se._hash as se_hash
            , en._hash as en_hash
            from res_users
            , int.unlimited.RAW_OLR_ENROLLMENT as en
            , int.unlimited.RAW_SUBSCRIPTION_EVENT as se
            , int.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
            , int.unlimited.RAW_OLR_EXTENDED_IAC as b
            where
            guid = pp.user_sso_guid and guid = se.user_sso_guid and guid = en.user_sso_guid
            and product_iac_isbn = b.pp_isbn_13

      )



      SELECT * from res_fa_ta
       ;;
  }

  measure:  count_sub {
    type: count_distinct
    sql: ${se_hash};;
  }

  measure:  count_en {
    type: count_distinct
    sql: ${en_hash};;
  }

  measure:  count_pp {
    type: count_distinct
    sql: ${pp_hash};;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    sql: ${TABLE}."ID" ;;
  }

  dimension: guid {
    type: string
    sql: ${TABLE}."GUID" ;;
  }

  dimension: enrollment_course_key {
    type: string
    sql: ${TABLE}."ENROLLMENT_COURSE_KEY" ;;
  }

  dimension: true_courese_key {
    type: string
    sql: ${TABLE}."TRUE_COURESE_KEY" ;;
  }

  dimension: ennrollment_check {
    type: number
    sql: ${TABLE}."ENNROLLMENT_CHECK" ;;
  }

  dimension: subscription_state {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
  }

  dimension: true_subscription_state {
    type: string
    sql: ${TABLE}."TRUE_SUBSCRIPTION_STATE" ;;
  }

  dimension: subscription_check1 {
    type: number
    sql: ${TABLE}."SUBSCRIPTION_CHECK1" ;;
  }

  dimension: contrtact_id {
    type: string
    sql: ${TABLE}."CONTRTACT_ID" ;;
  }

  dimension: true_contrtact_id {
    type: string
    sql: ${TABLE}."TRUE_CONTRTACT_ID" ;;
  }

  dimension: subscription_check2 {
    type: number
    sql: ${TABLE}."SUBSCRIPTION_CHECK2" ;;
  }

  dimension: product_iac_isbn {
    type: string
    sql: ${TABLE}."PRODUCT_IAC_ISBN" ;;
  }

  dimension: true_isbn {
    type: string
    sql: ${TABLE}."TRUE_ISBN" ;;
  }

  dimension: book {
    type: string
    sql: ${TABLE}."BOOK" ;;
  }

  dimension: provisioned_product_check {
    type: number
    sql: ${TABLE}."PROVISIONED_PRODUCT_CHECK" ;;
  }

  dimension: total_health {
    type: number
    sql: ${TABLE}."TOTAL_HEALTH" ;;
  }

  dimension: pp_hash {
    type: string
    sql: ${TABLE}."PP_HASH" ;;
  }

  dimension: se_hash {
    type: string
    sql: ${TABLE}."SE_HASH" ;;
  }

  dimension: en_hash {
    type: string
    sql: ${TABLE}."EN_HASH" ;;
  }

  set: detail {
    fields: [
      id,
      guid,
      enrollment_course_key,
      true_courese_key,
      ennrollment_check,
      subscription_state,
      true_subscription_state,
      subscription_check1,
      contrtact_id,
      true_contrtact_id,
      subscription_check2,
      product_iac_isbn,
      true_isbn,
      book,
      provisioned_product_check,
      total_health,
      pp_hash,
      se_hash,
      en_hash
    ]
  }
}
