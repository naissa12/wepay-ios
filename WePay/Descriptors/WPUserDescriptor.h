//
//  WPUserDescriptor.h
//  WePay
//
//  Created by WePay on 10/17/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPAddressDescriptor.h"

@interface WPUserDescriptor : WPDescriptor 

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) WPAddressDescriptor * address;

/* 
 Check if user email is valid.
 */
- (BOOL) isValidUserEmail: (NSString *) email;

/* Validation functions follows key value coding:
 https://developer.apple.com/library/mac/documentation/cocoa/conceptual/KeyValueCoding/Articles/Validation.html
 */
- (BOOL) validateName:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL) validateEmail:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL) validateAddress:(id *)ioValue error:(NSError * __autoreleasing *)outError;

@end
