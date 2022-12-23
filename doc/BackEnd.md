# Back-End

The back-end functions as an orchestrator and data repository.

## Orchestrator

The **BackEnd** is the only entity that knows everything about the network:

  * How many **Vendor**s are there?
  * How many **Warehouse**s are there?
  * Which **Warehouse**s are running?
  * What products does each **Warehouse** have in inventory?
  * How many units (stock) of each product are there still in existence. Stock is managed globally by the back-end.

## Data repository

  * Sales history.
  * Customers history.
  * Which products a customer has purchased (essential for redeliveries).
  * Anything that may be needed.
  * Product inventory. Manage products with a limited number of units for sale.

## Endpoints

`GET .../public/tools/keygen`
Generate unique keys you can use for multiple purposes. Refresh the page as many times as you need to get new values every time.
