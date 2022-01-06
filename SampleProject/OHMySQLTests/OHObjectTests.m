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
#import "OHTestPerson.h"
#import "XCTestCase+Database_Basic.h"

@interface OHObjectTests : XCTestCase

@end

@implementation OHObjectTests

- (void)setUp {
    [super setUp];
    [OHObjectTests configureDatabase];
    
    [self createEmptyTable];
}

- (void)tearDown {
    [OHMySQLContainer.shared.storeCoordinator disconnect];
    [super tearDown];
}

#pragma mark - Testing

- (void)testInsertObject {
    // given
    OHTestPerson *person = [OHTestPerson mockObject];
    [self.mainQueryContext insertObject:person];
    
    // when
    NSError *insertError;
    [self.mainQueryContext save:&insertError];
    
    // then
    XCTAssert(insertError == nil && person.ID);
    
    // when
    NSNumber *countOfObjects = [self countOfObjects];
    OHTestPerson *firstPerson = [self firstPerson];
    
    // then
    XCTAssertEqualObjects(countOfObjects, @1);
    XCTAssert(firstPerson && firstPerson.ID && firstPerson.name && firstPerson.surname && firstPerson.age);
}

- (void)testUpdateObject {
    [self testInsertObject];
    
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

- (void)testDeleteObject {
    [self testInsertObject];
    
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

- (void)testDeleteUndefinedObject {
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

- (void)testAffectedProperties {
    // when
    NSNumber *affectedRowsBefore = self.mainQueryContext.affectedRows;
    
    // then
    XCTAssertEqualObjects(affectedRowsBefore, @0);
    
    // given
    [self testInsertObject];
    
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
