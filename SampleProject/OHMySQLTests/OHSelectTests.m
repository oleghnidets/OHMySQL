//  Created by Oleg on 10/21/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

@import XCTest;
#import "XCTestCase+Database_Basic.h"

@interface OHSelectTests : XCTestCase

@end

@implementation OHSelectTests

+ (void)tearDown {

	[OHSelectTests configureDatabase];

	NSString *dropQueryString = [NSString stringWithFormat:@"DROP TABLE %@;", kTableName];
	OHMySQLQueryRequest *dropQueryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:dropQueryString];
	[OHMySQLContainer.sharedContainer.mainQueryContext executeQueryRequest:dropQueryRequest error:nil];

	[super tearDown];
}

- (void)setUp {
	[super setUp];
	[OHSelectTests configureDatabase];
}

- (void)tearDown {
	[self.storeCoordinator disconnect];
	[super tearDown];
}

#pragma mark - Testing

- (void)test00ACreateTable {
	[self createTable];
}

- (void)test01SelectAll {
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

- (void)test02SelectAllWithCondition {
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

- (void)test03SelectAllWithOrderAsc {
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

- (void)test04SelectAllWithConditionAndOrderDesc {
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

- (void)test05SelectFirst {
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

- (void)test07SelectFirstWithCondition {
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
- (void)test08SelectFirstWithConditionOrderedAsc {
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
- (void)test09SelectFirstWithConditionOrderedDesc {
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
