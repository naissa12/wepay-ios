//
//  WPCreditCard.m
//  WePay
//
//  Created by WePay on 10/17/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPCreditCard.h"

@implementation WPCreditCard

@synthesize creditCardId, state, descriptor;

// Initialize with credit card id
- (id) initWithCreditCardId: (NSString *) aCreditCardId {
    self = [super init];
    
    if(self) {
        [self setCreditCardId: aCreditCardId];
    }
    
    return self;
}


// /credit_card/create API call
+ (void) createCardWithDescriptor: (WPCreditCardDescriptor *) descriptor success: (WPCreditCardSuccessBlock) successHandler failure: (WPCreditCardErrorBlock) errorHandler {
    
    NSError * outError = nil;
    
    if ([descriptor validateReturningError: &outError]) {

        NSMutableDictionary * newParams = [[descriptor dictionary] mutableCopy];
        [newParams setObject: [WePay clientId] forKey: @"client_id"];
        
        [super makeRequestToEndPoint: @"/credit_card/create"
                              values: newParams
                         accessToken: nil
                        successBlock: ^(NSDictionary * returnData) {
                            WPCreditCard * card = [[WPCreditCard alloc] initWithCreditCardId: [returnData objectForKey: @"credit_card_id"]];
                            [card setState: [returnData objectForKey: @"state"]];
                            [card setDescriptor: descriptor];
                            // Call success handler with response.
                            // Pass back WPCreditCard object with response
                            successHandler(card);
                        }
                        errorHandler:^(NSError * error) {
                            // Call error handler with error returned.
                            errorHandler(error);
                        }
         ];
    }
    else {
        errorHandler(outError);
    }
}


// get user's name
- (NSString *) userName {
    return [self.descriptor.user name];
}


// get user's email
- (NSString *) email {
    return [self.descriptor.user email];
}


@end
