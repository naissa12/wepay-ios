//
//  WePay.m
//  WePay
//
//  Created by WePay on 10/2/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WePay.h"


@interface WePay()

@end

@implementation WePay

// Is this on production or stage?
static BOOL onProduction;

// Client id to make API calls.
static NSString * clientId;

+ (id)alloc
{
    [NSException raise:@"CannotInstantiateStaticClass" format:@"WePay is a static class and cannot be instantiated."];
    return nil;
}

# pragma mark Set Credentials

/*
 Use production environment. Set application client ID.
 */
+ (void) setProductionClientId:(NSString *) key {
    clientId = key;
    onProduction = YES;
}


/*
 Use stage environment. Set application client ID.
 */
+ (void) setStageClientId:(NSString *) key {
    clientId = key;
    onProduction = NO;
}


# pragma mark Validate Credentials

/*
 Throws an Exception if developer does not set his client id.
 */
+ (void) validateCredentials
{
    if(clientId == nil || [clientId length] == 0) {
        [NSException raise:@"InvalidCredentials" format:@"Please make sure you add a client ID."];
    }
}


+ (BOOL) isProduction {
    return onProduction;
}


+ (NSString *) clientId {
    return clientId;
}

@end
