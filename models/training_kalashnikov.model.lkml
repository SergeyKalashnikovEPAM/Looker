connection: "snowlooker"
#здесь был Ринат
# include all the views
include: "/views/**/*.view"


datagroup: training_kalashnikov_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: training_kalashnikov_default_datagroup

datagroup: ex7.1_datagroup {
  max_cache_age: "24 hour"
  sql_trigger: select current_date ;;
}

datagroup: ex7.2_datagroup {
  max_cache_age: "4 hour"
  sql_trigger: select max(created_at) from order_items ;;
}

explore: users {
  label: "Users"
  persist_with: ex7.1_datagroup
  join: order_items {
    type: inner
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  always_filter: {
    filters: [order_items.status: "Complete"]
  }
  conditionally_filter: {
    filters: [order_items.created_date: "2 years"]
    unless: [id]
  }
}

explore: order_items {
  label: "Orders Label"
  view_label: "Orders View Label"
  persist_with: ex7.1_datagroup
  join: users {
     view_label: "Customers"
     type: left_outer
     sql_on: ${order_items.user_id} = ${users.id} ;;
     relationship: many_to_one
   }
  sql_always_where: ${status} != 'Returned' ;;
  sql_always_having: ${total_sales} > 200 ;;
  always_filter: {
    filters: [order_items.created_date: "2 months"]
  }
  conditionally_filter: {
    filters: [users.created_date: "90 days"]
    unless: [id]
  }
}

#   join: inventory_items {
#     type: left_outer
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#     relationship: many_to_one
#   }

#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: distribution_centers {}

# explore: etl_jobs {}

# explore: events {
#   join: users {
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: products {
#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: users {}
