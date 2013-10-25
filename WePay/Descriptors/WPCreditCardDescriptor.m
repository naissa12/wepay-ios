//
//  WPCreditCardDescriptor.m
//  WePay
//
//  Created by WePay on 10/2/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPCreditCardDescriptor.h"

@interface WPCreditCardDescriptor()

- (id) removeNonNumbersFromString: (NSString *) aNo;
- (NSInteger) currentMonth;
- (NSInteger) currentYear;

@end

@implementation WPCreditCardDescriptor

@synthesize number, securityCode, expirationMonth, expirationYear, user;

# pragma mark init

- (id) initWithNumber: (NSString *) creditCardNumber securityCode: (NSString *) cvv expMonth: (NSInteger) expMonth expYear: (NSInteger) expYear user: (WPUserDescriptor *) userDescriptor {

    self = [super init];
    
    if(self) {

        [self setNumber: creditCardNumber];
        [self setSecurityCode: cvv];
        [self setExpirationMonth: expMonth];
        [self setExpirationYear: expYear];
        [self setUser: userDescriptor];
    }
    
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dictionary {
    
    self = [super init];
    
    if(self) {

        self.number = [dictionary objectForKey: @"number"];
        self.securityCode = [dictionary objectForKey: @"securityCode"];
        self.expirationMonth = [[dictionary objectForKey: @"expirationMonth"] intValue];
        self.expirationYear = [[dictionary objectForKey: @"expirationYear"] intValue];
        self.user = [[WPUserDescriptor alloc] initWithDictionary: [dictionary objectForKey: @"user"]];
    }
    
    return self;
}


// convert to dictionary needed to make API call
- (NSDictionary *) dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys: self.number, @"cc_number",
            self.securityCode, @"cvv",
            [NSString stringWithFormat: @"%lu", (unsigned long)self.expirationMonth], @"expiration_month",
            [NSString stringWithFormat: @"%lu", (unsigned long)self.expirationYear], @"expiration_year",
            self.user.name, @"user_name",
            self.user.email, @"email",
            [self.user.address dictionary], @"address", nil];
}


- (NSString *) errorCategory {
    return WPErrorCategoryCardValidation;
}


# pragma mark Private Helpers

/* Remove all of non numbers from input. */
- (id) removeNonNumbersFromString: (NSString *) aNo {
	return [[aNo componentsSeparatedByCharactersInSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
}


- (NSInteger) currentYear {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    return [components year];
}


- (NSInteger) currentMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    return [components month];
}


# pragma mark Other Validation

- (BOOL) isValidLuhnString: (NSString *) string {
    
    NSInteger checksum = 0;
    NSUInteger length = [string length];
    NSInteger doub = 0;
    
    for (NSInteger i = length - 1; i >= 0; i -= 2) {
        checksum += [[string substringWithRange:NSMakeRange(i, 1)] integerValue];
    }
    
    for (NSInteger i = length - 2; i >= 0; i -= 2) {
        doub = [[string substringWithRange: NSMakeRange(i, 1)] integerValue] * 2;
        checksum += (doub >= 10) ? doub - 9 : doub;
    }
    
    return ((checksum % 10) == 0);
}


# pragma mark Key Value Validation

- (BOOL) validateNumber:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    
    if(*ioValue == nil) {
        return [self processValidationErrorForKey: WPErrorInvalidCard error: outError];
    }
    
    // remove non numbers from number
    NSString * ioValueConverted = [self removeNonNumbersFromString: (NSString *) *ioValue];
    
    // get length
    NSInteger ioValueLength = [ioValueConverted length];
    
    // Check for correct length. Make sure credit card number passes luhn check.
    if (ioValueLength < 13 || ioValueLength > 19 || ![self isValidLuhnString: ioValueConverted]) {
        return [self processValidationErrorForKey: WPErrorInvalidCard error: outError];
    }
    
    return YES;
}


