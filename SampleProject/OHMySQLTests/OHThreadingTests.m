//  Created by Oleg Hnidets on 8/18/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

@import XCTest;
#import "OHTestPerson.h"
#import "XCTestCase+Database_Basic.h"

@interface OHThreadingTests : XCTestCase

@end

#define createChildQueryContext() OHMySQLQueryContext *childQueryContext = [[OHMySQLQueryContext alloc] initWithParentQueryContext:self.mainQueryContext]
#define createExpectation() XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)]

#define waitExpectactions() [self waitForExpectationsWithTimeout:20.0 handler:^(NSError * _Nullable error) { \
        AssertIfError(); \
}]

static NSInteger const kIterations = 1000;

@implementation OHThreadingTests

- (void)setUp {
    [super setUp];
    [OHThreadingTests configureDatabase];
}

- (void)tearDown {
    [[OHMySQLContainer sharedContainer].storeCoordinator disconnect];
    [super tearDown];
}

#pragma mark - Testing

- (void)test01CreateTable {
    [self createEmptyTable];
}

- (void)test02InsertObject {
    // given
    OHTestPerson *person = [OHTestPerson mockObject];
    
    createExpectation();
    createChildQueryContext();
    [childQueryContext insertObject:person];
    
    // when
    [childQueryContext saveToPersistantStore:^(NSError * _Nullable error) {
        // then
        AssertIfError();
        [expectation fulfill];
    }];
    
    waitExpectactions();
}

- (void)test03UpdateObject {
    // given
    OHTestPerson *person = [OHTestPerson mockObject];
    person.ID = self.mainQueryContext.lastInsertID;
    person.name = person.ID.stringValue;
    
    createExpectation();
    createChildQueryContext();
    [childQueryContext updateObject:person];
    
    // when
    [childQueryContext saveToPersistantStore:^(NSError * _Nullable error) {
        // then
        AssertIfError();
        XCTAssertEqualObjects(person.name, person.ID.stringValue);
        [expectation fulfill];
    }];
    
    waitExpectactions();
}

- (void)test04CountAfterUpdate {
    // when
    NSNumber *countOfObjects = [self countOfObjects];
    // then
    XCTAssertEqualObjects(countOfObjects, @1);
}

- (void)DISABLED_test05DeleteObject {
    // given
    createExpectation();
    createChildQueryContext();
//    [childQueryContext deleteObject:self.person];
    
    // when
    [childQueryContext saveToPersistantStore:^(NSError * _Nullable error) {
        // then
        AssertIfError();
        [expectation fulfill];
    }];
    
    waitExpectactions();
}

- (void)DISABLED_test06CountAfterDelete {
    // when
    NSNumber *countOfObjects = [self countOfObjects];
    // then
    XCTAssertEqualObjects(countOfObjects, @0);
}

- (void)test07InsertionOfManyObjects {
    {
        // given
        createExpectation();
        createChildQueryContext();
        [childQueryContext performBlock:^{
            for (NSInteger i=0; i<kIterations; ++i) {
                OHTestPerson *person = [OHTestPerson mockObject];
                [childQueryContext insertObject:person];
            }
            
            // when
            [childQueryContext saveToPersistantStore:^(NSError * _Nullable error) {
                // then
                dispatch_async(dispatch_get_main_queue(), ^{
                    AssertIfError();
                    [expectation fulfill];
                });
            }];
        }];
        
        waitExpectactions();
    }
    
    {
        // given
        createExpectation();
        createChildQueryContext();
        [childQueryContext performBlock:^{
            for (NSInteger i=0; i<kIterations; ++i) {
                OHTestPerson *person = [OHTestPerson mockObject];
                [childQueryContext insertObject:person];
            }
            
            // when
            [childQueryContext saveToPersistantStore:^(NSError * _Nullable error) {
                // then
                AssertIfError();
                [expectation fulfill];
            }];
        }];
        
        waitExpectactions();
    }
}

- (void)DISABLED_test08CountAfterBigInsert {
    // when
    NSNumber *countOfObjects = [self countOfObjects];
    // then
    XCTAssert(countOfObjects.integerValue >= 2*kIterations);
}

@end
