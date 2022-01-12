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

- (void)testUpdateObject {
    [self testInsertObject];
    
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

- (void)testInsertionOfManyObjects {
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
@end
