view: prov_prod {
  derived_table: {
    sql: with  res_users as (
        select guid as user_sso_guid,
        uid as id,
        SUBSCRIPTION_STATE as SUBSCRIPTION_STATE_u,
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
        from UNLIMITED.SCENARIO_DETAILS
        where id not like '%no_cu%'
        )

         , en as
         (
         SELECT distinct user_sso_guid,
         arrayagg(course_key)as course_key
         FROM UNLIMITED.RAW_OLR_ENROLLMENT
         group by user_sso_guid
         )

         , enrollment as
         (
         select distinct res_users.id  as user_id
         , case when res_users.SUBSCRIPTION_STATE_u like '%none%' then null else res_users.SUBSCRIPTION_STATE_u end as SUBSCRIPTION_STATE
         , res_users.user_sso_guid as user_guid
         ,res_users.date_c as user_creation_date
         ,array_to_string(en.course_key, ', ') as _actual_course_key
         , res_users.COURSE_KEY as expected_courese_key
         , case when (array_size(en.course_key) < 2 and (ARRAY_CONTAINS(expected_courese_key::variant, en.course_key) or expected_courese_key is null)) then 1 else 0 end as ennrollment_health
         from res_users
         ,en
         where user_guid = en.user_sso_guid

         union

         select distinct res_users.id  as user_id
         , case when res_users.SUBSCRIPTION_STATE_u like '%none%' then null else res_users.SUBSCRIPTION_STATE_u end as SUBSCRIPTION_STATE
         , res_users.user_sso_guid as user_guid
         ,res_users.date_c as user_creation_date
         ,null as actual_course_key
         ,res_users.COURSE_KEY as expected_courese_key
         , case when (user_id like '%no_cu%') then 1 else 0 end as ennrollment_health
         from res_users
         where user_guid not in ( select user_sso_guid from unlimited.RAW_OLR_ENROLLMENT)

        )
        , plat as
        (
        SELECT platform, isbn13
        FROM prod.STG_CLTS.PRODUCTS_V
        )

        ,iac as (
        SELECT distinct PP_ISBN_13  as pp_isbn_13
        , array_agg(distinct CP_ISBN_13) as cp_isbn_13
        FROM UNLIMITED.RAW_OLR_EXTENDED_IAC
        group by PP_ISBN_13
        )

        , products as
        (
        select distinct res_users.id  as user_id
        , res_users.user_sso_guid as user_guid
        , res_users.date_c as user_creation_date
        , case
          when platform like 'MindTap Reader' then null else
            case when platform like 'MindTap'  then res_users.MT_ISBN else
              case when platform like 'Standalone Academic eBook' then null else
                case when platform like 'Aplia' then res_users.APLIA_ISBN else
                  case when (platform like 'CNOW' or platform like 'OWL V2') then res_users.CNOW_ISBN else
                    case when platform like 'WebAssign' then res_users.WEBASSIGN_ISBN else 'Error in platform'
                    end
                  end
                end
              end
            end
          end as course_isbn_expected

          , case
          when platform like 'MindTap Reader' then res_users.MTR_ISBN else
            case when platform like 'MindTap'  then null else
              case when platform like 'Standalone Academic eBook' then res_users.vbid else
                case when platform like 'Aplia' then res_users.APLIA_mtr_ISBN else
                  case when (platform like 'CNOW' or platform like 'OWL V2') then res_users.CNOW_mtr_ISBN else
                    case when platform like 'WebAssign' then res_users.WEBASSIGN_mtr_ISBN else 'Error in platform'
                    end
                  end
                end
              end
            end
          end as ebook_isbn_expected
        , case when (platform not like 'MindTap Reader' and platform not like 'Standalone Academic eBook') then b.pp_isbn_13  else null end as actual_course

        , case when (platform not like 'MindTap Reader' and platform not like 'Standalone Academic eBook') then array_to_string(b.cp_isbn_13, ' ') else b.pp_isbn_13 end as  actual_book

        , case when (course_isbn_expected like actual_course or platform like 'MindTap Reader' or platform like 'Standalone Academic eBook') then 1 else 0 end as course_health

        , case when (position(EBOOK_ISBN_EXPECTED , ACTUAL_BOOK) > 0 or EBOOK_ISBN_EXPECTED is null) then 1 else 0 end as book_health

        , plat.platform as platform
        from res_users
        , unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
        , plat
        , iac as b
        where user_guid = pp.user_sso_guid
        and pp.iac_isbn = plat.isbn13
        and pp.iac_isbn = b.pp_isbn_13



        union

        select distinct res_users.id  as user_id
        , res_users.user_sso_guid as user_guid
        , res_users.date_c as user_creation_date
        , null as course_isbn_expected

        , null as ebook_isbn_expected
        , null  as actual_course

        , null as actual_book

        , 0 as course_health

        , 0 book_health

        , null
        from res_users
        where user_guid not in  ( select user_sso_guid from unlimited.RAW_OLR_PROVISIONED_PRODUCT)

        )

        , result as (
        select distinct case when enrollment.user_id like '%full%' then 1 else (case when enrollment.user_id like '%trial%' then 2 else 3 end) end as idd
        ,products.*
        , enrollment._actual_course_key
        , enrollment.expected_courese_key
        , enrollment.ennrollment_health
        , enrollment.subscription_state
        from products, enrollment
        where enrollment.user_id = products.user_id
        )


        select * from result
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: health {
    type: sum
    sql: 50 * (${book_health} + ${course_health}) ;;
  }
  measure: success {
    type: sum
    drill_fields: [detail*]
    sql: (${book_health} + ${course_health}) ;;
  }
  measure: fail {
    type: sum
    drill_fields: [detail*]
    sql: 2 - (${book_health} + ${course_health}) ;;
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
    sql: ${TABLE}."USER_CREATION_DATE" ;;
  }

  dimension: course_isbn_expected {
    type: string
    sql: ${TABLE}."COURSE_ISBN_EXPECTED" ;;
  }

  dimension: ebook_isbn_expected {
    type: string
    sql: ${TABLE}."EBOOK_ISBN_EXPECTED" ;;
  }

  dimension: actual_course {
    type: string
    sql: ${TABLE}."ACTUAL_COURSE" ;;
  }

  dimension: actual_book {
    type: string
    sql: ${TABLE}."ACTUAL_BOOK" ;;
  }

  dimension: course_health {
    type: number
    sql: ${TABLE}."COURSE_HEALTH" ;;
  }

  dimension: book_health {
    type: number
    sql: ${TABLE}."BOOK_HEALTH" ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}."PLATFORM" ;;
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

  dimension: subscription_state {
    type: string
    sql: ${TABLE}."SUBSCRIPTION_STATE" ;;
  }

  set: detail {
    fields: [
      idd,
      user_id,
      user_guid,
      user_creation_date,
      course_isbn_expected,
      ebook_isbn_expected,
      actual_course,
      actual_book,
      course_health,
      book_health,
      platform,
      _actual_course_key,
      expected_courese_key,
      ennrollment_health,
      subscription_state
    ]
  }
}
