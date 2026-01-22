// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/os;
import ballerina/test;
import ballerinax/hubspot.crm.commerce.discounts;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string accessToken = isLiveServer ? os:getEnv("HUBSPOT_ACCESS_TOKEN") : "test_token";
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/discounts" : "http://localhost:9090/v1";

discounts:ConnectionConfig config = {
    auth: {
        token: accessToken
    }
};

final discounts:Client hubspotClient = check new discounts:Client(config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testListDiscounts() returns error? {
    discounts:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspotClient->/crm/v3/objects/discounts.get();
    test:assertTrue(response.results.length() > 0, "Expected a non-empty discounts array");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateDiscount() returns error? {
    discounts:SimplePublicObjectInputForCreate payload = {
        properties: {
            "discount_name": "Test Discount",
            "discount_percentage": "10"
        },
        associations: []
    };
    discounts:SimplePublicObject response = check hubspotClient->/crm/v3/objects/discounts.post(payload);
    test:assertTrue(response?.id !is (), "Expected discount ID to be present");
    test:assertTrue(response?.properties !is (), "Expected discount properties to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testReadDiscount() returns error? {
    discounts:SimplePublicObjectWithAssociations response = check hubspotClient->/crm/v3/objects/discounts/["12345"].get();
    test:assertTrue(response?.id !is (), "Expected discount ID to be present");
    test:assertTrue(response?.properties !is (), "Expected discount properties to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateDiscount() returns error? {
    discounts:SimplePublicObjectInput payload = {
        properties: {
            "discount_name": "Updated Test Discount",
            "discount_percentage": "15"
        }
    };
    discounts:SimplePublicObject response = check hubspotClient->/crm/v3/objects/discounts/["12345"].patch(payload);
    test:assertTrue(response?.id !is (), "Expected discount ID to be present");
    test:assertTrue(response?.properties !is (), "Expected discount properties to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testArchiveDiscount() returns error? {
    error? response = check hubspotClient->/crm/v3/objects/discounts/["12345"].delete();
    test:assertTrue(response is (), "Expected no error on successful delete");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchCreateDiscounts() returns error? {
    discounts:BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [
            {
                properties: {
                    "discount_name": "Batch Discount 1",
                    "discount_percentage": "20"
                },
                associations: []
            },
            {
                properties: {
                    "discount_name": "Batch Discount 2",
                    "discount_percentage": "15"
                },
                associations: []
            }
        ]
    };
    discounts:BatchResponseSimplePublicObject response = check hubspotClient->/crm/v3/objects/discounts/batch/create.post(payload);
    test:assertTrue(response.results.length() > 0, "Expected a non-empty batch results array");
    test:assertTrue(response?.status !is (), "Expected batch status to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchReadDiscounts() returns error? {
    discounts:BatchReadInputSimplePublicObjectId payload = {
        properties: [],
        propertiesWithHistory: [],
        inputs: [
            {id: "12345"},
            {id: "12346"}
        ]
    };
    discounts:BatchResponseSimplePublicObject response = check hubspotClient->/crm/v3/objects/discounts/batch/read.post(payload);
    test:assertTrue(response.results.length() > 0, "Expected a non-empty batch results array");
    test:assertTrue(response?.status !is (), "Expected batch status to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchUpdateDiscounts() returns error? {
    discounts:BatchInputSimplePublicObjectBatchInput payload = {
        inputs: [
            {
                id: "12345",
                properties: {
                    "discount_name": "Updated Batch Discount",
                    "discount_percentage": "30"
                }
            }
        ]
    };
    discounts:BatchResponseSimplePublicObject response = check hubspotClient->/crm/v3/objects/discounts/batch/update.post(payload);
    test:assertTrue(response.results.length() > 0, "Expected a non-empty batch results array");
    test:assertTrue(response?.status !is (), "Expected batch status to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchUpsertDiscounts() returns error? {
    discounts:BatchInputSimplePublicObjectBatchInputUpsert payload = {
        inputs: [
            {
                id: "12345",
                properties: {
                    "discount_name": "Upsert Discount",
                    "discount_percentage": "35"
                }
            }
        ]
    };
    discounts:BatchResponseSimplePublicUpsertObject response = check hubspotClient->/crm/v3/objects/discounts/batch/upsert.post(payload);
    test:assertTrue(response.results.length() > 0, "Expected a non-empty batch results array");
    test:assertTrue(response?.status !is (), "Expected batch status to be present");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testBatchArchiveDiscounts() returns error? {
    discounts:BatchInputSimplePublicObjectId payload = {
        inputs: [
            {id: "12345"},
            {id: "12346"}
        ]
    };
    error? response = check hubspotClient->/crm/v3/objects/discounts/batch/archive.post(payload);
    test:assertTrue(response is (), "Expected no error on successful batch archive");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testSearchDiscounts() returns error? {
    discounts:PublicObjectSearchRequest payload = {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "discount_percentage",
                        operator: "GTE",
                        value: "10"
                    }
                ]
            }
        ],
        sorts: ["discount_name"],
        'limit: 10,
        after: "0"
    };
    discounts:CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hubspotClient->/crm/v3/objects/discounts/search.post(payload);
    test:assertTrue(response.results.length() > 0, "Expected a non-empty search results array");
    test:assertTrue(response?.total !is (), "Expected total count to be present");
}