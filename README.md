![alt text](https://static.wepay.com/img/logos/wepay.png "WePay")

WePay's IOS SDK makes it easy for you to add payments to your mobile application. You don't have to worry about PCI compliance because your servers never touch actual credit card data. User card details are sent to WePay, which sends back a token that your app can send off to your own servers for charge. 

### Requirements
- ARC

### Installation
You can install the IOS SDK by adding the **WePay** directory to your project. 

### Structure

Descriptor classes, located in the **WePay/Descriptors** folder, facilitate the passing of parameters to API call classes. API calls through the IOS SDK generally take three arguments: a descriptor object argument, a success callback (a function executed if the API call is successful) argument, and an error callback (a function executed when an error occurs) argument. Currently, this SDK only supports one API call, the [/credit_card/create](https://www.wepay.com/developer/reference/credit_card#create "Credit Card Create API call") API call, that allows you to pass a customer's credit card details to WePay and receive back a credit_card_id (card token) that you can then charge on your own servers.

To send a customer's credit card details to WePay and receive a token, you will first need to create and populate descriptor objects with the name, email, address, and credit card details of the customer.

For example, 

1) You will need to create and populate the **WPAddressDescriptor** object (“address descriptor”) with either the customer's zipcode (for US customers, WePay only requires you to send the zipcode) or full address. 

2) You will need to create and populate the **WPUserDesciptor** object (“user descriptor)  with the customer's name, email, and address descriptor. 

3) You will then need to create and populate the **WPCreditCardDescriptor** object (“card descriptor”) with the customer's credit card details and user descriptor. 

Finally, you will need to pass in this card descriptor object to the static method, **createCardWithDescriptor**, in the WPCreditCard class that actually sends the card information to WePay and receives back a token. 

We show you how to accomplish all of these steps in the sample code below.


### Configuration

For all requests, you must initialize the SDK with your Client ID, into either Staging or Production mode. All API calls made against WePay's staging environment mirror production in functionality, but do not actually move money. This allows you to develop your application and test the checkout experience from the perspective of your customers without spending any money on payments. 

**Note:** Staging and Production are two completely independent environments and share NO data with each other. This means that in order to use staging, you must register at stage.wepay.com and get a set of API keys for your Staging application, and must do the same on Production when you are ready to go live. API keys and access tokens granted on stage can not be used on Production, and vice-versa.

Use of our IOS SDK will require you to apply for tokenization approval. Please apply for approval on your application's dashboard.

After you have created an API application on either stage.wepay.com or wepay.com, add the following to the **- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions** in your APPDelegate file:

If you want to use our production (wepay.com) environment:

	[WePay setProductionClientId: @"YOUR_CLIENT_ID"];

If you want to use our testing (stage.wepay) environment:

	[WePay setStageClientId: @"YOUR_CLIENT_ID"]; 


### Usage

	#import "WPCreditCard.h"


#### Tokenize Card

	// Pass in the customer's address to the address descriptor
	// For US customers, WePay only requires you to send a zipcode
	WPAddressDescriptor * addressDescriptor = [[WPAddressDescriptor alloc] initWithZip: @"94085"];

	/* 
	You can also do:
	WPAddressDescriptor * addressDescriptor = [[WPAddressDescriptor alloc] init];
	addressDescriptor.address1 = @"Main Street";
	addressDescriptor.city = @"Sunnyvale";
	addressDescriptor.state = @"CA";
	addressDescriptor.country = @"US";
	addressDescriptor.zip = @"94085";

	*/

	// Pass in the customer's name, email, and address descriptor to the user descriptor
	WPUserDescriptor * userDescriptor = [[WPUserDescriptor alloc] init];
	userDescriptor.name = @"Bill Clerico";
	userDescriptor.email = @"test@wepay.com";
	userDescriptor.address = addressDescriptor;

	// Pass in the customer's credit card details to the card descriptor
	WPCreditCardDescriptor * cardDescriptor = [[WPCreditCardDescriptor alloc] init];
	cardDescriptor.number = @"4242424242424242";
	cardDescriptor.expirationMonth = 2;
	cardDescriptor.expirationYear = 2020;
	cardDescriptor.securityCode = @"313";
	cardDescriptor.user = userDescriptor;

	// Send the customer's card details to WePay and retrieve a token
	[WPCreditCard createCardWithDescriptor: cardDescriptor success: ^(WPCreditCard * tokenizedCard) {
	    
	    NSString * token = tokenizedCard.creditCardId;

	    // Card token from WePay.
	    NSLog(@"Token: %@", token);
	  
	    // Add code here to send token to your servers
	    
	} failure:^(NSError * error) {
	    
	    // Handle errors

        if ([[error domain] isEqualToString: @"NSURLDomain"])  {
            // Handle network errors
        }
        else {
            // Handle WePay API and Client Side Validation errors
        }

	    NSLog(@"%@", error);    
	}];

