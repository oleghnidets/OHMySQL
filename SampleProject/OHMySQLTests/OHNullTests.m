//  Created by Oleg Hnidets on 2/5/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

@import XCTest;
#import "XCTestCase+Database_Basic.h"
#import "XCTestCase+INSERT.h"


static NSString * const kTestNullTable = @"TestNull";

@interface OHNullTests : XCTestCase

@end

@implementation OHNullTests

- (void)setUp {
    [super setUp];
    [OHNullTests configureDatabase];
    
    [self createTableWithQuery:@"CREATE TABLE TestNull (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `name` VARCHAR(255) NULL, `age` INT NULL);"];
}

- (void)tearDown {
    [OHMySQLContainer.shared.storeCoordinator disconnect];
    [super tearDown];
}

- (void)testCreateNullRecord {
    // given
    OHTestPerson *response = [self createPersonWithSet:@{ } in:kTestNullTable];
    
    // then
    XCTAssert(response.ID != nil);
    XCTAssert([response.ID isKindOfClass:[NSNumber class]]);
    
    XCTAssert(response.name != nil);
    XCTAssert(response.name == [NSNull null]);
    
    XCTAssert(response.age != nil);
    XCTAssert(response.age == [NSNull null]);
}

- (void)testCreateWithNullAndNotNullRecord {
    // given
    NSDictionary *insertSet = @{ @"name": [NSNull null], @"age": @22 };
    OHTestPerson *response = [self createPersonWithSet:insertSet in:kTestNullTable];
    // then
    XCTAssert(response.ID != nil);
    XCTAssert([response.ID isKindOfClass:[NSNumber class]]);
    
    XCTAssert(response.name != nil);
    XCTAssert([response.name isEqual:[NSNull null].description]);
    
    XCTAssert(response.age != nil);
    XCTAssert([response.age isEqualToNumber:insertSet[@"age"]]);
}

- (void)testCreateRecord {
    // given
    NSDictionary *insertSet = @{ @"name": @"Oleg", @"age": @22 };
    OHTestPerson *response = [self createPersonWithSet:insertSet in:kTestNullTable];
    // then
    XCTAssert(response.ID != nil);
    XCTAssert([response.ID isKindOfClass:[NSNumber class]]);
    
    XCTAssert(response.name != nil);
    XCTAssert([response.name isEqualToString:insertSet[@"name"]]);
    
    XCTAssert(response.age != nil);
    XCTAssert([response.age isEqualToNumber:insertSet[@"age"]]);
}

- (void)testCreateIncorrectRecord {
    // given
    NSDictionary *insertSet = @{ @"name": @22, @"age": @"Oleg" };
    OHTestPerson *response = [self createPersonWithSet:insertSet in:kTestNullTable];
    // then
    XCTAssert(response.ID == nil);
    XCTAssert(response.name == nil);
    XCTAssert(response.age == nil);
}

@end
