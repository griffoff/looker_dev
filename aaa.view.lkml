view: aaa {
  derived_table: {
    sql: with types as (
      select distinct iac.pp_pid
      , iac.pp_product_type
      , array_agg(distinct iac.cp_product_type) as cppt
      from  prod.unlimited.RAW_OLR_EXTENDED_IAC as iac
      group by iac.pp_pid, iac.pp_product_type
      )

      , c as (
      select distinct iac_isbn
      , count(distinct _hash) as cc
      from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT
      where user_sso_guid not in (select user_sso_guid from prod.unlimited.CLTS_EXCLUDED_USERS)
      group by iac_isbn
      )


      ,products as (
      select distinct pp.user_sso_guid as user_sso_guid
      , pp._hash as hash
      , pp.DATE_ADDED as local_time
      , pp.iac_isbn as isbn
      , pp.product_id as product_id
      , pp._ldts
      , pp.code_type
      , pp.context_id
      , pp.core_text_isbn
      , pp.date_added
      , pp.expiration_date
      , pp.institution_id
      , pp.local_time as local_time_time
      , pp.message_format_version
      , pp.platform_environment
      , pp.product_platform
      , pp.region
      , pp.source_id
      , pp.user_environment
      , iac.pp_name as  name
      , cc
      , case when types.pp_product_type not like 'SMART' then types.pp_product_type else
      case when ARRAY_CONTAINS('MTC'::variant, cppt) then 'MTC' else
      case when ARRAY_CONTAINS('CSFI'::variant, cppt) then 'CSFI' else
      case when ARRAY_CONTAINS('4LT'::variant, cppt) then '4LT' else
      case when ARRAY_CONTAINS('APLIA'::variant, cppt) then 'APLIA' else
      case when ARRAY_CONTAINS('SAM'::variant, cppt) then 'SAM' else
      case when ARRAY_CONTAINS('CNOWV8'::variant, cppt) then 'CNOWV8' else
      case when ARRAY_CONTAINS('NATGEO'::variant, cppt) then 'NATGEO' else
      case when ARRAY_CONTAINS('MT4'::variant, cppt) then 'MT4' else
      case when ARRAY_CONTAINS('4LTV1'::variant, cppt) then '4LTV1' else
      case when ARRAY_CONTAINS('DEV-MATH'::variant, cppt) then 'DEV-MATH' else
      case when ARRAY_CONTAINS('OWL'::variant, cppt) or ARRAY_CONTAINS('OWLV8'::variant, cppt) then 'OWL' else
      case when ARRAY_CONTAINS('MTS'::variant, cppt) then 'MTS' else
      case when ARRAY_CONTAINS('WA'::variant, cppt) then 'WA' else
      case when ARRAY_CONTAINS('WA3P'::variant, cppt) then 'WA3P' else 'other' end
      end
      end
      end
      end
      end
      end
      end
      end
      end

      end
      end
      end
      end
      end as platform
      , pp."source" as sourse
      , pp.user_type as user_type
      , case when ( pp.source_id like 'TRIAL') then 'b:TRIAL'
      else case when (is_double(TRY_TO_DOUBLE(pp.source_id))) then 'c:FULL'
      else 'a:EMPTY' end end as state
      from prod.unlimited.RAW_OLR_PROVISIONED_PRODUCT as pp
      , types
      , prod.unlimited.RAW_OLR_EXTENDED_IAC iac
      , c

      where pp.user_type like 'student'
      and types.pp_pid = pp.product_id
      and sourse like 'unlimited'
      and iac.pp_pid = pp.product_id
      and pp.user_sso_guid not in (select user_sso_guid from prod.unlimited.CLTS_EXCLUDED_USERS)
      and c.iac_isbn = pp.iac_isbn


      )

      select  distinct name, isbn, cc from products
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: pp_tier {
    type: tier
    tiers: [1, 51, 101, 151, 201, 251, 301, 351, 401, 451, 501, 551, 601, 651, 701, 751, 801, 851, 901, 951, 1001]
    style: integer   # the default value, could be excluded
    sql: ${cc} ;;
  }

 dimension: name {
  type: string
  sql: ${TABLE}."NAME" ;;
}

dimension: isbn {
  type: string
  sql: ${TABLE}."ISBN" ;;
}

dimension: cc {
  type: number
  sql: ${TABLE}."CC" ;;
}

set: detail {
  fields: [name, isbn, cc]
}
}
