view: ra_sub_v2 {
  derived_table: {
    sql: with success as (
      SELECT DATAVAULT.HUB_USER.UID as uid
      , DATAVAULT.SAT_SUBSCRIPTION.RSRC_TIMESTAMP as t_subscriptionn_time
      , DATAVAULT.SAT_SUBSCRIPTION.SUBSCRIPTION_STATE  as t_subscription_state
      , DATAVAULT.SAT_SUBSCRIPTION.START_TIMESTAMP as t_subscription_start
      , DATAVAULT.SAT_SUBSCRIPTION.END_TIMESTAMP as t_subscription_end
      , DATAVAULT.HUB_CONTRACT.CONTRACT_ID as t_sub_contract_id
      , UNLIMITED.SCENARIO_DETAILS.UID as email
      , 1 as success

      FROM DATAVAULT.SAT_SUBSCRIPTION
      INNER JOIN DATAVAULT.LINK_USER_CONTRACT ON LINK_USER_CONTRACT.LINK_USER_CONTRACT_KEY = SAT_SUBSCRIPTION.LINK_USER_CONTRACT_KEY
      INNER JOIN DATAVAULT.HUB_USER on HUB_USER.HUB_USER_KEY = DATAVAULT.LINK_USER_CONTRACT.HUB_USER_KEY
      INNER JOIN DATAVAULT.HUB_CONTRACT on HUB_CONTRACT.HUB_CONTRACT_KEY = DATAVAULT.LINK_USER_CONTRACT.HUB_CONTRACT_KEY

      INNER JOIN UNLIMITED.SCENARIO_DETAILS on UNLIMITED.SCENARIO_DETAILS.GUID = DATAVAULT.HUB_USER.UID
      INNER JOIN UNLIMITED.SCENARIO_SUBSCRIPTIONS on UNLIMITED.SCENARIO_SUBSCRIPTIONS.UID = UNLIMITED.SCENARIO_DETAILS.UID and UNLIMITED.SCENARIO_SUBSCRIPTIONS.CONTRACT_ID = DATAVAULT.HUB_CONTRACT.CONTRACT_ID and DATAVAULT.SAT_SUBSCRIPTION.SUBSCRIPTION_STATE = UNLIMITED.SCENARIO_SUBSCRIPTIONS.STATE
      )
      , fail as (
      select UNLIMITED.SCENARIO_DETAILS.guid as uid
      , UNLIMITED.SCENARIO_SUBSCRIPTIONS.CREATED_ON as t_subscriptionn_time
      , UNLIMITED.SCENARIO_SUBSCRIPTIONS.STATE as t_subscription_state
      , UNLIMITED.SCENARIO_SUBSCRIPTIONS.START_DATE as t_subscription_start
      , UNLIMITED.SCENARIO_SUBSCRIPTIONS.END_DATE as t_subscription_end
      , UNLIMITED.SCENARIO_SUBSCRIPTIONS.CONTRACT_ID as t_sub_contract_id
      , UNLIMITED.SCENARIO_SUBSCRIPTIONS.uid as email
      , 0 as success
      from UNLIMITED.SCENARIO_SUBSCRIPTIONS
      INNER JOIN UNLIMITED.SCENARIO_DETAILS on UNLIMITED.SCENARIO_DETAILS.uid = UNLIMITED.SCENARIO_SUBSCRIPTIONS.uid
      left outer join success on success.email = UNLIMITED.SCENARIO_SUBSCRIPTIONS.uid
      where success.email is null
      and UNLIMITED.SCENARIO_SUBSCRIPTIONS.uid not like '%no_cu%'
      )

      select * from fail
      union
      select * from success
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: total_success {
    type: sum
    drill_fields: [detail*]
    sql: ${success};;
  }

  measure: total_fail {
    type: sum
    drill_fields: [detail*]
    sql: 1 - ${success};;
  }

  dimension: uid {
    type: string
    sql: ${TABLE}."UID" ;;
  }

  dimension_group: t_subscriptionn_time {
    type: time
    sql: ${TABLE}."T_SUBSCRIPTIONN_TIME" ;;
  }

  dimension: t_subscription_state {
    type: string
    sql: ${TABLE}."T_SUBSCRIPTION_STATE" ;;
  }

  dimension_group: t_subscription_start {
    type: time
    sql: ${TABLE}."T_SUBSCRIPTION_START" ;;
  }

  dimension_group: t_subscription_end {
    type: time
    sql: ${TABLE}."T_SUBSCRIPTION_END" ;;
  }

  dimension: t_sub_contract_id {
    type: string
    sql: ${TABLE}."T_SUB_CONTRACT_ID" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: success {
    type: number
    sql: ${TABLE}."SUCCESS" ;;
  }

  set: detail {
    fields: [
      uid,
      t_subscriptionn_time_time,
      t_subscription_state,
      t_subscription_start_time,
      t_subscription_end_time,
      t_sub_contract_id,
      email,
      success
    ]
  }
}
