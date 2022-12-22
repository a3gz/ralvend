# Warehouse

The **Warehouse** is an in-world object that contains the products for sale. 
A warehouse delivers the products to the customers and perform administrative sales-related tasks (record sale, update stock, etc).

## Warehouse requests to the BackEnd

  * Ping the **BackEnd** to make sure it's up.
  * Update it's URL on the **BackEnd**. The **BackEnd** must always know the URLs of all the **Warehouse**s. 

## Deliver products

A running Warehouse listens for HTTP requests. The request to get a Warehouse to deliver a product to a customer is the following:

<code>

    POST <url> HTTP/1.0
    Content-Type: application/json
    Authorization: Bearer <token>

    {
      "deliveryOrder": {
        "customerKey": "<customer's key>",
        "inventoryName": "<inventory name>"
      }
    }

</code>

**Responses**

**HTTP 200 OK**
The `llGiveInventory()` call was made. Since there's no way to know whether the customer accepted the inventory offer, as far as the vendor system goes, the transaction was successful. 
Same input body is returned with the response

**HTTP 409 Not Acceptable**
The request was processed but the requrested inventory is not available because it's not in the Warehouse inventory or the stock is not enough to fulfill the order.
Same input body is returned with the response

**HTTP 401 Unauthroized**
The authorization was missing or invalid.
