//
//  WPDescriptor.m
//  WePaySDK
//
//  Created by WePay on 10/17/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPUserDescriptor.h"

@interface  WPUserDescriptor()

@end

@implementation WPUserDescriptor

@synthesize name, email, address;

# pragma  mark init

- (id) initWithDictionary: (NSDictionary *) dictionary {

    self = [super init];
    
    if (self) {
        
        if([dictionary objectForKey: @"name"]) {
            self.name = [dictionary objectForKey: @"name"];
        }
        
        if([dictionary objectForKey: @"email"]) {
            self.email = [dictionary objectForKey: @"email"];
        }
        
        if([dictionary objectForKey: @"address"]) {
            self.address = [[WPAddressDescriptor alloc] initWithDictionary: [dictionary objectForKey: @"address"]];
        }
    }
    
    return self;
}


// convert property values to dictionary
- (NSDictionary *) dictionary {
    
    NSMutableDictionary * userdic = [[NSMutableDictionary alloc] init];
    
    if(self.name != nil) {
        [userdic setObject: self.name forKey: @"user_name"];
    }
    
    if(self.email != nil) {
        [userdic setObject: self.email forKey: @"email"];
    }
    
    if(self.address != nil) {
        [userdic setObject: [self.address dictionary] forKey: @"address"];
    }
    
    return userdic;
}

# pragma mark Error Category
- (NSString *) errorCategory {
    return WPErrorCategoryUserValidation;
}


#pragma  mark Helpers

- (BOOL) isValidUserEmail: (NSString *) emailValue {

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject: emailValue];
    
}

#pragma mark Key Value validation

- (BOOL) validateName:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    return [self handleNoValueCheckForKey: WPErrorInvalidUserName ioValue: ioValue error: outError];
}


- (BOOL) validateEmail:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    // Is email specified and is it valid?
    if (*ioValue == nil || [(NSString *) *ioValue length] < 1 || ![self isValidUserEmail: (NSString *)*ioValue]) {
        return [self processValidationErrorForKey:  WPErrorInvalidUserEmail error: outError];
    }
    return YES;
}


- (BOOL) validateAddress:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    
    if (*ioValue == nil) {
        return [self processValidationErrorForKey: WPErrorInvalidUserAddress error: outError];
    }
    
    return [((WPAddressDescriptor *) *ioValue) validateReturningError: outError];
}

@end
