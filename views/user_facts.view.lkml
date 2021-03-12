view: user_facts {
  derived_table: {
    sql: SELECT
       order_items.user_id AS user_id
      ,COUNT(distinct order_items.order_id) AS lifetime_order_count
      ,SUM(order_items.sale_price) AS lifetime_revenue
      ,MIN(order_items.created_at) AS first_order_date
      ,MAX(order_items.created_at) AS latest_order_date
      FROM order_items
      GROUP BY user_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}."LIFETIME_ORDER_COUNT" ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}."LIFETIME_REVENUE" ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}."FIRST_ORDER_DATE" ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}."LATEST_ORDER_DATE" ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
