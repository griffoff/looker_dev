view: check_script {
        derived_table: {
          sql: with  res_users as (
              select guid as user_sso_guid,
              uid as id,
              SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
              SUBSCRIPTION_CONTRACT_ID as SUBSCRIPTION_CONTRACT_ID,
              COURSE_KEY as COURSE_KEY
              ,VS_ISBN as vbid
              ,MTR_ISBN as MTR_ISBN
              ,APLIA_ISBN as APLIA_ISBN
              ,APLIA_MTR_ISBN as APLIA_MTR_ISBN
              ,CNOW_ISBN as CNOW_ISBN
              ,CNOW_MTR_ISBN as CNOW_MTR_ISBN
              ,WEBASSIGN_ISBN as WEBASSIGN_ISBN
              ,WEBASSIGN_MTR_ISBN as WEBASSIGN_MTR_ISBN
              ,MT_ISBN as   MT_ISBN

              ,to_array(split(concat(concat(concat(concat(concat(concat(concat( concat(concat(concat(to_varchar(VS_isbn), ', '), to_varchar(case when MTR_ISBN is null then '  ' else MTR_ISBN end)),', '),to_varchar(case when APLIA_ISBN is null then '  ' else APLIA_ISBN end)), ', '), case when CNOW_ISBN is null then '  ' else CNOW_ISBN end), ', '), case when WEBASSIGN_ISBN is null then '  ' else WEBASSIGN_ISBN end), ', '), case when MT_ISBN is null then '  ' else MT_ISBN end), ', '))  as expected_ISBN

              , CREATED_ON as date_c
              from prod.UNLIMITED.SCENARIO_DETAILS
              )
              , en as
              (
              SELECT distinct user_sso_guid,
              arrayagg(course_key)as course_key
              , arrayagg(local_time)as local_time
              FROM prod.UNLIMITED.RAW_OLR_ENROLLMENT
              group by user_sso_guid

              )
              , enrollment as
              (
                 select distinct res_users.id  as user_id
                 , res_users.user_sso_guid as user_guid
                 ,res_users.date_c as user_creation_date
                 ,array_to_string(en.course_key, ', ') as _actual_course_key
                 , res_users.COURSE_KEY as expected_courese_key
                 , case when (array_size(en.course_key) < 2 and (ARRAY_CONTAINS(expected_courese_key::variant, en.course_key) or expected_courese_key is null)) then 1 else 0 end as ennrollment_health
                 , array_to_string(en.local_time, ', ') as en_local_time
                 from res_users
                 ,en
                 where user_guid = en.user_sso_guid

                 union

                 select distinct res_users.id  as user_id
                 , res_users.user_sso_guid as user_guid
                 ,res_users.date_c as user_creation_date
                 ,null as actual_course_key
                 ,res_users.COURSE_KEY as expected_courese_key
                 , case when (user_id like '%no_cu%') then 1 else 0 end as ennrollment_health
                 , null as en_local_time
                 from res_users
                 where user_guid not in ( select user_sso_guid from prod.unlimited.RAW_OLR_ENROLLMENT)

              )

              ,se as (
              SELECT distinct user_sso_guid,
              arrayagg(subscription_state)as subscription_state
              , arrayagg(contract_id)as contract_id
              , arrayagg(local_time)as subscription_time
              FROM prod.UNLIMITED.RAW_SUBSCRIPTION_EVENT
              group by user_sso_guid
              )

              , subscription as
              (
                 select distinct res_users.id  as user_id
                 , res_users.user_sso_guid as user_guid
                 , res_users.date_c as user_creation_date
                 , se.subscription_state as actual_subscription_state
                 , res_users.SUBSCRIPTION_STATE_u as expected_subscription_state

                 , case when (user_id like '%full%' and array_size(actual_subscription_state) = 2 and ARRAY_CONTAINS(expected_subscription_state::variant, actual_subscription_state)) or (user_id like '%trial%' and array_size(actual_subscription_state) = 1 and ARRAY_CONTAINS(expected_subscription_state::variant, actual_subscription_state)) then 1 else 0 end as subscription_state_health

                 , se.contract_id as actual_contrtact_id
                 , res_users.SUBSCRIPTION_CONTRACT_ID as expected_contrtact_id

                 , case when  ARRAY_CONTAINS(expected_contrtact_id::variant, actual_contrtact_id) then 1 else 0 end  as contract_id_health
                 , se.subscription_time as subscription_time
                 from res_users
                 , se
                 where user_guid = se.user_sso_guid

                 union

                 select distinct res_users.id  as user_id
                 , res_users.user_sso_guid as user_guid
                 , res_users.date_c as user_creation_date
                 , null as actual_subscription_state
                 , case when res_users.SUBSCRIPTION_STATE_u like '%none%' then null else res_users.SUBSCRIPTION_STATE_u end as expected_subscription_state
                 , case when (user_id not like '%full%' and user_id not like '%trial%') then 1 else 0 end as subscription_state_health
                 , null as actual_contrtact_id
                 , case when res_users.SUBSCRIPTION_CONTRACT_ID like 'N/A' then null else res_users.SUBSCRIPTION_CONTRACT_ID end as expected_contrtact_id
                 , case when (user_id not like '%full%' and user_id not like '%trial%') then 1 else 0 end as contract_id_health
                 , null as subscription_time
                 from res_users
                 where user_guid not in ( select user_sso_guid from prod.unlimited.RAW_SUBSCRIPTION_EVENT)

              )
              ,pp as
              (
              SELECT distinct user_sso_guid,
              arrayagg(iac_isbn)as aa
              FROM prod.UNLIMITED.RAW_OLR_PROVISIONED_PRODUCT
              group by user_sso_guid
              )

              , products as
              (
                 select distinct res_users.id  as user_id
                 , res_users.user_sso_guid as user_guid
                 , res_users.date_c as user_creation_date
                 , pp.aa as actual_isbn
                 , res_users.vbid as VS_ISBN
                 , res_users.expected_ISBN as expected_ISBN
                 , res_users.MTR_ISBN as MTR_ISBN
                 , res_users.APLIA_ISBN as APLIA_ISBN
                 , res_users.CNOW_ISBN as CNOW_ISBN
                 , res_users.WEBASSIGN_ISBN as WEBASSIGN_ISBN
                 , res_users.MT_ISBN as   MT_ISBN
                 from res_users
                 , pp
                 where user_guid = pp.user_sso_guid


                 union

                 select distinct res_users.id  as user_id
                 , res_users.user_sso_guid as user_guid
                 , res_users.date_c as user_creation_date
                 , null as actual_isbn
                 , res_users.vbid as VS_isbn
                 , res_users.expected_ISBN as expected_ISBN
                 , res_users.MTR_ISBN as MTR_ISBN
                 , res_users.APLIA_ISBN as APLIA_ISBN
                 , res_users.CNOW_ISBN as CNOW_ISBN
                 , res_users.WEBASSIGN_ISBN as WEBASSIGN_ISBN
                 , res_users.MT_ISBN as   MT_ISBN
                 from res_users
                 where user_guid not in ( select user_sso_guid from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT)

              )

              , result as
              (
              select distinct  case when enrollment.user_id like '%full%' then 1 else (case when enrollment.user_id like '%trial%' then 2 else 3 end) end as idd
              , enrollment.*
              , array_to_string(subscription.actual_subscription_state, ', ') as actual_subscription_state
              , subscription.expected_subscription_state
              , subscription.subscription_state_health
              , array_to_string(subscription.actual_contrtact_id, ', ') as actual_contrtact_id
              , subscription.expected_contrtact_id
              , subscription.contract_id_health
              , array_to_string(subscription.subscription_time, ', ') as subscription_time
              , array_to_string(products.actual_isbn, ' ') as actual_isbn
              , array_to_string(products.expected_isbn, ' ') as expected_isbn
              , products.VS_isbn
              , products.MTR_ISBN
              , products.APLIA_ISBN
              , products.CNOW_ISBN
              , products.WEBASSIGN_ISBN
              , products.MT_ISBN
              from enrollment, subscription, products
              where enrollment.user_id = subscription.user_id
              and enrollment.user_id = products.user_id
              and subscription.user_id = products.user_id
              )


              SELECT * from result
 ;;
        }

        measure: count {
          type: count
          drill_fields: [detail*]
        }

        measure: total_success {
          type: sum
          drill_fields: [details*]
          sql: (${contract_id_health} + ${ennrollment_health} + ${subscription_state_health}) ;;
        }

        set: details {
          fields: [
            user_guid
            , expected_courese_key
            , _actual_course_key
            , ennrollment_health
            , expected_subscription_state
            , actual_subscription_state
            , subscription_state_health
            , expected_contrtact_id
            , actual_contrtact_id
            , contract_id_health
            , health
          ]
        }

        measure: total_fail {
          type: sum
          drill_fields: [details*]
          sql: 3 - (${contract_id_health} + ${ennrollment_health} + ${subscription_state_health}) ;;
        }

        measure: health {
          type: sum
          sql: 100 * ((${contract_id_health} + ${ennrollment_health} + ${subscription_state_health}) / 3);;
        }
        dimension: idd {
          type: number
          sql: ${TABLE}."IDD" ;;
        }

        dimension: user_id {
          type: string
          sql: ${TABLE}."USER_ID" ;;
        }

        dimension: user_guid {
          type: string
          sql: ${TABLE}."USER_GUID" ;;
        }

        dimension: user_creation_date {
          type: date
          drill_fields: [user_id]
          sql: ${TABLE}."USER_CREATION_DATE" ;;
        }

        dimension: _actual_course_key {
          type: string
          sql: ${TABLE}."_ACTUAL_COURSE_KEY" ;;
        }

        dimension: expected_courese_key {
          type: string
          sql: ${TABLE}."EXPECTED_COURESE_KEY" ;;
        }

        dimension: ennrollment_health {
          type: number
          sql: ${TABLE}."ENNROLLMENT_HEALTH" ;;
        }

        dimension: en_local_time {
          type: string
          sql: ${TABLE}."EN_LOCAL_TIME" ;;
        }

        dimension: actual_subscription_state {
          type: string
          sql: ${TABLE}."ACTUAL_SUBSCRIPTION_STATE" ;;
        }

        dimension: expected_subscription_state {
          type: string
          sql: ${TABLE}."EXPECTED_SUBSCRIPTION_STATE" ;;
        }

        dimension: subscription_state_health {
          type: number
          sql: ${TABLE}."SUBSCRIPTION_STATE_HEALTH" ;;
        }

        dimension: actual_contrtact_id {
          type: string
          sql: ${TABLE}."ACTUAL_CONTRTACT_ID" ;;
        }

        dimension: expected_contrtact_id {
          type: string
          sql: ${TABLE}."EXPECTED_CONTRTACT_ID" ;;
        }

        dimension: contract_id_health {
          type: number
          sql: ${TABLE}."CONTRACT_ID_HEALTH" ;;
        }

        dimension: subscription_time {
          type: string
          sql: ${TABLE}."SUBSCRIPTION_TIME" ;;
        }

        dimension: actual_isbn {
          type: string
          sql: ${TABLE}."ACTUAL_ISBN" ;;
        }

        dimension: expected_isbn {
          type: string
          sql: ${TABLE}."EXPECTED_ISBN" ;;
        }

        dimension: vs_isbn {
          type: string
          sql: ${TABLE}."VS_ISBN" ;;
        }

        dimension: mtr_isbn {
          type: string
          sql: ${TABLE}."MTR_ISBN" ;;
        }

        dimension: aplia_isbn {
          type: string
          sql: ${TABLE}."APLIA_ISBN" ;;
        }

        dimension: cnow_isbn {
          type: string
          sql: ${TABLE}."CNOW_ISBN" ;;
        }

        dimension: webassign_isbn {
          type: string
          sql: ${TABLE}."WEBASSIGN_ISBN" ;;
        }

        dimension: mt_isbn {
          type: string
          sql: ${TABLE}."MT_ISBN" ;;
        }

        set: detail {
          fields: [
            idd,
            user_id,
            user_guid,
            user_creation_date,
            _actual_course_key,
            expected_courese_key,
            ennrollment_health,
            en_local_time,
            actual_subscription_state,
            expected_subscription_state,
            subscription_state_health,
            actual_contrtact_id,
            expected_contrtact_id,
            contract_id_health,
            subscription_time,
            actual_isbn,
            expected_isbn,
            vs_isbn,
            mtr_isbn,
            aplia_isbn,
            cnow_isbn,
            webassign_isbn,
            mt_isbn
          ]
        }
      }
