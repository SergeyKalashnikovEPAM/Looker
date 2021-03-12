view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [user_id, id]

  label: "AAAA"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
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
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_orders {
    label: "A count of unique orders"
    type: count_distinct
    drill_fields: [detail*]
    sql: ${order_id}  ;;
  }

  measure: count_users {
    label: "A count of users"
    type: count_distinct
    drill_fields: [detail*]
    sql: ${user_id}  ;;
  }
  measure: total_sales {
    label: "A sum of sale price"
    type: sum
    drill_fields: [detail*]
    sql: ${sale_price}  ;;
  }

  measure: avg_sales {
    type: average
    drill_fields: [detail*]
    sql: ${sale_price}  ;;
  }

  measure: total_sales_email_users {
    type: sum
    sql: ${sale_price} ;;
    filters: [
      users.traffic_source: "Email"
    ]
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_1
    sql: 1.0*${total_sales_email_users}
      /NULLIF(${total_sales}, 0) ;;
  }

  measure: average_spend_per_user {
    type:  number
    value_format_name: usd
    sql:  1.0 * ${total_sales}/NULLIF(${count_users}, 0) ;;
  }
  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.id,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
