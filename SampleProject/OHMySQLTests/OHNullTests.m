//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
