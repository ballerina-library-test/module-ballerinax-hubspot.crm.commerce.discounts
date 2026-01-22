## Overview

[HubSpot](https://www.hubspot.com/) is a comprehensive customer relationship management (CRM) platform that provides marketing, sales, customer service, and content management tools to help businesses grow and manage their customer relationships effectively.

The `ballerinax/hubspot.crm.commerce.discounts` package offers APIs to connect and interact with [HubSpot API](https://developers.hubspot.com/docs/api/overview) endpoints, specifically based on [HubSpot API v3](https://developers.hubspot.com/docs/api/crm/understanding-the-crm).
## Setup guide

To use the HubSpot CRM Commerce Discounts connector, you must have access to the HubSpot API through a [HubSpot developer account](`https://developers.hubspot.com/`) and obtain an API access token. If you do not have a HubSpot account, you can sign up for one [here](`https://www.hubspot.com/`).

### Step 1: Create a HubSpot Account

1. Navigate to the [HubSpot website](`https://www.hubspot.com/`) and sign up for an account or log in if you already have one.

2. Ensure you have a Professional or Enterprise plan, as the Commerce features including discount management are available on these higher-tier plans.

### Step 2: Generate an API Access Token

1. Log in to your HubSpot account.

2. Click on the settings gear icon in the top right corner of your HubSpot dashboard.

3. In the left sidebar, navigate to Integrations and select Private Apps.

4. Click Create a private app and configure the necessary scopes for CRM and Commerce access.

5. Once created, copy the access token from the Auth tab of your private app.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again in your account settings for security reasons.
## Quickstart

To use the `HubSpot CRM Commerce Discounts` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.commerce.discounts as hscrmDiscounts;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file with your credentials:

```toml
clientId = "<Your_Client_Id>"
clientSecret = "<Your_Client_Secret>"
refreshToken = "<Your_Refresh_Token>"
```

2. Create a `hscrmDiscounts:ConnectionConfig` and initialize the client:

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final hscrmDiscounts:Client hscrmDiscountsClient = check new({
    auth: {
        clientId,
        clientSecret,
        refreshToken
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### Create a new discount

```ballerina
public function main() returns error? {
    hscrmDiscounts:SimplePublicObjectInputForCreate newDiscount = {
        properties: {
            "name": "Summer Sale Discount",
            "discount_type": "percentage",
            "discount_value": "20"
        },
        associations: []
    };

    hscrmDiscounts:SimplePublicObject response = check hscrmDiscountsClient->/.post(newDiscount);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `hubspot.crm.commerce.discounts` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples), covering the following use cases:

1. [Discount manager](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples/discount_manager) - Demonstrates how to manage discount operations using Ballerina connector for HubSpot CRM commerce discounts.
2. [Festival discounts](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples/festival_discounts) - Illustrates creating and managing festival-specific discount campaigns.
3. [Seasonal discount management](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples/seasonal-discount-management) - Shows how to implement seasonal discount strategies and management workflows.