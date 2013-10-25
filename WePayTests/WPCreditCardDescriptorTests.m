//
//  WPCreditCardDescriptor.m
//  WePaySDK
//
//  Created by WePay on 10/23/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPError.h"
#import "WPCreditCardDescriptor.h"
#import "WPCreditCardDescriptorTests.h"

@interface WPCreditCardDescriptorTests()
{
    // sample values
    WPCreditCardDescriptor * card;
    WPUserDescriptor * testUser;
    
    NSString * testCardNumber;
    NSString * testName;
    NSString * testEmail;
    NSString * testZipcode;
    NSString * testSecurityCode;
    NSInteger testExpMonth;
    NSInteger testExpYear;
}

// checks the number of errors, errors code, and category.
- (void) checkValidateFunctionResponse: (BOOL) didValidate error: (NSError *) error code: (NSInteger) code type: (NSString *) type;

// checks that no errors were set.
- (void) checkNoErrors: (BOOL) didValidate error: (NSError *) error type: (NSString *) type;

@end

@implementation WPCreditCardDescriptorTests


- (void)setUp
{
    testCardNumber = @"4242424242424242";
    testSecurityCode = @"312";
    testExpMonth = 2;
    testExpYear = 2030;
    testName = @"Bill Clerico";
    testZipcode = @"94085";
    testEmail = @"test@wepay.com";
    
    testUser = [[WPUserDescriptor alloc] init];
    testUser.name = testName;
    testUser.email = testEmail;
    testUser.address = [[WPAddressDescriptor alloc] initWithZip: testZipcode];
    
    card = [[WPCreditCardDescriptor alloc] initWithNumber: testCardNumber securityCode: testSecurityCode expMonth: testExpMonth expYear: testExpYear user: testUser];
}


// test multiple validation errors
- (void) testErrorCountWithMultipleErrors {
    
    card.number = @"";
    card.securityCode = @"";
    card.expirationMonth = 13;
    card.expirationYear = 2000;
    
    NSError * error = nil;
    BOOL doValidate = [card validateReturningError: &error];
    
    STAssertFalse(doValidate, @"Multiple card errors should not validate.");
    STAssertTrue([card.errors count] == 4, @"Error count = %d, should be %d", [card.errors count], 4);
    STAssertNotNil(error, @"Card validation should have produced error object.");
}


// helper
- (void) checkValidateFunctionResponse: (BOOL) didValidate error: (NSError *) error code: (NSInteger) code type: (NSString *) type {
    NSDictionary * userinfo = [error userInfo];
    STAssertFalse(didValidate, @"%@ should be invalid.", type);
    STAssertTrue([card.errors count] == 1, @"%@: Error count is %d should be 1", type, [card.errors count]);
    STAssertTrue([error code] == code, @"%@: Error code %d, should be %d", type, [error code], code);
    STAssertEqualObjects([userinfo objectForKey: WPErrorCategoryKey], WPErrorCategoryCardValidation, @"%@ Error category = %@, should be %@", type, [userinfo objectForKey: WPErrorCategoryKey], [card errorCategory]);
}

// test initWithDictionary
- (void) testCreateCardWithDictionary
{
    NSString * testExpMonthStr = [NSString stringWithFormat: @"%i", testExpMonth];
    NSString * testExpYearStr = [NSString stringWithFormat: @"%i", testExpYear];
    
    NSDictionary * addressDictionary = [NSDictionary dictionaryWithObjectsAndKeys: testZipcode, @"zip", nil];
    NSDictionary * userDictionary = [NSDictionary dictionaryWithObjectsAndKeys: testName, @"name", testEmail, @"email", addressDictionary, @"address", nil];
    NSDictionary * cardDictionary = [NSDictionary dictionaryWithObjectsAndKeys: testCardNumber, @"number", testSecurityCode, @"securityCode", testExpMonthStr, @"expirationMonth", testExpYearStr, @"expirationYear", userDictionary, @"user", nil];
    
    WPCreditCardDescriptor * cardFromDictionary = [[WPCreditCardDescriptor alloc] initWithDictionary: cardDictionary];
    
    STAssertEqualObjects(cardFromDictionary.number, testCardNumber, @"Card = %@, should = %@", cardFromDictionary.number, testCardNumber);
    STAssertEqualObjects(cardFromDictionary.securityCode, testSecurityCode, @"Security code = %@, should = %@", cardFromDictionary.securityCode, testSecurityCode);
    STAssertTrue(cardFromDictionary.expirationMonth == testExpMonth, @"Exp month = %@, should = %@", cardFromDictionary.expirationMonth, testExpMonth);
    STAssertTrue(cardFromDictionary.expirationYear == testExpYear, @"Exp year = %@, should = %@", cardFromDictionary.expirationYear, testExpYear);
}

// helper for no errors
- (void) checkNoErrors: (BOOL) didValidate error: (NSError *) error type: (NSString *) type
{
    STAssertTrue(didValidate, @"%@: Should past validation tests.", type);
    STAssertTrue(([card.errors count] == 0), @"%@: Error count = %d, should be = %d", type, [card.errors count], 0);
    STAssertTrue(error == nil, @"%@: Card validation should not produce any errors.", type);
}


