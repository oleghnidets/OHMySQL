//  Created by Oleg on 9/20/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OHMySQL.h"

@interface OHMySQLTests : XCTestCase

@property (nonatomic, copy) NSString *createTableString;
@property (nonatomic, copy) NSString *dropTableString;
@property (nonatomic, copy) NSString *query;

@end

@implementation OHMySQLTests

- (NSString *)createTableString {
    if (!_createTableString) {
        _createTableString = @"CREATE TABLE `TestTable` ( `id` mediumint(8) unsigned NOT NULL auto_increment, `name` varchar(255) default NULL, `surname` varchar(255) default NULL, `age` mediumint default NULL, PRIMARY KEY (`id`) ) AUTO_INCREMENT=1; INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Bradley','Oneill',90),('Levi','Moses',25),('Orlando','Cummings',9),('Hasad','Maldonado',5),('Carlos','Lowery',57),('Axel','Doyle',74),('Hasad','Booth',60),('Hall','Walters',84),('Dustin','Velazquez',84),('Randall','Riggs',91); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Harper','Knowles',67),('Jasper','Massey',95),('Hop','Casey',2),('Timon','Bright',25),('Lionel','Mcintyre',74),('Denton','Kennedy',35),('Ethan','Jarvis',43),('Hasad','Stevens',56),('Benedict','Dudley',29),('Shad','Pace',94); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Asher','Williamson',70),('Sylvester','Baldwin',37),('Lucas','Bush',62),('Nissim','Harvey',43),('Anthony','Adkins',4),('Norman','Snow',26),('Coby','Oneill',82);";
    }
    
    return _createTableString;
}

- (NSString *)dropTableString {
    return @"DROP TABLE `TestTable`";
}

#pragma mark - setup

- (void)setUp {
    [super setUp];
    
    // Check this configurations.
    OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root"
                                                     password:@"root"
                                                   serverName:@"localhost"
                                                       dbName:@"mysql"
                                                         port:3306
                                                       socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
    OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
    [coordinator connect];
    
    OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
    queryContext.storeCoordinator = coordinator;
    
    [OHMySQLManager sharedManager].mainQueryContext = queryContext;
}

- (void)tearDown {
    [[OHMySQLManager sharedManager].storeCoordinator disconnect];
    [super tearDown];
}

// Testing

- (void)test00SelectDatabae {
    OHResultErrorType result = [[OHMySQLManager sharedManager].storeCoordinator selectDataBase:@"mysql"];
    XCTAssert(result == OHResultErrorTypeNone);
}

- (void)test01CreateTable {
    OHMySQLQueryRequest *dropQueryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:self.dropTableString];
    [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:dropQueryRequest error:nil];
    
    OHMySQLQueryRequest *queryRequest = [[OHMySQLQueryRequest alloc] initWithQueryString:self.createTableString];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    XCTAssert(success && !error);
}

- (void)test02SelectAllQuery {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"TestTable" condition:nil];
    
    NSError *error;
    NSArray *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    XCTAssert(response.count && !error);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)test03SelectAllQueryWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"TestTable" condition:@"name='Dustin'"];
    
    NSError *error;
    NSArray *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    XCTAssert(response.count == 1 && !error);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)test04SelectAllQueryWithOrder {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"TestTable" condition:nil orderBy:@[@"id"] ascending:YES];
    
    NSError *error;
    NSArray *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]] && !error);
    XCTAssert([response.firstObject[@"id"] isEqualToNumber:@1]);
    XCTAssert([response[1][@"id"] isEqualToNumber:@2]);
}

- (void)test05SelectAllQueryWithConditionAndOrder {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"TestTable"
                                                                 condition:@"id>=3 AND id<=20"
                                                                   orderBy:@[@"id"]
                                                                 ascending:NO];
    
    NSError *error;
    NSArray *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]] && !error);
    XCTAssert([response.firstObject[@"id"] isEqualToNumber:@20]);
    XCTAssert([response.lastObject[@"id"] isEqualToNumber:@3]);
}

