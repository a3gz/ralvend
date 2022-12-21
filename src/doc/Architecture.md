# Architecture

A minimum RalVend setup is composed of:

  * One **Warehouse**
  * One **Vendor**
  * An external **Back End**
  * **Updaters**.


## Sale flow

  * A customer interacts with a **Vendor**, chooses a product and issues a payment.
  * When the **Vendor** receives a payment, it chooses a **Warehouse** (#1) from the list it keeps and sends a *delivery order*.
  * The **Warehouse** processes the order and returns a status.
  * The **Vendor** reacts to the status returned by the **Warehouse**:
    * OK? Then the transaction is complete.
    * Error? Then issue a refund. Depending on the error, the **Vendor** set itself offline.

`#1` *Read the **Vendor** documentation to learn about how it keeps a list of available warehouses*.

### Warehouse order processing

If available stock is not enough to process the order then the trnsaction must be rolled back. The **Warehouse** must reteurn an error condition to the **Vendor**.

If stock is enough:

  * Decrement the stock to reserve a unit of the product for the transaction in course.
  **If at any point the transaction is voided, the stock is rolled back**.
  * Send a request to the **BackEnd** to record the sale.
  If the **BackEnd** does not return a success code then increment the stock and return an error status to the **Vendor**.
  * If the **BackEnd** is unreachable, the whole network is considered compromised, the **Warehouse** must set itself offline and return a critical error to the **Vendor**.
  * Give inventory to the customer.
  It's impossible to know whether the customer accepted the inventory offer or not, so at this point the order is considered fulfilled.
  The stock has already been decremented in the first step so we're good.
  * Return a success status to the **Vendor**.

### Vendor reacts to Warehouse return codes

If the **Warehouse** returns an OK status, the **Vendor** assumes that everythign is ok and the transaction is complete.
An error status from the **Warehouse** must trigger the following steps from the **Vendor**:

  * Issue a refund.
  * If the error is specific to the product, for example: there's not enough stoc to fulfill the order, then remove the product from the listing or put it in a "Sold-out" state. Payments for this product are no longer accepted.
  * If the error is specific to the vendor, then remove the **Warehouse** from the list. If there aren't any other available **Warehouses**, then the **Vendor** sets itself offline.
  * If the error involves problems with the network, then the **Vendor** sets itself offline.

A **Vendor** going offline means that it no longer processes orders. It shows offline to the customers but it continues in touch with the back-end waiting for a signal to go back online.
