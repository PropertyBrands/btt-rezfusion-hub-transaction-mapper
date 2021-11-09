# Rezfusion Hub Transaction Mapper

Provides a tag template for mapping the Rezfusion Hub order `dataLayer` entries to
a Google Analytics transaction.

## Setup

To complete a full ecommerce tracking setup there are 2 triggers and a variable to create before we can create the builder tag and the transaction track tag.

### Triggers

1. Create a trigger for the event `hub.ecom.conf`. This is the event used to trigger the transaction builder tag.
2. Create a trigger for tracking the built transaction. This event can be any value, it defaults to `hub.ecom.track`. This is the event used to trigger pushing the transaction to Google Analytics.

### Variables

The Google Analytics Transaction Track tag requires a Google Analytics Settings variable type to supply the UA number for the web property.

### Tracking the Transaction

See the documentation for tracking standard ecommerce transactions here: https://support.google.com/tagmanager/answer/6107169?hl=en#standard-ecommerce. For Rezfusion Hub transactions the transaction mapper tag will take care of building the necessary transaction data such as prices, taxes, and the list of products. The implementors responsibility is to:

1. Properly configure Google Analytics settings.
2. Create a Universal Analytics tag with track type "transaction" as described in the documentation above.
3. Ensure that the trigger created above is applied to the transaction tracking tag.