- (void)test06SelectFirst {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:@"TestTable"
                                                                      condition:nil];
    
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response isKindOfClass:[NSDictionary class]] && !error);
    XCTAssert([response[@"id"] isEqualToNumber:@1]);
}

- (void)test07SelectFirstWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:@"TestTable"
                                                                      condition:@"id>5"];
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response isKindOfClass:[NSDictionary class]] && !error);
    XCTAssert([response[@"id"] isEqualToNumber:@6]);
}

- (void)test08SelectFirstWithConditionOrderedAsc {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:@"TestTable"
                                                                      condition:@"id>1"
                                                                        orderBy:@[@"name"]
                                                                      ascending:YES];
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response isKindOfClass:[NSDictionary class]] && !error);
}

- (void)test09SelectFirstWithConditionOrderedDesc {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:@"TestTable"
                                                                      condition:@"id>1"
                                                                        orderBy:@[@"name"]
                                                                      ascending:NO];
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response isKindOfClass:[NSDictionary class]] && !error);
}

- (void)test10InsertSet {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory INSERT:@"TestTable"
                                                                       set:@{ @"name" : @"Oleg", @"surname" : @"Hnidets", @"age" : @"21" }];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    XCTAssert(success && !error);
}

- (void)test11UpdateAll {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory UPDATE:@"TestTable" set:@{ @"name" : @"Oleg", @"surname" : @"Hnidets", @"age" : @"21" } condition:nil];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    XCTAssert(success && !error);
}

- (void)test12AffectedRows {
    NSNumber *numberOfRows = [[OHMySQLManager sharedManager].mainQueryContext affectedRows];
    XCTAssert(numberOfRows.integerValue != -1);
}

- (void)test13CountRecords {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory countAll:@"TestTable"];
    
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response.allValues.firstObject integerValue] > 0 && !error);
}

- (void)test14UpdateAllWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory UPDATE:@"TestTable" set:@{ @"age" : @"22" } condition:@"name='Oleg'"];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(success && !error);
}

- (void)test15DeleAllWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory DELETE:@"TestTable" condition:@"name='Oleg'"];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(success && !error);
}

- (void)test16Refresh {
    OHResultErrorType result = [[OHMySQLManager sharedManager].storeCoordinator refresh:OHRefreshOptionTables];
    XCTAssert(result == OHResultErrorTypeNone);
}

- (void)test17DeleteAllRecords {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory DELETE:@"TestTable" condition:nil];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(success && !error);
}

- (void)test18DropTable {
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:self.dropTableString];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(success && !error && queryRequest.timeline.totalTime);
}

- (void)test19IncorrectPlainQuery {
    NSString *incorrectQueryString = [self.dropTableString stringByReplacingOccurrencesOfString:@"TABLE" withString:@"TABL"];
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:incorrectQueryString];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    XCTAssert(!success && error);
}

- (void)test20IncorrectSelectQuery {
    NSString *incorrectQueryString = @"SELECT qwe FROM 'something'";
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:incorrectQueryString];
    NSError *error;
    [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    XCTAssert(error);
}

- (void)test21StoreInformation {
    OHMySQLStore *store = [OHMySQLManager sharedManager].storeCoordinator.store;
    XCTAssert(store.serverInfo && store.hostInfo && store.protocolInfo && store.serverVersion && store.status);
}

- (void)test22NotConnected {
    [[OHMySQLManager sharedManager].storeCoordinator disconnect];
    
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:self.dropTableString];
    NSError *error;
    BOOL success = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    XCTAssert((success == NO) && error);
}

- (void)test23CheckConnection {
    [[OHMySQLManager sharedManager].storeCoordinator disconnect];
    BOOL isConnected = [OHMySQLManager sharedManager].storeCoordinator.isConnected;
    XCTAssert(!isConnected);
}

- (void)DISABLED_test24ShutdownDatabase {
    OHResultErrorType result = [[OHMySQLManager sharedManager].storeCoordinator shutdown];
    XCTAssert(result == OHResultErrorTypeNone);
}

@end
