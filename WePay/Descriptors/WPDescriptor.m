//
//  WPDescriptor.m
//  WePaySDK
//
//  Created by WePay on 10/19/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPDescriptor.h"

@implementation WPDescriptor

@synthesize errors;

- (id) init {
    self = [super init];
    
    if (self) {
        errors = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (id) initWithDictionary: (NSDictionary *) dictionary {

    self = [self init];

    return self;
}


- (NSDictionary *) dictionary {
    return nil;
}


- (BOOL) handleNoValueCheckForKey: (WPErrorCode) code ioValue: (id *) ioValue error: (NSError * __autoreleasing *) outError {
    
    if (*ioValue == nil || ([(NSString *)*ioValue length] < 1)) {
        return [self processValidationErrorForKey: code error: outError];
    }

    return YES;
}


- (NSString *) errorCategory {
    return WPErrorCategoryValidation;
}


- (BOOL) processValidationErrorForKey: (WPErrorCode) code error: (NSError * __autoreleasing *)outError {
    
    // Error description
    NSString * errorString = [WPError validationErrorDescriptionForCode: code];
    
    // Add error description to errors array.
    [self.errors addObject: errorString];
    
    if(outError != NULL) {

        // Set user info dictionary with error description as NSLocalizedDescriptionKey and specific error category for descriptor class.
        NSDictionary * userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys: errorString, NSLocalizedDescriptionKey, [self errorCategory], WPErrorCategoryKey, nil];
        
        // Validation NSError Object
        *outError = [[NSError alloc] initWithDomain: WPAPPErrorDomain code: code userInfo: userInfoDict];
    }
    
    return NO;
}

@end
