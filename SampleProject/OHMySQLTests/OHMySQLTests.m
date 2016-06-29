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

- (void)test1SimpleQueryExecute {
    OHMySQLQueryRequest *queryRequest = [[OHMySQLQueryRequest alloc] initWithQueryString:self.createTableString];
    
    NSError *error;
    XCTAssert([[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error] && !error);
}

- (void)test2SelectAllQuery {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"TestTable" condition:nil];
    
    NSError *error;
    NSArray *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    
    XCTAssert(response.count && !error);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)test3SelectAllQueryWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"TestTable" condition:@"name='Dustin'"];
    
    NSError *error;
    NSArray *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    XCTAssert(response.count == 1 && !error);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)test4SelectAllQueryWithOrder {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"TestTable" condition:nil orderBy:@[@"id"] ascending:YES];
    
    NSError *error;
    NSArray *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error];
    
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]] && !error);
    XCTAssert([response.firstObject[@"id"] isEqualToNumber:@1]);
    XCTAssert([response[1][@"id"] isEqualToNumber:@2]);
}

- (void)test5SelectAllQueryWithConditionAndOrder {
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

- (void)test6SelectFirst {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:@"TestTable"
                                                                      condition:nil];
    
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response isKindOfClass:[NSDictionary class]] && !error);
    XCTAssert([response[@"id"] isEqualToNumber:@1]);
}

- (void)test7SelectFirstWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:@"TestTable"
                                                                      condition:@"id>5"];
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response isKindOfClass:[NSDictionary class]] && !error);
    XCTAssert([response[@"id"] isEqualToNumber:@6]);
}

- (void)test8SelectFirstWithConditionOrderedAsc {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECTFirst:@"TestTable"
                                                                      condition:@"id>1"
                                                                        orderBy:@[@"name"]
                                                                      ascending:YES];
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response isKindOfClass:[NSDictionary class]] && !error);
}

- (void)test9SelectFirstWithConditionOrderedDesc {
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
    BOOL result = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    XCTAssert(result && !error);
}

- (void)test11UpdateAll {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory UPDATE:@"TestTable" set:@{ @"name" : @"Oleg", @"surname" : @"Hnidets", @"age" : @"21" } condition:nil];
    NSError *error;
    BOOL result = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(result && !error);
}

- (void)test12UpdateAllWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory UPDATE:@"TestTable" set:@{ @"age" : @"22" } condition:@"name='Oleg'"];
    NSError *error;
    BOOL result = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(result && !error);
}

- (void)test13DeleAllWithCondition {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory DELETE:@"TestTable" condition:@"name='Oleg'"];
    NSError *error;
    BOOL result = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(result && !error);
}

- (void)test14DeleteAllRecords {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory DELETE:@"TestTable" condition:nil];
    NSError *error;
    BOOL result = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(result && !error);
}

- (void)test15CountRecords {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory countAll:@"TestTable"];
    
    NSError *error;
    NSDictionary *response = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequestAndFetchResult:queryRequest error:&error].firstObject;
    
    XCTAssert([response.allValues.firstObject integerValue] == 0 && !error);
}

- (void)test16DropTable {
    OHMySQLQueryRequest *queryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:self.dropTableString];
    NSError *error;
    BOOL result = [[OHMySQLManager sharedManager].mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    XCTAssert(result && !error);
}

@end
