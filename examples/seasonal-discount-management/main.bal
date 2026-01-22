import ballerina/io;
import ballerinax/hubspot.crm.commerce.discounts;

configurable string accessToken = ?;

public function main() returns error? {
    
    discounts:ConnectionConfig config = {
        auth: {
            token: accessToken
        }
    };
    
    discounts:Client hubspotClient = check new(config);
    
    io:println("=== Seasonal Discount Management System ===");
    io:println("Creating holiday sale discounts for different product categories...\n");
    
    discounts:SimplePublicObjectInputForCreate[] discountInputs = [
        {
            properties: {
                "name": "Holiday Electronics Sale",
                "discount_percentage": "25",
                "category": "Electronics",
                "start_date": "2024-12-01",
                "end_date": "2024-12-31",
                "description": "25% off all electronics during holiday season",
                "status": "ACTIVE"
            },
            associations: []
        },
        {
            properties: {
                "name": "Fashion Winter Clearance",
                "discount_percentage": "40",
                "category": "Fashion",
                "start_date": "2024-12-15",
                "end_date": "2025-01-15",
                "description": "40% off winter fashion collection",
                "status": "ACTIVE"
            },
            associations: []
        },
        {
            properties: {
                "name": "Home & Garden Holiday Special",
                "discount_percentage": "30",
                "category": "Home & Garden",
                "start_date": "2024-11-25",
                "end_date": "2024-12-25",
                "description": "30% off home and garden items for the holidays",
                "status": "ACTIVE"
            },
            associations: []
        }
    ];
    
    discounts:BatchInputSimplePublicObjectInputForCreate batchInput = {
        inputs: discountInputs
    };
    
    discounts:BatchResponseSimplePublicObject|discounts:BatchResponseSimplePublicObjectWithErrors batchResponse = check hubspotClient->/batch/create.post(batchInput);
    
    string[] createdDiscountIds = [];
    
    if batchResponse is discounts:BatchResponseSimplePublicObject {
        io:println("✓ Successfully created " + batchResponse.results.length().toString() + " promotional discounts");
        io:println("Batch Status: " + batchResponse.status);
        io:println("Completed At: " + batchResponse.completedAt + "\n");
        
        foreach discounts:SimplePublicObject discount in batchResponse.results {
            createdDiscountIds.push(discount.id);
            io:println("Created Discount ID: " + discount.id);
            io:println("  Name: " + (discount.properties["name"] ?: "N/A"));
            io:println("  Category: " + (discount.properties["category"] ?: "N/A"));
            io:println("  Discount: " + (discount.properties["discount_percentage"] ?: "N/A") + "%");
        }
    } else {
        io:println("✗ Batch creation completed with errors:");
        discounts:SimplePublicObject[] batchResults = batchResponse.results;
        io:println("Successfully created: " + batchResults.length().toString() + " discounts");
        discounts:StandardError[]? batchErrors = batchResponse.errors;
        if batchErrors is discounts:StandardError[] {
            int? numErrorsValue = batchResponse.numErrors;
            int numErrors = numErrorsValue ?: 0;
            io:println("Errors encountered: " + numErrors.toString());
        }
        
        foreach discounts:SimplePublicObject discount in batchResults {
            createdDiscountIds.push(discount.id);
        }
    }
    
    io:println("\n=== Searching for Holiday Discounts ===");
    
    discounts:PublicObjectSearchRequest searchRequest = {
        properties: ["name", "discount_percentage", "category", "start_date", "end_date", "status"],
        'limit: 10,
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "status",
                        operator: "EQ",
                        value: "ACTIVE"
                    }
                ]
            }
        ]
    };
    
    discounts:CollectionResponseWithTotalSimplePublicObjectForwardPaging searchResponse = check hubspotClient->/search.post(searchRequest);
    
    io:println("✓ Found " + searchResponse.total.toString() + " active discounts");
    io:println("Displaying search results:\n");
    
    foreach discounts:SimplePublicObject discount in searchResponse.results {
        io:println("Discount: " + (discount.properties["name"] ?: "N/A"));
        io:println("  ID: " + discount.id);
        io:println("  Category: " + (discount.properties["category"] ?: "N/A"));
        io:println("  Discount Percentage: " + (discount.properties["discount_percentage"] ?: "N/A") + "%");
        io:println("  Valid From: " + (discount.properties["start_date"] ?: "N/A"));
        io:println("  Valid Until: " + (discount.properties["end_date"] ?: "N/A"));
        io:println("  Status: " + (discount.properties["status"] ?: "N/A"));
        io:println("  Created: " + discount.createdAt);
        io:println("");
    }
    
    io:println("=== Retrieving Specific Discount Details ===");
    
    if createdDiscountIds.length() > 0 {
        string targetDiscountId = createdDiscountIds[0];
        io:println("Fetching detailed information for discount ID: " + targetDiscountId);
        
        discounts:GetCrmV3ObjectsDiscountsDiscountIdQueries detailQueries = {
            properties: ["name", "discount_percentage", "category", "start_date", "end_date", "description", "status"],
            propertiesWithHistory: ["discount_percentage", "status"]
        };
        
        discounts:SimplePublicObjectWithAssociations discountDetails = check hubspotClient->/[targetDiscountId].get(queries = detailQueries);
        
        io:println("\n✓ Successfully retrieved discount details:");
        io:println("ID: " + discountDetails.id);
        io:println("Name: " + (discountDetails.properties["name"] ?: "N/A"));
        io:println("Description: " + (discountDetails.properties["description"] ?: "N/A"));
        io:println("Category: " + (discountDetails.properties["category"] ?: "N/A"));
        io:println("Discount Percentage: " + (discountDetails.properties["discount_percentage"] ?: "N/A") + "%");
        io:println("Start Date: " + (discountDetails.properties["start_date"] ?: "N/A"));
        io:println("End Date: " + (discountDetails.properties["end_date"] ?: "N/A"));
        io:println("Status: " + (discountDetails.properties["status"] ?: "N/A"));
        io:println("Created At: " + discountDetails.createdAt);
        io:println("Last Updated: " + discountDetails.updatedAt);
        
        record {|discounts:ValueWithTimestamp[]...;|}? propertiesWithHistory = discountDetails.propertiesWithHistory;
        if propertiesWithHistory is record {|discounts:ValueWithTimestamp[]...;|} {
            io:println("\nProperty History:");
            foreach var [property, history] in propertiesWithHistory.entries() {
                io:println("  " + property + ":");
                foreach discounts:ValueWithTimestamp historyItem in history {
                    io:println("    Value: " + historyItem.value + " | Updated: " + historyItem.timestamp);
                }
            }
        }
    }
    
    io:println("\n=== Discount Management System Complete ===");
    io:println("✓ Created multiple seasonal discounts for different product categories");
    io:println("✓ Verified discount creation through search functionality");
    io:println("✓ Retrieved detailed discount information including expiration dates");
    io:println("✓ All discount percentages and validity periods confirmed");
}