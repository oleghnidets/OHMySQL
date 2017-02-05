//  Created by Oleg on 8/15/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import XCTest;
#import "OHTestPerson.h"
#import "XCTestCase+Database_Basic.h"

@interface OHObjectTests : XCTestCase

@end

@implementation OHObjectTests

- (void)setUp {
    [super setUp];
    [OHObjectTests configureDatabase];
}

- (void)tearDown {
    [[OHMySQLManager sharedManager].storeCoordinator disconnect];
    [super tearDown];
}

#pragma mark - Testing

- (void)test01CreateTable {
    [self createEmptyTable];
}

- (void)test02InsertObject {
    // given
    OHTestPerson *person = [OHTestPerson mockObject];
    [self.mainQueryContext insertObject:person];
    
    // when
    NSError *insertError;
    [self.mainQueryContext save:&insertError];
    
    // then
    XCTAssert(insertError == nil && person.ID);
}

- (void)test03CountObjects {
    // when
    NSNumber *countOfObjects = [self countOfObjects];
    
    // then
    XCTAssertEqualObjects(countOfObjects, @1);
}

- (void)test04UpdateObject {
    // given
    OHTestPerson *person = [OHTestPerson mockObject];
    person.ID = [self.mainQueryContext lastInsertID];
    person.name = @"Changed Name";
    [self.mainQueryContext updateObject:person];
    
    // when
    NSError *error;
    [self.mainQueryContext save:&error];
    
    // then
    XCTAssert(error == nil && person.ID);
}

- (void)test05GetObject {
    // when
    OHTestPerson *person = [self firstPerson];
    
    // then
    XCTAssert(person && person.ID && person.name && person.surname && person.age);
}

- (void)test06DeleteObject {
    // given
    OHTestPerson *person = [self firstPerson];
    
    // when
    [self.mainQueryContext deleteObject:person];
    NSError *error;
    [self.mainQueryContext save:&error];
    
    // then
    AssertIfError();
    
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName condition:[NSString stringWithFormat:@"id='%@'", person.ID]];

    // when
    NSArray *searchedPersons = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    // then
    AssertIfError();
    XCTAssert(!searchedPersons.count);
}

- (void)test07DeleteUndefinedObject {
    // given
    OHTestPerson *person = [OHTestPerson mockObject];
    person.ID = @1234567890;
    
    // when
    [self.mainQueryContext deleteObject:person];
    NSError *error;
    [self.mainQueryContext save:&error];
    
    // then
    AssertIfError();
}

- (void)test08AffectedProperties {
    // when
    NSNumber *affectedRowsBefore = self.mainQueryContext.affectedRows;
    
    // then
    XCTAssertEqualObjects(affectedRowsBefore, @0);
    
    // given
    [self test02InsertObject];
    
    BOOL result;
    OHTestPerson *person = [self firstPerson];
    OHMySQLQueryContext *mainQueryContext = self.mainQueryContext;
    
    // when
    [mainQueryContext insertObject:person];
    // then
    XCTAssert(mainQueryContext.insertedObjects.count);
    
    // when
    NSError *insertError;
    result = [mainQueryContext save:&insertError];
    
    // then
    XCTAssert(!result && insertError);
    
    // when
    [mainQueryContext refreshObject:person];
    
    // then
    XCTAssert(!mainQueryContext.insertedObjects.count && !mainQueryContext.updatedObjects.count && !mainQueryContext.deletedObjects.count);
    
    // when
    NSError *deleteError;
    [mainQueryContext deleteObject:person];
    
    // then
    XCTAssert(mainQueryContext.deletedObjects.count);
    
    // when
    result = [mainQueryContext save:&deleteError];
    
    // then
    XCTAssert(result && !deleteError);
    
    // when
    NSNumber *affectedRowsAfterDelete = mainQueryContext.affectedRows;
    
    // then
    XCTAssertEqualObjects(affectedRowsAfterDelete, @1);
    
    // when
    NSError *updateError;
    [mainQueryContext updateObject:person];
    
    // then
    XCTAssert(mainQueryContext.updatedObjects.count);
    
    // when
    result = [mainQueryContext save:&updateError];
    
    // then
    XCTAssert(result && !updateError);
    
    // when
    NSNumber *affectedRowsAferUpdate = mainQueryContext.affectedRows;
    
    // then
    XCTAssertEqualObjects(affectedRowsAferUpdate, @0);
}

#pragma mark - Utility

- (NSArray<OHTestPerson *> *)allPersons {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:kTableName condition:nil];
    
    // when
    NSError *error;
    NSArray *personsDictionary = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    // then
    AssertIfError();
    
    NSMutableArray *persons = [NSMutableArray array];
    for (NSDictionary *personDict in personsDictionary) {
        OHTestPerson *person = [OHTestPerson new];
        [person mapFromResponse:personDict];
    }
    
    return persons;
}

- (OHTestPerson *)firstPerson {
    // given
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:kTableName condition:nil];
    
    // when
    NSError *error;
    NSDictionary *personDictionary = [self.mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    // then
    AssertIfError();
    
    OHTestPerson *person = [OHTestPerson new];
    if (personDictionary) {
        [person mapFromResponse:personDictionary];
    }
    
    return person;
}

@end
