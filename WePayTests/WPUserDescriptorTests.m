//
//  WPUserDescriptorTests.m
//  WePaySDK
//
//  Created by WePay on 10/23/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPUserDescriptor.h"
#import "WPUserDescriptorTests.h"

@interface WPUserDescriptorTests()
{
    NSString * testName;
    NSString * testEmail;
    NSString * testZipcode;
    WPAddressDescriptor * testAddress;
    WPUserDescriptor * testUser;
}

- (void) checkValidateFunctionResponse: (BOOL) didValidate error: (NSError *) error code: (NSInteger) code type: (NSString *) type;

@end

@implementation WPUserDescriptorTests


- (void)setUp
{
    [super setUp];
    
    testName = @"Bill Clerico";
    testEmail = @"test@wepay.com";
    testZipcode = @"94085";
    testAddress = [[WPAddressDescriptor alloc] initWithZip: testZipcode];
    
    testUser = [[WPUserDescriptor alloc] init];
    testUser.name = testName;
    testUser.email = testEmail;
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void) checkValidateFunctionResponse: (BOOL) didValidate error: (NSError *) error code: (NSInteger) code type: (NSString *) type {

    NSDictionary * userinfo = [error userInfo];
    
    // check if validation function returns NO
    STAssertFalse(didValidate, @"%@ should be invalid.", type);
    
    // check error count
    STAssertTrue([testUser.errors count] == 1, @"%@ Error count is %d should be 1", type, [testUser.errors count]);
    
    // check error code
    STAssertTrue([error code] == code, @"%@ Error code = %d, should be %d", type,[error code], code);
    
    // check error category
    STAssertEqualObjects([userinfo objectForKey: WPErrorCategoryKey], [testUser errorCategory], @"Error category = %@, should be %@", [userinfo objectForKey: WPErrorCategoryKey], [testUser errorCategory]);
}


// test initWithDictionary function
- (void) testCreateUserWithDictionary
{
    NSDictionary * addressDictionary = [NSDictionary dictionaryWithObjectsAndKeys: testZipcode, @"zipcode", nil];
    WPUserDescriptor * user = [[WPUserDescriptor alloc] initWithDictionary: [NSDictionary dictionaryWithObjectsAndKeys: testName, @"name", testEmail, @"email", addressDictionary, @"address", nil]];
    
    STAssertEqualObjects(user.name, testName, @"User name = %@, should equal %@", user.name, testName);
    STAssertEqualObjects(user.email, testEmail, @"User email = %@, should equal %@", user.email, testEmail);
    STAssertNotNil(user.address, @"User address should not be nil.");
}

// test invalid email
- (void) testInvalidEmailReturnsCorrectError {
 
    testUser.email = @"test";
    
    NSError * error = nil;
    
    NSString * invalidValue = @"test";
    BOOL doValidate = [testUser validateEmail: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: doValidate error: error code: WPErrorInvalidUserEmail type: @"User Email"];
}


// test invalid name
- (void) testInvalidNameReturnsCorrectError {
    
    testUser.name = @"";
    
    NSError * error = nil;
    NSString * invalidValue = testUser.name;
    BOOL doValidate = [testUser validateName: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: doValidate error: error code: WPErrorInvalidUserName type: @"User Name"];
}


// test invalid address
- (void) testInvalidAddressReturnsCorrectError {
    
    testUser.address = nil;
    
    NSError * error = nil;
    WPAddressDescriptor * invalidValue = testUser.address;
    BOOL doValidate = [testUser validateAddress: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: doValidate error: error code: WPErrorInvalidUserAddress type: @"User Address"];
}

@end
