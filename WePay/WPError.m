//
//  WPError.m
//  WePay
//
//  Created by WePay on 10/2/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPError.h"

NSString * const WPAPPErrorDomain = @"WPAPPDomain";
NSString * const WPErrorCategoryKey = @"WPErrorCategoryKey";
NSString * const WPErrorCategoryNone = @"WPErrorCategoryNone";
NSString * const WPErrorCategoryCardValidation = @"WPCardValidation";
NSString * const WPErrorCategoryUserValidation = @"WPUserValidation";
NSString * const WPErrorCategoryAddressValidation = @"WPAddressValidation";
NSString * const WPErrorCategoryValidation = @"WPErrorCategoryValidation";

@implementation WPError     
                  
+ (NSString *) validationErrorDescriptionForCode: (WPErrorCode) code {
    static NSDictionary * errorDescriptions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        errorDescriptions  =  @{[NSNumber numberWithInt: WPErrorInvalidUser]:  NSLocalizedStringFromTable(@"User is invalid.", @"WePay", @"validation: invalid user"),
            [NSNumber numberWithInt: WPErrorInvalidUserName]: NSLocalizedStringFromTable(@"User name is invalid.", @"WePay",  @"validation: invalid user name"),
            [NSNumber numberWithInt: WPErrorInvalidUserEmail]: NSLocalizedStringFromTable(@"User email is invalid.", @"WePay",  @"validation: invalid user email"),
            [NSNumber numberWithInt: WPErrorInvalidUserAddress]: NSLocalizedStringFromTable(@"User address is invalid.", @"WePay",  @"validation: invalid user address"),
            [NSNumber numberWithInt: WPErrorInvalidUserCity]: NSLocalizedStringFromTable(@"User city is invalid.", @"WePay",  @"validation: invalid user city"),
            [NSNumber numberWithInt: WPErrorInvalidUserCountry]: NSLocalizedStringFromTable(@"User country is invalid.",  @"WePay", @"validation: invalid user country"),
            [NSNumber numberWithInt: WPErrorInvalidUserZip]: NSLocalizedStringFromTable(@"User zip code is invalid.", @"WePay",  @"validation: invalid user zipcode"),
            [NSNumber numberWithInt: WPErrorInvalidUserState]: NSLocalizedStringFromTable(@"User state is invalid.", @"WePay",  @"validation: invalid user state"),
            [NSNumber numberWithInt: WPErrorInvalidUserPostCode]: NSLocalizedStringFromTable(@"User post code is invalid.", @"WePay",  @"validation: invalid user post code"),
            [NSNumber numberWithInt: WPErrorInvalidUserRegion]: NSLocalizedStringFromTable(@"User region is invalid.", @"WePay",  @"validation: invalid user region"),
            [NSNumber numberWithInt: WPErrorInvalidCard]: NSLocalizedStringFromTable(@"User card is invalid.", @"WePay",  @"validation: invalid card"),
            [NSNumber numberWithInt: WPErrorInvalidCVV]: NSLocalizedStringFromTable(@"User cvv is invalid.", @"WePay",  @"validation: invalid cvv"),
            [NSNumber numberWithInt: WPErrorInvalidExpMonth]: NSLocalizedStringFromTable(@"User exp month is invalid.", @"WePay",  @"validation: invalid exp month"),
            [NSNumber numberWithInt: WPErrorInvalidExpYear]: NSLocalizedStringFromTable(@"User exp year is invalid.",  @"WePay", @"validation: invalid exp year")
        };
    });

    return [errorDescriptions objectForKey: [NSNumber numberWithInt: code]];
}

@end