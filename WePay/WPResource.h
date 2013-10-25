//
//  WPResource.h
//  WePaySDK
//
//  Created by WePay on 10/24/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WePay.h"
#import "WPError.h"

typedef void (^WPSuccessBlock)(NSDictionary * data);
typedef void (^WPErrorBlock)(NSError * error);

/*
 This class is the parent class for all of the API call classes (i.e WPCreditCard class).
 */
@interface WPResource : NSObject

/*
 Get API root domain.
 */
+ (NSString *) apiRootUrl;

/*
 You call this method to make the actual /credit_card/create API call.
 */
+ (void) makeRequestToEndPoint:(NSString *) endpoint values:(NSDictionary *) params accessToken: (NSString *) accessToken successBlock: (WPSuccessBlock) successHandler errorHandler: (WPErrorBlock) errorHandler;

// Helper for makeRequestToEndPoint to process API call request response
+ (void) processResponse: (NSURLResponse *) response data: (NSData *) data error: (NSError *)error successBlock: (WPSuccessBlock) successHandler errorHandler: (WPErrorBlock) errorHandler;

@end
