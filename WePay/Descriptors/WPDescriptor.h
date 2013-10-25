//
//  WPDescriptor.h
//  WePaySDK
//
//  Created by WePay on 10/17/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPError.h"
#import <Foundation/Foundation.h>

/*
 Protocol for all of the descriptors
 */
@protocol WPDescriptor <NSObject>

@property (nonatomic, strong) NSMutableArray * errors;

/*
 Initialize with dictionary and set properties.
 */
- (id) initWithDictionary: (NSDictionary *) dictionary;

/*
 Convert property values into NSDictionary.
 */
- (NSDictionary *) dictionary;

/*
 When there is a validation error (i.e invalid credit card number), the SDK returns an NSError object with errorCategory as the userInfo dictionary WPErrorCategoryKery key value.
 */
- (NSString *) errorCategory;

@optional

/*
 This validates a fully populated descriptor class to check for all errors. For example, if you want to determine whether a card descriptor object is valid (whether a customer's credit card information is valid), call this function on the credit card descriptor object.
*/
- (BOOL) validateReturningError: (NSError * __autoreleasing *) outError;

@end

@interface WPDescriptor : NSObject <WPDescriptor>

/*
 Checks if ioValue is empty or nil and calls processValidationErrorForKey.
 */
- (BOOL) handleNoValueCheckForKey: (WPErrorCode) code ioValue: (id *) ioValue error: (NSError * __autoreleasing *)outError;

/*
 The validation functions in each descriptor class call this method to actually set an NSError object. For example, if their is an invalid card number, the validateNumber function in WPCreditCardDescriptor class calls this method to populate the outError parameter with a NSError object.
 */
- (BOOL) processValidationErrorForKey: (WPErrorCode) code error: (NSError * __autoreleasing *)outError;

@end
