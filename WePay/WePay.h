//
//  WePay.h
//  WePay
//
//  Created by WePay on 10/2/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WePay : NSObject

/*
 Set Stage client id.
 */
+ (void) setStageClientId:(NSString *) key;

/*
 Set Production client id.
 */
+ (void) setProductionClientId:(NSString *) key;

/*
 Is client id set or throw error?
 */
+ (void) validateCredentials;

/*
 Static method other classes call to check if API calls should be made on Production.
 */
+ (BOOL) isProduction;

/*
 Static method other classes call to get client id.
 */
+ (NSString *) clientId;

@end
