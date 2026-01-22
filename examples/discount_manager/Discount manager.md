# Discount Manager

This example demonstrates how to perform complete discount lifecycle management in HubSpot, including creating, updating, reading, and deleting discount records using the HubSpot CRM Commerce Discounts API.

## Prerequisites

1. **HubSpot Setup**
   > Refer to the [HubSpot setup guide](https://central.ballerina.io/ballerinax/hubspot.crm.commerce.discounts/latest#setup-guide) to obtain the OAuth2 credentials.

2. **Configuration**
   Create a `Config.toml` file with your HubSpot OAuth2 credentials:

```toml
clientId = "<Your Client ID>"
clientSecret = "<Your Client Secret>"
refreshToken = "<Your Refresh Token>"
```

## Run the example

Execute the following command to run the example. The script will demonstrate the complete discount management workflow by creating a new discount, updating its properties, reading the discount details, and finally deleting it.

```shell
bal run
```

The script will output the progress of each operation:
- Discount creation with generated ID
- Discount update confirmation 
- Discount details retrieval
- Discount deletion confirmation