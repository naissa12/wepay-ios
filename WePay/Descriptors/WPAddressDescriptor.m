//
//  WPAddressDescriptor.m
//  WePaySDK
//
//  Created by WePay on 10/19/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPAddressDescriptor.h"

@implementation WPAddressDescriptor

@synthesize address1, address2, city, state, postcode, country, zip, region;

# pragma mark init

- (id) initWithAddress1: (NSString *) userAddress1 address2: (NSString *) userAddress2 city: (NSString *) userCity state: (NSString *) userState country: (NSString *) userCountry zip: (NSString *) userZip {

    self = [super init];
    
    if(self) {

        [self setAddress1: userAddress1];
        [self setAddress2: userAddress2];
        [self setCity: userCity];
        [self setState: userState];
        [self setCountry: userCountry];
        [self setZip: userZip];

    }
    
    return self;
}

- (id) initWithZip: (NSString *) zipCode {
    self = [super init];
    
    if(self) {
        [self setZip: zipCode];
        [self setCountry: @"US"];
    }
    
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    
    if (self) {
        
        if([dictionary objectForKey: @"address1"]) {
            self.address1 = [dictionary objectForKey: @"address1"];
        }
        
        if([dictionary objectForKey: @"address2"]) {
            self.address2 = [dictionary objectForKey: @"address2"];
        }
        
        if([dictionary objectForKey: @"state"]) {
            self.state = [dictionary objectForKey: @"state"];
        }
        
        if([dictionary objectForKey: @"postcode"]) {
            self.postcode = [dictionary objectForKey: @"postcode"];
        }
        
        if([dictionary objectForKey: @"city"]) {
            self.city = [dictionary objectForKey: @"city"];
        }
        
        if([dictionary objectForKey: @"zip"]) {
            self.zip = [dictionary objectForKey: @"zip"];
        }
        
        if([dictionary objectForKey: @"country"]) {
            self.country = [dictionary objectForKey: @"country"];
        }
        
        if([dictionary objectForKey: @"region"]) {
            self.region = [dictionary objectForKey: @"region"];
        }
    }
    
    return self;
}


- (NSDictionary *) dictionary {
    
    NSMutableDictionary * returnDictionary = [[NSMutableDictionary alloc] init];
    
    if (self.address1 != nil) {
        [returnDictionary setObject: self.address1 forKey: @"address1"];
    }
  
    if (self.address2 != nil) {
        [returnDictionary setObject: self.address1 forKey: @"address2"];
    }
    
    if (self.city != nil) {
        [returnDictionary setObject: self.city forKey: @"city"];
    }
    
    if (self.state != nil) {
        [returnDictionary setObject: self.state forKey: @"state"];
    }
    
    if (self.country != nil) {
        [returnDictionary setObject: self.country forKey: @"country"];
    }
    
    if (self.zip != nil) {
        [returnDictionary setObject: self.zip forKey: @"zip"];
    }
    
    if (self.region != nil) {
        [returnDictionary setObject: self.region forKey: @"region"];
    }
    
    if (self.postcode != nil) {
        [returnDictionary setObject: self.postcode forKey: @"postcode"];
    }
    
    return returnDictionary;
    
}


- (NSString *) errorCategory {
    return WPErrorCategoryAddressValidation;
}


#pragma mark Key Value validation


-(BOOL)validateAddress1:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    return [self handleNoValueCheckForKey: WPErrorInvalidUserAddress ioValue: ioValue error: outError];
}


-(BOOL)validateCity:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    return [self handleNoValueCheckForKey: WPErrorInvalidUserCity ioValue: ioValue error: outError];
}


-(BOOL)validateState:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    return [self handleNoValueCheckForKey: WPErrorInvalidUserState ioValue: ioValue error: outError];
}


-(BOOL)validateZip: (id *)ioValue error:(NSError * __autoreleasing *)outError {
    if (*ioValue == nil) {
        return [self processValidationErrorForKey: WPErrorInvalidUserZip error: outError];
    }

    NSString * ioValueConverted = (NSString *) *ioValue;
    
    if([ioValueConverted length] != 5) {
        return [self processValidationErrorForKey: WPErrorInvalidUserZip error: outError];
    }
    
    return YES;
}


-(BOOL)validatePostCode:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    return [self handleNoValueCheckForKey: WPErrorInvalidUserPostCode ioValue: ioValue error: outError];
}


-(BOOL)validateCountry:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    return [self handleNoValueCheckForKey: WPErrorInvalidUserCountry ioValue: ioValue error: outError];
}


-(BOOL)validateRegion:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    return [self handleNoValueCheckForKey: WPErrorInvalidUserRegion ioValue: ioValue error: outError];
}


// Only attempt to validate US address for now.
// International addresses will already be valid.
- (BOOL) validateReturningError:(NSError *__autoreleasing *)outError {

    if([self.country isEqualToString: @"US"]) {

        NSString * zipRef = self.zip;
        
        return [self validateZip: &zipRef error: outError];
    }
    else {
        return YES;
    }
}

@end
