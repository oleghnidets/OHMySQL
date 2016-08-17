//  Created by Oleg on 9/20/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTestCase+Database_Basic.h"

@interface OHMySQLTests : XCTestCase

@end

#define AssertIfError() XCTAssert(error == nil)
#define AssertIfNoError() XCTAssert(error != nil)

@implementation OHMySQLTests

#pragma mark - setup

- (void)setUp {
    [super setUp];
    [OHMySQLTests configureDatabase];
}

- (void)tearDown {
    [self.storeCoordinator disconnect];
    [super tearDown];
}

#pragma mark - Testing

- (void)test00SelectDatabase {
    // when
    OHResultErrorType result = [self.storeCoordinator selectDataBase:kDatabaseName];
    
    // then
    XCTAssert(result == OHResultErrorTypeNone);
}

- (void)test01CreateTable {
    [self createTable];
}

- (void)test02SelectAllQuery {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName condition:nil];
    
    // when
    NSError *error;
    NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    // then
    AssertIfError();
    
    // when
    NSInteger countOfObjects = response.count;
    
    // then
    XCTAssert(countOfObjects > 0);
    
    // when
    id firstResponseObject = response.firstObject;
    
    // then
    XCTAssert([firstResponseObject isKindOfClass:[NSDictionary class]]);
}

- (void)test03SelectAllQueryWithCondition {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName condition:@"name='Dustin'"];
    
    // when
    NSError *error;
    NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    // then
    AssertIfError();
    
    // when
    NSInteger countOfObjects = response.count;
    
    // then
    XCTAssert(countOfObjects == 1);
    
    // when
    id firstResponseObject = response.firstObject;
    
    // then
    XCTAssert([firstResponseObject isKindOfClass:[NSDictionary class]]);
}

- (void)test04SelectAllQueryWithOrder {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName condition:nil orderBy:@[@"id"] ascending:YES];
    
    // when
    NSError *error;
    NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    // then
    AssertIfError();
    
    // when
    id firstResponseObject = response.firstObject;
    
    // then
    XCTAssert([firstResponseObject isKindOfClass:[NSDictionary class]]);
    
    // when
    NSNumber *objectID = firstResponseObject[@"id"];
    
    // then
    XCTAssertEqualObjects(objectID, @1);
    
    // when
    NSNumber *secondObjectID = response[1][@"id"];
    
    // then
    XCTAssertEqualObjects(secondObjectID, @2);
}

- (void)test05SelectAllQueryWithConditionAndOrder {
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
    
    // then
    AssertIfError();
    
    // when
    id firstResponseObject = response.firstObject;
    
    // then
    XCTAssert([firstResponseObject isKindOfClass:[NSDictionary class]] && !error);
    
    // when
    NSNumber *objectID = firstResponseObject[@"id"];
    
    // then
    XCTAssertEqualObjects(objectID, lastObjectIDLimit);
    
    // when
    NSNumber *lastObjectID = response.lastObject[@"id"];
    
    // then
    XCTAssertEqualObjects(lastObjectID, firstObjectIDLimit);
}

- (void)test06SelectFirst {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:kTableName condition:nil];
    
    // when
    NSError *error;
    NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    // then
    AssertIfError();
    XCTAssert([response isKindOfClass:[NSDictionary class]]);
    
    // when
    NSNumber *firstObjectID = response[@"id"];
    
    // then
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
    
    // then
    AssertIfError();
    XCTAssert([response isKindOfClass:[NSDictionary class]]);
    
    // when
    NSNumber *firstObjectID = response[@"id"];
    NSNumber *nextObjectID = @(conditionID.integerValue+1);
    
    // then
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
    NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    // then
    AssertIfError();
    XCTAssert([response isKindOfClass:[NSDictionary class]]);
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
    NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    // then
    AssertIfError();
    XCTAssert([response isKindOfClass:[NSDictionary class]]);
}

- (void)test10InsertNewRow {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory INSERT:kTableName
                                                                       set:@{ @"name" : @"Oleg", @"surname" : @"Hnidets", @"age" : @"21" }];
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success);
    AssertIfError();
    
    // when
    NSInteger lastInsertedID = [self.mainQueryContext lastInsertID].integerValue;
    
    // then
    XCTAssert(lastInsertedID > 0);
}

- (void)test11UpdateAll {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory UPDATE:kTableName set:@{ @"name" : @"Oleg", @"surname" : @"Hnidets", @"age" : @"21" } condition:nil];
    
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success);
    AssertIfError();
}

- (void)test12AffectedRows {
    // when
    NSInteger numberOfRows = [self.mainQueryContext affectedRows].integerValue;
    XCTAssert(numberOfRows != -1);
}

- (void)test13CountRecords {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory countAll:kTableName];
    
    // when
    NSError *error;
    NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    // then
    XCTAssert([response.allValues.firstObject integerValue] > 0 && !error);
}

- (void)test14UpdateAllWithCondition {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory UPDATE:kTableName set:@{ @"age" : @"22" } condition:@"name='Oleg'"];
    
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success);
    AssertIfError();
}

- (void)test15DeleAllWithCondition {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory DELETE:kTableName condition:@"name='Oleg'"];
    
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success);
    AssertIfError();
}

- (void)test16Refresh {
    // when
    OHResultErrorType result = [self.storeCoordinator refresh:OHRefreshOptionTables];
    
    // then
    XCTAssert(result == OHResultErrorTypeNone);
}

- (void)test17DeleteAllRecords {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory DELETE:kTableName condition:nil];
    
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success);
    AssertIfError();
}

- (void)test18DropTable {
    // given
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:kDropTableString];
    
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success);
    AssertIfError();
    
    // when
    CFAbsoluteTime totalTime = queryRequest.timeline.totalTime;
    
    // then
    XCTAssert(totalTime > 0);
}

- (void)test19IncorrectPlainQuery {
    // given
    NSString *incorrectQueryString = [kDropTableString stringByReplacingOccurrencesOfString:@"TABLE" withString:@"TABL"];
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:incorrectQueryString];
    
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success == NO);
    AssertIfNoError();
}

- (void)test20IncorrectSelectQuery {
    // given
    NSString *incorrectQueryString = @"SELECT qwe FROM 'something'";
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:incorrectQueryString];
    
    // when
    NSError *error;
    NSArray *response = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    // then
    XCTAssert(response == nil);
    AssertIfNoError();
}

- (void)test21StoreInformation {
    // given
    OHMySQLStore *store = self.storeCoordinator.store;
    
    // then
    XCTAssert(store.serverInfo && store.hostInfo && store.protocolInfo && store.serverVersion && store.status);
}

- (void)test22NotConnected {
    // given
    [self.storeCoordinator disconnect];
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:kDropTableString];
    
    // when
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    AssertIfNoError();
    XCTAssert(success == NO);
}

- (void)test23CheckConnection {
    // given
    [self.storeCoordinator disconnect];
    
    // when
    BOOL isConnected = self.storeCoordinator.isConnected;
    
    // then
    XCTAssert(isConnected == NO);
}

- (void)DISABLED_test24ShutdownDatabase {
    // when
    OHResultErrorType result = [self.storeCoordinator shutdown];
    
    // then
    XCTAssert(result == OHResultErrorTypeNone);
}

@end
