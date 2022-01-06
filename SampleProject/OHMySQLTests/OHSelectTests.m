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

@interface OHSelectTests : XCTestCase

@end

@implementation OHSelectTests

- (void)setUp {
	[super setUp];
	[OHSelectTests configureDatabase];
    
    [self createTable];
}

- (void)tearDown {
	[self.storeCoordinator disconnect];
	[super tearDown];
}

#pragma mark - Testing

- (void)testSelectAll {
	// given
	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName condition:nil];

	// when
	NSError *error;
	NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
	NSInteger countOfObjects = response.count;
	id firstResponseObject = response.firstObject;

	// then
	AssertIfError();
	XCTAssert(countOfObjects > 0);
	AssertIfNotDictionary(firstResponseObject);
}

- (void)testSelectAllWithCondition {
	// given
	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName condition:@"name='Dustin'"];

	// when
	NSError *error;
	NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
	NSInteger countOfObjects = response.count;
	id firstResponseObject = response.firstObject;

	// then
	AssertIfError();
	XCTAssert(countOfObjects == 1);
	AssertIfNotDictionary(firstResponseObject);
}

- (void)testSelectAllWithOrderAsc {
	// given
	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName
																 condition:nil
																   orderBy:@[@"id"]
																 ascending:YES];

	// when
	NSError *error;
	NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
	id firstResponseObject = response.firstObject;
	NSNumber *objectID = firstResponseObject[@"id"];
	NSNumber *secondObjectID = response[1][@"id"];

	// then
	AssertIfError();
	AssertIfNotDictionary(firstResponseObject);
	XCTAssertEqualObjects(objectID, @1);
	XCTAssertEqualObjects(secondObjectID, @2);
}

- (void)testSelectAllWithConditionAndOrderDesc {
	// given
	NSNumber *firstObjectIDLimit = @3;
	NSNumber *lastObjectIDLimit  = @20;
	NSString *condition = [NSString stringWithFormat:@"id>=%@ AND id<=%@", firstObjectIDLimit.stringValue, lastObjectIDLimit.stringValue];

	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName
																 condition:condition
																   orderBy:@[@"id"]
																 ascending:NO];

	// when
	NSError *error;
	NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
	id firstResponseObject = response.firstObject;
	NSNumber *objectID = firstResponseObject[@"id"];
	NSNumber *lastObjectID = response.lastObject[@"id"];

	// then
	AssertIfError();
	AssertIfNotDictionary(firstResponseObject);
	XCTAssertEqualObjects(objectID, lastObjectIDLimit);
	XCTAssertEqualObjects(lastObjectID, firstObjectIDLimit);
}

- (void)testSelectFirst {
	// given
	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:kTableName condition:nil];

	// when
	NSError *error;
	NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest
																				error:&error].firstObject;
	NSNumber *firstObjectID = response[@"id"];

	// then
	AssertIfError();
	AssertIfNotDictionary(response);
	XCTAssertEqualObjects(firstObjectID, @1);
}

- (void)testSelectFirstWithCondition {
	// given
	NSNumber *conditionID = @5;
	NSString *condition = [NSString stringWithFormat:@"id>%@", conditionID.stringValue];
	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:kTableName condition:condition];

	// when
	NSError *error;
	NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
	NSNumber *firstObjectID = response[@"id"];
	NSNumber *nextObjectID = @(conditionID.integerValue+1);

	// then
	AssertIfError();
	AssertIfNotDictionary(response);
	XCTAssertEqualObjects(firstObjectID, nextObjectID);
}

// TODO: improve
- (void)testSelectFirstWithConditionOrderedAsc {
	// given
	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:kTableName
																	  condition:@"id>1"
																		orderBy:@[@"name"]
																	  ascending:YES];

	// when
	NSError *error;
	NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest
																				error:&error].firstObject;

	// then
	AssertIfError();
	AssertIfNotDictionary(response);
}

// TODO: improve
- (void)testSelectFirstWithConditionOrderedDesc {
	// given
	OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:kTableName
																	  condition:@"id>1"
																		orderBy:@[@"name"]
																	  ascending:NO];
	// when
	NSError *error;
	NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest
																				error:&error].firstObject;

	// then
	AssertIfError();
	AssertIfNotDictionary(response);
}

@end
