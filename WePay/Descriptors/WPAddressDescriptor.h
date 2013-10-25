//
//  WPAddressDescriptor.m
//  WePaySDK
//
//  Created by WePay on 10/19/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPDescriptor.h"

/*
 WPAddressDescriptor is a descriptor class used to pass in and validate user address.
*/
@interface WPAddressDescriptor : WPDescriptor 

@property (nonatomic, strong) NSString * address1;
@property (nonatomic, strong) NSString * address2;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * zip;
@property (nonatomic, strong) NSString * country;
@property (nonatomic, strong) NSString * region;
@property (nonatomic, strong) NSString * postcode;

/*
 Initialize address.
 */
- (id) initWithAddress1: (NSString *) userAddress1 address2:  (NSString *) userAddress2 city:  (NSString *) userCity state: (NSString *) userState country: (NSString *) userCountry zip: (NSString *) userZip;

/*
 You can use this constructor for US customers only. 
 For US only, you do not have to send the customer's full address, but you do have to send their zipcode.
 */
- (id) initWithZip: (NSString *) zipCode;

/* 
 Validation functions work as described in:
 https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html
 */
- (BOOL)validateAddress1:(id *)ioValue error:(NSError * __autoreleasing *)outError;

- (BOOL)validateCity:(id *)ioValue error:(NSError * __autoreleasing *)outError;

- (BOOL)validateState:(id *)ioValue error:(NSError * __autoreleasing *)outError;

- (BOOL)validateZip: (id *)ioValue error:(NSError * __autoreleasing *)outError;

- (BOOL)validatePostCode:(id *)ioValue error:(NSError * __autoreleasing *)outError;

- (BOOL)validateCountry:(id *)ioValue error:(NSError * __autoreleasing *)outError;

- (BOOL)validateRegion:(id *)ioValue error:(NSError * __autoreleasing *)outError;


/* 
 Validation function to call other validation functions.
 */
- (BOOL) validateReturningError:(NSError *__autoreleasing *)outError;


@end
