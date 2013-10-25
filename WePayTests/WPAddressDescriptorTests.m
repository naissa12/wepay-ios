//
//  WPAddressDescriptorTests.m
//  WePaySDK
//
//  Created by WePay on 10/23/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPError.h"
#import "WPAddressDescriptor.h"
#import "WPAddressDescriptorTests.h"

@interface WPAddressDescriptorTests()

- (void) checkValidateFunctionResponse: (BOOL) didValidate error: (NSError *) error code: (NSInteger) code type: (NSString *) type;

@end

@implementation WPAddressDescriptorTests
{
    WPAddressDescriptor * address;
    
    NSString * testAddress1;
    NSString * testAddress2;
    NSString * testCity;
    NSString * testState;
    NSString * testCountry;
    NSString * testZipcode;
    NSString * testRegion;
    NSString * testPostalCode;
}

- (void)setUp {
    
    testAddress1 = @"Main Street";
    testAddress2 = @"Address 2 Test";
    testCity = @"Sunnyvale";
    testState = @"CA";
    testCountry = @"US";
    testZipcode = @"94085";
    testRegion = @"Test Region";
    testPostalCode = @"B1000TBU";
    
    address = [[WPAddressDescriptor alloc] initWithAddress1: testAddress1 address2: nil city: testCity state: testState country: testCountry zip: testZipcode];
}


// test initWithDictionary
- (void) testCreateAddressWithDictionary {
    
    NSDictionary * addressDictionary = [NSDictionary dictionaryWithObjectsAndKeys: testAddress1, @"address1", testAddress2, @"address2", testCity, @"city", testState, @"state", testZipcode, @"zip", testCountry, @"country", nil];
    
    WPAddressDescriptor * address_2 = [[WPAddressDescriptor alloc] initWithDictionary: addressDictionary];

    STAssertEqualObjects(address_2.address1, testAddress1,  @"Address1 = %@, should equal %@", address_2.address1, testAddress1);
    STAssertEqualObjects(address_2.address2, testAddress2,  @"Address2 = %@, should equal %@", address_2.address2, testAddress2);
    STAssertEqualObjects(address_2.city, testCity,  @"City = %@, should equal %@", address_2.city, testCity);
    STAssertEqualObjects(address_2.zip, testZipcode,  @"Zip = %@, should equal %@", address_2.zip, testZipcode);
    STAssertEqualObjects(address_2.state, testState,  @"State = %@, should equal %@", address_2.state, testState);
    STAssertEqualObjects(address_2.country, testCountry,  @"Country = %@, should equal %@", address_2.country, testCountry);
    

    NSDictionary * addressDictionary_2 = [NSDictionary dictionaryWithObjectsAndKeys: testAddress1, @"address1", testAddress2, @"address2", testCity, @"city",testRegion, @"region", testPostalCode, @"postcode", @"UK", @"country", nil];
    
    WPAddressDescriptor * address_3 = [[WPAddressDescriptor alloc] initWithDictionary: addressDictionary_2];
    STAssertEqualObjects(address_3.address1,  testAddress1,  @"Address1 = %@, should equal %@", address_3.address1, testAddress1);
    STAssertEqualObjects(address_3.address2,  testAddress2,  @"Address2 = %@, should equal %@", address_3.address2, testAddress2);
    STAssertEqualObjects(address_3.city,  testCity,  @"City = %@, should equal %@", address_3.city, testCity);
    STAssertEqualObjects(address_3.postcode,  testPostalCode,  @"Postal code = %@, should equal %@", address_3.postcode, testPostalCode);
    STAssertEqualObjects(address_3.country,  @"UK",  @"Country = %@, should equal %@", address_3.country, @"UK");
}

- (void) checkValidateFunctionResponse: (BOOL) didValidate
                              error: (NSError *) error
                               code: (NSInteger) code
                               type: (NSString *) type {
    
    NSDictionary * userinfo = [error userInfo];
    
    STAssertFalse(didValidate, @"%@ should not be valid.", type);
    STAssertTrue([address.errors count] == 1, @"Error count is %d should be 1", [address.errors count]);
    STAssertTrue([error code] == code, @"Error code %d, should be %d", [error code], code);
    STAssertEqualObjects([userinfo objectForKey: WPErrorCategoryKey], [address errorCategory], @"Error category = %@, should be %@", [userinfo objectForKey: WPErrorCategoryKey], [address errorCategory]);
}