// test card creation
- (void) testCreateCard
{
    STAssertTrue(([card expirationMonth] == testExpMonth), @"expmonth should be set correctly");
    STAssertTrue([card expirationYear] == testExpYear, @"expyear should be set correctly");
    STAssertEqualObjects(card.securityCode, testSecurityCode,  @"Security code should be set correctly");
    STAssertEqualObjects(card.number, testCardNumber,  @"Card Number should be set correctly.");
}


// test valid card returns no error
- (void) testValidCardReturnsNoError {

    NSError * error = nil;
    BOOL didValidate = [card validateReturningError: &error];
    
    [self checkNoErrors: didValidate error: error type: @"Card"];
}


// tests validateExpirationYear
- (void) testExpirationYearInFutureReturnsNoError {
    
    card.expirationYear = 2020;
    
    NSString * validValue = [NSString stringWithFormat: @"%i", card.expirationYear];

    NSError * error = nil;
    BOOL didValidate = [card validateExpirationYear: &validValue error: &error];
    
    [self checkNoErrors: didValidate error: error type: @"Expiration Year"];
}


// tests validateExpirationYear
- (void) testValidCVVReturnsNoError {
    
    card.securityCode = @"342";
    
    NSString * validValue = card.securityCode;
    
    NSError * error = nil;
    BOOL didValidate = [card validateSecurityCode: &validValue error: &error];
    
    [self checkNoErrors: didValidate error: error type: @"CVV"];
}


// tests validateExpirationYear
- (void) testValidExpirationMonthReturnsNoError {
    
    card.expirationMonth = 2;
    
    NSString * validValue = [NSString stringWithFormat: @"%i", card.expirationMonth];
    
    NSError * error = nil;
    BOOL didValidate = [card validateExpirationMonth: &validValue error: &error];
    
    [self checkNoErrors: didValidate error: error type: @"Exp Month"];
}

// tests validateUser
- (void) testValidUserReturnsNoError {
    
    WPUserDescriptor * validValue = testUser;
    
    NSError * error = nil;
    BOOL didValidate = [card validateUser: &validValue error: &error];
    
    [self checkNoErrors: didValidate error: error type: @"User"];
}


// tests validateNumber
- (void) testValidCardNumberReturnsNoError {
    
    NSString * validValue = testCardNumber;
    
    NSError * error = nil;
    BOOL didValidate = [card validateNumber: &validValue error: &error];
    
    [self checkNoErrors: didValidate error: error type: @"Card Number"];
}


// test invalid card returns correct error
- (void) testInvalidCardReturnsCorrectError {

    card.number = @"9444";
    
    NSError * error = nil;
    BOOL didValidate = [card validateReturningError: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidCard type: @"Card"];
    
}

// test invalid cvv returns correct error
- (void) testInvalidCVVReturnsCorrectError {

    card.securityCode = @"44";
    
    NSError * error = nil;
    BOOL didValidate = [card validateReturningError: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidCVV type: @"CVV"];
}


// test expired card returns correct error
- (void) testCardExpiredReturnsCorrectError {

    card.expirationYear = 2000;
    
    NSError * error = nil;
    BOOL didValidate = [card validateReturningError: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidExpYear type: @"Expired card"];
}


// tests validateNumber function
- (void) testInvalidCard {
    
    card.number = @"ttt";
    
    NSString * invalidValue = card.number;
    NSError * error = nil;
    BOOL didValidate = [card validateNumber: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidCard type: @"Card"];
}

// tests validateSecurityCode
- (void) testInvalidCVV {
    
    card.securityCode = @"44";
    
    NSError * error = nil;
    NSString * invalidValue = card.securityCode;
    BOOL didValidate = [card validateSecurityCode: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidCVV type: @"CVV"];
}

// tests validateExpirationMonth
- (void) testInvalidExpMonth {
    
    card.expirationMonth = 13;
    
    NSString * invalidValue =[NSString stringWithFormat: @"%i", card.expirationMonth];
    NSError * error = nil;
    BOOL didValidate = [card validateExpirationMonth: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidExpMonth type: @"Exp Month"];
}

// tests validateExpirationYear
- (void) testExpiredCard {
    
    card.expirationYear = 2000;
    NSString * invalidValue =[NSString stringWithFormat: @"%i", card.expirationYear];

    NSError * error = nil;
    BOOL didValidate = [card validateExpirationYear: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidExpYear type: @"Exp Year"];
}


// test correctly converts into dictionary
- (void) testDictionary {
    
    NSDictionary * dictionary = [card dictionary];
    
    STAssertEqualObjects([dictionary objectForKey: @"cc_number"], testCardNumber, @"Card number = %@, should be %@", [dictionary objectForKey: @"cc_number"], testCardNumber);
    STAssertEqualObjects([dictionary objectForKey: @"cvv"], testSecurityCode, @"Security Code = %@, should be %@",[dictionary objectForKey: @"cvv"], testSecurityCode);
    STAssertEqualObjects([dictionary objectForKey: @"user_name"], testUser.name, @"User name = %@, should be %@",[dictionary objectForKey: @"user_name"], testUser.name);
    STAssertEqualObjects([dictionary objectForKey: @"email"], testUser.email, @"User email = %@, should be %@", [dictionary objectForKey: @"email"], testUser.email);
    STAssertFalse([dictionary objectForKey: @"address"] == nil, @"User address = %@, should be set.", [dictionary objectForKey: @"address"]);
}

@end
