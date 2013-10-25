//
//  WPCreditCard.h
//  WePay
//
//  Created by WePay on 10/7/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPResource.h"
#import "WPCreditCardDescriptor.h"

@interface WPCreditCard : WPResource

// success and error block
typedef void (^WPCreditCardSuccessBlock) (WPCreditCard * data);
typedef void (^WPCreditCardErrorBlock) (NSError * error);

@property (nonatomic, strong) NSString * creditCardId;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) WPCreditCardDescriptor * descriptor;

@property (nonatomic, readonly) NSString * userName;
@property (nonatomic, readonly) NSString * email;

/*
 Initialize object with credit card id.
 */
- (id) initWithCreditCardId: (NSString *) aCreditCardId;

/*
 Makes /credit_card/create API call. Sends credit card details to WePay. Receives back token.
 
 @param descriptor Card descriptor with the customer's card details
 @param success Success callback function to call if gets back valid response
 @param failure Error callback function to call if there is an error
 
 */
+ (void) createCardWithDescriptor: (WPCreditCardDescriptor *) descriptor success: (WPCreditCardSuccessBlock) successHandler failure: (WPCreditCardErrorBlock) errorHandler;

@end
