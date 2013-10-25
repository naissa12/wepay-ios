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
 Class that all other API call classes like WPCreditCard extend from.
 Makes actual API request call to WePay.
 */
@interface WPResource : NSObject

/*
 Get API root domain.
 */
+ (NSString *) apiRootUrl;

/*
 Make API request to endpoint.
 Call successhandler with data returned in NSDictionary format.
 Call error handler with NSError returned.
 */
+ (void) makeRequestToEndPoint:(NSString *) endpoint values:(NSDictionary *) params accessToken: (NSString *) accessToken successBlock: (WPSuccessBlock) successHandler errorHandler: (WPErrorBlock) errorHandler;

/*
 Process Response from makeRequestToEndpoint.
 */
+ (void) processResponse: (NSURLResponse *) response data: (NSData *) data error: (NSError *)error successBlock: (WPSuccessBlock) successHandler errorHandler: (WPErrorBlock) errorHandler;

@end
