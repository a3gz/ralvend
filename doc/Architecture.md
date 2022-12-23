# Architecture

A minimal RalVend setup is composed of:

  * One **Warehouse**
  * One **Vendor**
  * One **RedeliveryTerminal**
  * An external **Back End**
  * **Updater**.

## Sale flow

  * A customer interacts with a **Vendor**, chooses a product and issues a payment.
  * When the **Vendor** receives a payment, it posts the sale to the **BackEnd** for the order to be processed.
    * The **BackEnd** re-checks for available stock (Stock may change since the last time a **Vendor** was updated).
    * Create a record of the sale and returns an OK status to the **Vendor**.
    * The **Vendor** will return errors if the stock of the product is not enough to fulfill the order or if all of the **Warehouse**s containing the product are marked as permanently offline.
  * The **Vendor** reacts to the **BackEnd** response:
    * If OK, the transaction is complete.
    * If some error, the **Vendor** issues a refund.
  * The **BackEnd** sends a *delivery order* to any of the running **Warehouse**s that contain the product.
  * The **Warehouse** delivers the inventory and returns an OK status to the **BackEnd**.

Most error conditions are considered tempral and will not trigger a rollback of the sale. As long as the sale is securely recorded in the back-end, there's always going to be possible to deliver the proudcts.

*A sale will be rolled back, and money will be refunded, only in situations where there's not longer enough stock to fulfill the order or all the **Warehouse**s that deliver the intended product are marked as permanently offline*.

### Warehouse

The **Warehouse** job is to give inventory to the customers once the order has been securely recorded in the **BackEnd**.
By the time a delivery request enters the **Warehouse** the system must have enough information to be able to determine who purchased what.

The **Warehouse** has a two-ways communication channel with the **BackEnd**:
  * The **BackEnd** pings the **Warehouse** to determine whether it's running or not.
  * A **Warehouse** may change it's URL so, although it could be up and running, it would be unreachable so the **BackEnd** flags it as such until the communication is restored.
  * The **Warehouse** posts self-status updates, including it's URL to the **BackEnd**. 