- (BOOL) validateSecurityCode:(id *)ioValue error:(NSError * __autoreleasing *)outError {
   
    if (*ioValue == nil) {
        return [self processValidationErrorForKey: WPErrorInvalidCVV error: outError];
    }
    
    // remove non numbers from security code
    NSString * ioValueConverted = [self removeNonNumbersFromString: *ioValue];
    
    // get length
    NSInteger ioValueLength = [ioValueConverted length];

    // Make sure security code is correct length.
    if(ioValueLength != 3 && ioValueLength != 4) {
        return [self processValidationErrorForKey: WPErrorInvalidCVV error: outError];
    }
    
    return YES;
}


- (BOOL)validateExpirationMonth:(id *)ioValue error:(NSError * __autoreleasing *)outError {

    if (*ioValue == nil) {
        return [self processValidationErrorForKey: WPErrorInvalidExpMonth error: outError];
    }
    
    NSInteger ioValueConverted = [*ioValue intValue];
    
    if(ioValueConverted >= 1 && ioValueConverted <= 12) {
        
        if(self.expirationYear) {

            NSInteger currentMonth = [self currentMonth];
            NSInteger currentYear = [self currentYear];
            
            // handle 2 digit expiration years. This will break in 2100
            NSInteger realExpirationYear = (self.expirationYear > 99) ? self.expirationYear : (2000 + self.expirationYear);
            
            if(realExpirationYear == currentYear && ioValueConverted < currentMonth) {
                return [self processValidationErrorForKey: WPErrorInvalidExpMonth error: outError];
            }
        }
        
        return YES;
    }
    else {
        return [self processValidationErrorForKey: WPErrorInvalidExpMonth error: outError];
    }
}


-(BOOL) validateExpirationYear:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    
    if (*ioValue == nil) {
        return [self processValidationErrorForKey: WPErrorInvalidUser error: outError];
    }
    
    NSInteger ioValueConverted = [*ioValue intValue];
    
    NSInteger currentMonth = [self currentMonth];
    NSInteger currentYear = [self currentYear];
    
    // Handle 2 digit expiration years. This will break in 2100
    NSInteger realExpirationYear = (ioValueConverted > 99) ? ioValueConverted : (2000 + ioValueConverted);
    
    // Is the expiration year in the past?
    if(realExpirationYear < currentYear) {
        return [self processValidationErrorForKey: WPErrorInvalidExpYear error: outError];
    }
    
    // Is the expiration month in the past?
    if(self.expirationMonth && realExpirationYear == currentYear && self.expirationMonth < currentMonth) {
        return [self processValidationErrorForKey: WPErrorInvalidExpYear error: outError];
    }
    
    return YES;
}


-(BOOL) validateUser:(id *)ioValue error:(NSError * __autoreleasing *)outError {
    
    if (*ioValue == nil) {
        return [self processValidationErrorForKey: WPErrorInvalidUser error: outError];
    }

    WPUserDescriptor * userDescriptor = (WPUserDescriptor *) *ioValue;
    
    NSString * nameRef = userDescriptor.name;
    WPAddressDescriptor * addressRef = userDescriptor.address;
    NSString * emailRef = userDescriptor.email;
    
    BOOL validateName = [userDescriptor validateName: &nameRef error: outError];
    BOOL validateAddress = [addressRef validateReturningError: outError];
    BOOL validateEmail = [userDescriptor validateEmail: &emailRef error: outError];
    
    return validateName && validateEmail && validateAddress;
}


- (BOOL) validateReturningError: (NSError * __autoreleasing *) outError {

    NSString * cardNumber = self.number;
    NSString * cvv = self.securityCode;
    NSString * expMonth = [NSString stringWithFormat: @"%lu", (unsigned long)[self expirationMonth]];
    NSString * expYear = [NSString stringWithFormat: @"%lu", (unsigned long)[self expirationYear]];
    WPUserDescriptor * userDescriptor = self.user;
    
    BOOL validateCard = [self validateNumber: &cardNumber error: outError];
    BOOL validateCVV = [self validateSecurityCode: &cvv error: outError];
    BOOL validateExpMonth = [self validateExpirationMonth: &expMonth error: outError];
    BOOL validateExpYear = [self validateExpirationYear: &expYear error: outError];
    BOOL validateUser = [self validateUser: &userDescriptor error: outError];
    
    return validateUser && validateCard && validateCVV && validateExpMonth && validateExpYear;
}

@end