### Handling Errors

As shown in the example above, you call the **createCardWithDescriptor** static method with the following parameters: card descriptor, success callback function, and error callback function. *createCardWithDescriptor* validates the customer's input before sending to WePay. 

It generates NSError objects for the following errors and sends these objects to the error callback function.

1. Client Side Validation Errors (i.e. invalid card number, invalid security code, etc)
2. WePay API errors (from WePay.com)
3. Network Errors

All network related errors are in the domain **NSURLDomain**. 1 and 2 type errors are in the **WPAPPDomain** domain. All errors have a localizable user-facing error message that can be retrieved by calling [error localizedDescription]. You can edit the **WePay/Resources/en.lproj/WePay.strings** file to change the error messages.

#### WePay API Errors

The SDK converts WePay API errors (https://www.wepay.com/developer/reference/errors) into NSError objects with the same error codes and descriptions. The userInfo dictionary **WPErrorCategoryKey** key value is the same as the **error** category sent by WePay.

#### Validation

The SDK validates all user input before sending to WePay. Each descriptor class has several validation functions you can use to validate the input yourself. For example, in the WPCreditCardDescriptor class, you will find the following validation functions:

	- (BOOL) validateNumber:(id *)ioValue error:(NSError * __autoreleasing *)outError;
	- (BOOL) validateSecurityCode:(id *)ioValue error:(NSError * __autoreleasing *)outError;
	- (BOOL) validateUser:(id *)ioValue error:(NSError * __autoreleasing *)outError;
	- (BOOL) validateExpirationMonth:(id *)ioValue error:(NSError * __autoreleasing *)outError;
	- (BOOL) validateExpirationYear:(id *)ioValue error:(NSError * __autoreleasing *)outError;

These methods follow the validation method convention used by [key value validation](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html "Key Value Validation"). You can call the validation methods directly, or by invoking validateKey:forKey:error: and specifying the key. 

#### (Advanced) Differentiating between Errors

You can check the error domain to differentiate between **NSURLDomain** and **WPAPPDomain** errors (WePay API and Client-side validation errors).

You can check the value of an error object's **WPErrorCategoryKey** userInfo dictionary key to differentiate between **Client-Side Validation** and **WePay API** errors:

Each WePay API error object has one of the following values for the **WPErrorCategoryKey** userInfo dictionary key that is the same as the **error** category mentioned on [WePay API Errors page](https://www.wepay.com/developer/reference/errors "WePay API errors"):
- invalid_request
- access_denied
- invalid_scope
- invalid_client
- processing_error

Each client side validation error object has one of the following values for the **WPErrorCategoryKey** userInfo dictionary key:
- WPErrorCategoryCardValidation (for WPCreditCardDescriptor validation errors)
- WPErrorCategoryUserValidation (for WPUserDescriptor validation errors)
- WPErrorCategoryAddressValidation (for WPAddressDescriptor validation errors)

Please see the file WePay/WPError.h for more information.

### iOS Example
Run the WePay-Example target. This sample application shows you how to accept payments in your mobile app.
