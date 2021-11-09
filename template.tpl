___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Rezfusion  Hub Transaction Builder",
  "categories": ["ANALYTICS", "CONVERSIONS"],
  "brand": {
    "id": "brand_dummy",
    "displayName": "Custom Template"
  },
  "description": "Provides a tag template for configuring UA eCommerce transactions.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "affiliation",
    "displayName": "Transaction Affiliation",
    "simpleValueType": true,
    "help": "This value is most commonly the Rezfusion Hub channel name.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "event",
    "displayName": "Transaction Event Name",
    "simpleValueType": true,
    "defaultValue": "hub.ecom.track",
    "help": "Provide an event name used to trigger events. This value usually will not to be configured. But can be used in the unlikely event of a collision in the default value."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const query = require('queryPermission');
const copyFromDataLayer = require('copyFromDataLayer');
const createQueue = require('createQueue');
const conf = copyFromDataLayer('conf');
const order = copyFromDataLayer('order');
const products = [];
for(const ind in order.charges) {
  const charge = order.charges[ind];
  if(typeof charge.accepted === "undefined" || charge.accepted) {
    products.push({ 
      sku: charge.id || charge.name,
      name: charge.name || charge.id,
      category: charge.category,
      price: charge.total,
      quantity: 1,
    });
  }
}
const dataLayer = {
  event: data.event,
  transactionId: conf,
  transactionAffiliation: data.affiliation,
  transactionTotal: order.chargesGrandTotal,
  transactionTax: order.chargesTaxTotal,
  transactionProducts: products,
};
if (query('access_globals', 'readwrite', 'dataLayer')) {
  const dataLayerPush = createQueue('dataLayer');
  dataLayerPush(dataLayer);
}

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "order"
              },
              {
                "type": 1,
                "string": "conf"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Properly Sets Affiliation
  code: |-
    const copyFromDataLayer = require('copyFromDataLayer');
    const log = require('logToConsole');
    const mockData = {
      event: "hub.ecom.mockedtrack",
      affiliation: "Test affiliation",
    };

    // Call runCode to run the template's code.
    runCode(mockData);

    assertApi('createQueue').wasCalledWith('dataLayer');
    // Verify that the tag finished successfully.
    assertApi('gtmOnSuccess').wasCalled();
setup: "mock('copyFromDataLayer', function(key) {\n  switch(key) {\n    case 'conf':\n\
  \      return 'TEST-RES-ID';\n    case 'order':\n      return {\n        \"charges\"\
  : [\n          {\n            \"id\": \"Unit A\",\n            \"engine\": \"weblink\"\
  ,\n            \"source\": \"DV12\",\n            \"name\": \"Lockoff A\",\n   \
  \         \"base\": 4900,\n            \"tax\": 563.5,\n            \"total\": 5463.5,\n\
  \            \"currency\": \"USD\",\n            \"option\": 0,\n            \"\
  category\": \"Lodging\",\n            \"savings\": null,\n            \"savings_tax\"\
  : null,\n            \"savings_total\": null\n          },\n          {\n      \
  \      \"id\": null,\n            \"engine\": \"weblink\",\n            \"source\"\
  : \"DV12\",\n            \"name\": \"Cleaning Fee\",\n            \"base\": 150,\n\
  \            \"tax\": 0,\n            \"total\": 150,\n            \"currency\"\
  : \"USD\",\n            \"option\": 0,\n            \"category\": null,\n      \
  \      \"savings\": null,\n            \"savings_tax\": null,\n            \"savings_total\"\
  : null\n          },\n          {\n            \"engine\": \"weblink\",\n      \
  \      \"source\": \"DV12\",\n            \"name\": \"Travel Insurance\",\n    \
  \        \"base\": 367.48,\n            \"tax\": 0,\n            \"total\": 367.48,\n\
  \            \"option\": 8,\n            \"currency\": \"USD\",\n            \"\
  accepted\": true,\n            \"declined\": false,\n          }\n        ],\n \
  \       \"chargesGrandTotal\": 6020.98,\n        \"chargesTaxTotal\": 563.5\n  \
  \    };    \n  }\n});\n"


___NOTES___

Created on 11/8/2021, 10:04:05 PM


