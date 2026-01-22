
# Ballerina hubspot.crm.commerce.discounts connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.commerce.discounts.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.commerce.discounts)

## Overview

[HubSpot](https://www.hubspot.com/) is a comprehensive customer platform that provides marketing, sales, customer service, and CRM software to help businesses grow better by attracting, engaging, and delighting customers.

The `ballerinax/hubspot.crm.commerce.discounts` package offers APIs to connect and interact with [HubSpot API](https://developers.hubspot.com/docs/api/overview) endpoints, specifically based on [HubSpot API v3](https://developers.hubspot.com/docs/api/crm/objects).
## Setup guide

To use the HubSpot CRM Commerce Discounts connector, you must have access to the HubSpot API through a [HubSpot developer account](`https://developers.hubspot.com/`) and obtain an API access token. If you do not have a HubSpot account, you can sign up for one [here](`https://www.hubspot.com/`).

### Step 1: Create a HubSpot Account

1. Navigate to the [HubSpot website](`https://www.hubspot.com/`) and sign up for an account or log in if you already have one.

2. Ensure you have a Professional or Enterprise plan, as the Commerce Hub features including discount management are restricted to users on these plans.

### Step 2: Generate an API Access Token

1. Log in to your HubSpot account.

2. In the main navigation, click the settings icon (gear icon) in the top right corner to access your account settings.

3. In the left sidebar menu, navigate to Integrations > Private Apps.

4. Click Create a private app and configure the necessary scopes for CRM commerce operations.

5. Once created, copy the access token from the Auth tab of your private app.

> **Tip:** You must copy and store this key somewhere safe. It won't be visible again in your account settings for security reasons.
## Quickstart

To use the `HubSpot CRM Commerce Discounts` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.commerce.discounts as hscrmcd;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file with your credentials:

```toml
clientId = "<Your_Client_Id>"
clientSecret = "<Your_Client_Secret>"
refreshToken = "<Your_Refresh_Token>"
```

2. Create a `hscrmcd:ConnectionConfig` and initialize the client:

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

final hscrmcd:Client hubspotDiscountsClient = check new({
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
    hscrmcd:SimplePublicObjectInputForCreate newDiscount = {
        properties: {
            "discount_name": "Summer Sale 2024",
            "discount_type": "percentage",
            "discount_value": "25",
            "description": "25% off summer collection"
        },
        associations: []
    };

    hscrmcd:SimplePublicObject response = check hubspotDiscountsClient->/.post(newDiscount);
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```
## Examples

The `hubspot.crm.commerce.discounts` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples), covering the following use cases:

1. [Discount manager](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples/discount_manager) - Demonstrates how to manage discount operations using Ballerina connector for HubSpot CRM Commerce Discounts.
2. [Festival discounts](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples/festival_discounts) - Illustrates creating and managing festival-specific discount campaigns.
3. [Seasonal discount management](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.commerce.discounts/tree/main/examples/seasonal-discount-management) - Shows how to implement seasonal discount strategies and automation.
## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

    > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

    > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

    ```bash
    ./gradlew clean build
    ```

2. To run the tests:

    ```bash
    ./gradlew clean test
    ```

3. To build the without the tests:

    ```bash
    ./gradlew clean build -x test
    ```

4. To run tests against different environments:

    ```bash
    ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
    ```

5. To debug the package with a remote debugger:

    ```bash
    ./gradlew clean build -Pdebug=<port>
    ```

6. To debug with the Ballerina language:

    ```bash
    ./gradlew clean build -PbalJavaDebug=<port>
    ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToCentral=true
    ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).


## Useful links

* For more information go to the [`hubspot.crm.commerce.discounts` package](https://central.ballerina.io/ballerinax/hubspot.crm.commerce.discounts/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