// test address creation
- (void) testCreateAddress {
    STAssertEqualObjects(address.address1,  testAddress1,  @"Address1 = %@, should equal %@", address.address1, testAddress1);
    STAssertEqualObjects(address.city,  testCity,  @"City = %@, should equal %@", address.city, testCity);
    STAssertEqualObjects(address.zip,  testZipcode,  @"Zip = %@, should equal %@", address.zip, testZipcode);
    STAssertEqualObjects(address.state,  testState,  @"State = %@, should equal %@", address.state, testState);
    STAssertEqualObjects(address.country,  testCountry,  @"Country = %@, should equal %@", address.country, testCountry);
}


// test zip only address creation
- (void) testCreateZipOnlyAddress {
    WPAddressDescriptor * address_2 = [[WPAddressDescriptor alloc] initWithZip: testZipcode];
    STAssertEqualObjects(address_2.zip,  testZipcode,  @"Zip = %@, should equal %@", address_2.zip, testZipcode);
    STAssertEqualObjects(address_2.country,  @"US",  @"Country = %@, should equal US", address_2.country);

}


// test that an invalid address returns correct error
- (void) testInvalidAddressReturnsTheCorrectError {
    NSError * error = nil;
    NSString * invalidValue = @"";
    BOOL didValidate = [address validateAddress1: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidUserAddress type: @"User Address"];
}


// test invalid city returns correct error
- (void) testInvaldCityReturnsTheCorrectError {
    NSError * error = nil;
    NSString * invalidValue = @"";
    BOOL didValidate = [address validateCity: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidUserCity type: @"User city"];
}


// test invalid state returns correct error
- (void) testInvaldStateReturnsTheCorrectError {
    NSError * error = nil;
    NSString * invalidValue = @"";
    BOOL didValidate = [address validateState: &invalidValue error: &error];

    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidUserState type: @"User state"];
}


// test invalid country returns correct error
- (void) testInvaldCountryReturnsTheCorrectError {
    NSError * error = nil;
    NSString * invalidValue = @"";
    
    BOOL didValidate = [address validateCountry: &invalidValue error: &error];
    
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidUserCountry type: @"User country"];
}


// test invalid zip returns correct error
- (void) testInvaldZipReturnsTheCorrectError {
    NSError * error = nil;
    
    NSString * invalidValue = @"";
    BOOL didValidate = [address validateZip: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidUserZip type: @"User zip"];
}

// test invalid region returns correct error
- (void) testInvaldRegionReturnsTheCorrectError {
    NSError * error = nil;
    NSString * invalidValue = @"";
    BOOL didValidate = [address validateRegion: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidUserRegion type: @"User region"];
}


// test invalid postal code returns correct error
- (void) testInvaldPostCodeReturnsTheCorrectError {
    NSError * error = nil;
    NSString * invalidValue = @"";
    BOOL didValidate = [address validatePostCode: &invalidValue error: &error];
    
    [self checkValidateFunctionResponse: didValidate error: error code: WPErrorInvalidUserPostCode type: @"User post code"];
}

// test that it properly converts to dictionary
- (void) testDictionary {
    NSDictionary * dictionary = [address dictionary];
    
    STAssertEqualObjects([dictionary objectForKey: @"address1"], testAddress1, @"Address1 = %@, should equal %@", [dictionary objectForKey: @"address1"], testAddress1);
    STAssertEqualObjects([dictionary objectForKey: @"city"], testCity, @"City = %@, should equal %@", [dictionary objectForKey: @"city"], testCity);
    STAssertEqualObjects([dictionary objectForKey: @"state"], testState, @"State = %@, should equal %@", [dictionary objectForKey: @"state"], testState);
    STAssertEqualObjects([dictionary objectForKey: @"zip"], testZipcode, @"Zipcode = %@, should equal %@", [dictionary objectForKey: @"zipcode"], testZipcode);
    STAssertEqualObjects([dictionary objectForKey: @"country"], testCountry, @"Country = %@, should equal %@", [dictionary objectForKey: @"country"], testCountry);
}


@end
