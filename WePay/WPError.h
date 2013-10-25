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
 Category for NSError 
 (corresponds to WePay API "error" paramater)
 Possible Values:
 - invalid_reques
 - access_denied
 - invalid_scope
 - invalid_client
 - processing_error
 */
FOUNDATION_EXPORT NSString *const WPErrorCategoryKey;

/*
 Category for NSError used when there is no "error" parameter 
 returned by WePay API. For example, when no data is returned. Grave error.
 */
FOUNDATION_EXPORT NSString *const WPErrorCategoryNone;

/*
 Validation categories corresponding to respective descriptor classes.
 */
FOUNDATION_EXPORT NSString *const WPErrorCategoryValidation;
FOUNDATION_EXPORT NSString *const WPErrorCategoryCardValidation;
FOUNDATION_EXPORT NSString *const WPErrorCategoryUserValidation;

FOUNDATION_EXPORT NSString *const WPErrorCategoryAddressValidation;

/*
 SDK Validation NSError codes resulting from invalid input to descriptor classes.
 For example, WPErrorInvalidCard is used as error code in the NSError object when invalid card 
 is passed into carddescriptor class.
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
 Error messages set for NSError NSLocalizedDescriptionKey.
 */
#define WPUnexpectedErrorMessage NSLocalizedStringFromTable(@"There was an unexpected error.", @"WePay", @"There was an unexpected error.");
#define WPNoDataReturnedErrorMessage NSLocalizedStringFromTable(@"There was no data returned.", @"WePay",  @"There was no data returned.");
#define WPUrlRequestFailedMessage NSLocalizedStringFromTable(@"The url request failed.", @"WePay",  @"The url request failed.");

@interface WPError : NSObject

// Maps a validation error code to an error description.
+ (NSString *) validationErrorDescriptionForCode: (WPErrorCode) code;

@end
