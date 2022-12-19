# BackEnd

RalVend components must to be able to maintain cross-region coummunication so a customer interacting with a Vendor located in region *RA* is able to receive products from a Warehouse located in Region *RD*.

This inter-region documentation calls for a mechanism to allow two prims to communicate with one another.

RalVend must be able to function without the need of an external Web server but, we need back-end functionality to allow for inter-region communication.
To comply with this requirement we provide an BackEnd script that implements the minimum API required by the system.

Switching to an external back-end should be solely a matter of changing the base URL. The endpoints are part of the specification and any back-end must implement them.