//
//  WPCreditCardDescriptor.h
//  WePay
//
//  Created by WePay on 10/2/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPUserDescriptor.h"

/*
 You should create this object and populate its properties with the customer's credit card details. Then to create a token, you pass in this object to createCardWithDescriptor.
 */
@interface WPCreditCardDescriptor : WPDescriptor 

// Credit Card Number
@property (nonatomic, strong) NSString * number;

// Security Code
@property (nonatomic, strong) NSString * securityCode;

// Expiration Month
@property (nonatomic, assign) NSUInteger expirationMonth;

// Expiration Year
@property (nonatomic, assign) NSUInteger expirationYear;

// User
@property (nonatomic, strong) WPUserDescriptor * user;

/*
 You should use this function to initialize this class with the user's credit card details.
 */
- (id) initWithNumber: (NSString *) creditCardNumber securityCode: (NSString *) cvv expMonth: (NSInteger) expMonth expYear: (NSInteger) expYear user: (WPUserDescriptor *) userDescriptor;

/*
 Check to see if credit number passes luhn check.
 */
- (BOOL) isValidLuhnString: (NSString *) string;

/* Validation functions work as described in:
 https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html
 */
- (BOOL) validateNumber:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL) validateSecurityCode:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL) validateUser:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL) validateExpirationMonth:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL) validateExpirationYear:(id *)ioValue error:(NSError * __autoreleasing *)outError;

@end

