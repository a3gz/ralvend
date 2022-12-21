# Back-End

The back-end functions as an orchestrator and data repository.

## Orchestrator

The **BackEnd** is the only entity that knows everything about the network:

  * How many **Vendor**s are there?
  * How many **Warehouse**s are there?
  * Which **Warehouse**s are running?

The **Vendors** communicate wit the **BackEnd** to update its local list of available **Warehouse**s and receive general network health status. This is the only point of contact a **Vendor** has with the **BackEnd**.

The **Warehouse** has a two-ways communication channel with the **BackEnd**.
The **BackEnd** pings the **Warehouse** to determine whether it's running or not. A **Warehouse** may change it's URL so, although it could be up and running, it would be unreachable so the **BackEnd** flags it as such until the communication is restored.
The **Warehouse** pings the **BackEnd** to make sure it's still up and to update it's URL. 

## Data repository

  * Sales history.
  * Customers history.
  * Which products a customer has purchased (essential for redeliveries).
  * Anything that may be needed.
