//  Created by Oleg Hnidets on 8/15/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OHMySQL.h"

extern NSString * const kDatabaseName;
extern NSString * const kTableName;
extern NSString * const kDropTableString;
extern NSString * const kCreateTestTableQuery;

#define AssertIfError() XCTAssert(error == nil)
#define AssertIfNoError() XCTAssert(error != nil)
#define AssertIfNotDictionary(obj) XCTAssert([obj isKindOfClass:[NSDictionary class]])

@interface XCTestCase (Database_Basic)

@property (nonatomic, strong, readonly) OHMySQLQueryContext *mainQueryContext;
@property (nonatomic, strong, readonly) OHMySQLStoreCoordinator *storeCoordinator;

+ (void)configureDatabase;

- (void)createTable;
- (void)createTableWithQuery:(NSString *)query;
- (void)createEmptyTable;
- (void)dropTableNamed:(NSString *)tableName;

- (NSNumber *)countOfObjects;

@end
