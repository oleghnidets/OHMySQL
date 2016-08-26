//  Created by Oleg on 8/15/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OHMySQL.h"

extern NSString *const kDatabaseName;
extern NSString *const kTableName;
extern NSString *const kDropTableString;

#define AssertIfError() XCTAssert(error == nil)
#define AssertIfNoError() XCTAssert(error != nil)
#define AssertIfNotDictionary(obj) XCTAssert([obj isKindOfClass:[NSDictionary class]])

@interface XCTestCase (Database_Basic)

@property (nonatomic, strong) OHMySQLQueryContext *mainQueryContext;
@property (nonatomic, strong) OHMySQLStoreCoordinator *storeCoordinator;

+ (void)configureDatabase;
- (void)createTable;
- (void)createEmptyTable;
- (NSNumber *)countOfObjects;

@end
