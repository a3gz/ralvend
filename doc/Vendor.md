# Vendor

  * Displays items for sale.
  * Takes payments.
  * Communicates with the **BackEnd** to post orders.
  * Issues refunds when necessary.

The vendor can be updated by an **Updater** object.

  * Scans for Updaters targetting it and notifies that it's ready to receive.

There are multiple other features that can be added to a vendor: 

  * Accept gift cards.
  * Purchase and deliver to someone else. *In this scenario it's the recipient who is allowed to request a redelivery*.
  * Affiliates support. Allow third-parties to use the vendors to sell products they don't own and receive a commission on every sale.
  
## Vendor requests to the BackEnd

  * Ping the **BackEnd** to make sure it's up.
  * Post an order.