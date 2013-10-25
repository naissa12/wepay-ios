//
//  WPError.h
//  WePay
//
//  Created by WePay on 10/2/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//
#import <Foundation/Foundation.h>

/*
 Domain for NSError. 
 */
FOUNDATION_EXPORT NSString *const WPAPPErrorDomain;

/*
 The category an NSError is for. Corresponds to the "error" property 
 returned in errors from the WePay API. 
 
 Possible Values - WePay API:
 - invalid_request
 - access_denied
 - invalid_scope
 - invalid_client
 - processing_error
 
 Possible values - Client-side Validation:
 - WPErrorCategoryCardValidation (validation error in the card descriptor class)
 - WPErrorCategoryUserValidation (validation error in the user descriptor class)
 - WPErrorCategoryAddressValidation (validation error in the address descriptor class)

*/

FOUNDATION_EXPORT NSString *const WPErrorCategoryKey;

FOUNDATION_EXPORT NSString *const WPErrorCategoryNone;

/*
 These values may be returned for WPErrorCategoryKey from the call to createCardWithDescriptor or from validation function calls.
 */
FOUNDATION_EXPORT NSString *const WPErrorCategoryValidation;
FOUNDATION_EXPORT NSString *const WPErrorCategoryCardValidation;
FOUNDATION_EXPORT NSString *const WPErrorCategoryUserValidation;
FOUNDATION_EXPORT NSString *const WPErrorCategoryAddressValidation;

/*
 Validation functions return NSError objects with these codes
 */
typedef NS_ENUM(NSInteger, WPErrorCode) {
    WPErrorUnknown = -10000,
    WPErrorInvalidCard,
    WPErrorInvalidCVV,
    WPErrorInvalidExpMonth,
    WPErrorInvalidExpYear,
    WPErrorInvalidUser,
    WPErrorInvalidUserName,
    WPErrorInvalidUserAddress,
    WPErrorInvalidUserEmail,
    WPErrorInvalidUserCity,
    WPErrorInvalidUserState,
    WPErrorInvalidUserCountry,
    WPErrorInvalidUserZip,
    WPErrorInvalidUserPostCode,
    WPErrorInvalidUserRegion
};

/*
 Maps to NSLocalizedDescriptionKey
 */
#define WPUnexpectedErrorMessage NSLocalizedStringFromTable(@"There was an unexpected error.", @"WePay", @"There was an unexpected error.");
#define WPNoDataReturnedErrorMessage NSLocalizedStringFromTable(@"There was no data returned.", @"WePay",  @"There was no data returned.");
#define WPUrlRequestFailedMessage NSLocalizedStringFromTable(@"The url request failed.", @"WePay",  @"The url request failed.");

@interface WPError : NSObject

// Maps a validation error code to an error description
+ (NSString *) validationErrorDescriptionForCode: (WPErrorCode) code;

@end
