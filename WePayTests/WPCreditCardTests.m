//
//  WPCreditCardTests.m
//  WePaySDK
//
//  Created by WePay on 10/23/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPCreditCard.h"
#import "WPCreditCardTests.h"

@interface  WPCreditCardTests()
{
    WPUserDescriptor * userDescriptor;
    WPCreditCardDescriptor * cardDescriptor;
}
@end

@implementation WPCreditCardTests

- (void)setUp
{
    [super setUp];
    
    userDescriptor = [[WPUserDescriptor alloc] init];
    userDescriptor.name = @"Bill Clerico";
    userDescriptor.email = @"test@wepay.com";
    userDescriptor.address = [[WPAddressDescriptor alloc] initWithZip: @"94085"];
    
    cardDescriptor = [[WPCreditCardDescriptor alloc] init];
    cardDescriptor.number = @"4242424242424242";
    cardDescriptor.expirationMonth = 1;
    cardDescriptor.expirationYear = 2040;
    cardDescriptor.securityCode = @"321";
    cardDescriptor.user = userDescriptor;
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// test createCardWithDescriptor function
- (void) testReceivesToken {
    
    [WePay setStageClientId:  @"99824"];
    [WPCreditCard createCardWithDescriptor: cardDescriptor success: ^(WPCreditCard * tokenizedCard) {
        STAssertNotNil(tokenizedCard, @"tokenized card cannot be nil");
        STAssertTrue([tokenizedCard.creditCardId length] >= 1, @"Should have received valid token from WePay.");
        
    } failure:^(NSError * error) {
        STFail(@"Should not have thrown error.");
    }];
}

@end
