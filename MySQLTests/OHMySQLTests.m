//
//  OHMySQLTests.m
//  OHMySQL
//
//  Created by Oleg on 9/20/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OHMySQL.h"

@interface OHMySQLTests : XCTestCase

@end

@implementation OHMySQLTests {
    OHMySQLUser *_user;
    OHMySQLQuery *_query;
}

- (NSString *)createTableString {
    static NSString *kQueryString = @"CREATE TABLE `TestTable` ( `id` mediumint(8) unsigned NOT NULL auto_increment, `name` varchar(255) default NULL, `surname` varchar(255) default NULL, `age` mediumint default NULL, PRIMARY KEY (`id`) ) AUTO_INCREMENT=1; INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Bradley','Oneill',90),('Levi','Moses',25),('Orlando','Cummings',9),('Hasad','Maldonado',5),('Carlos','Lowery',57),('Axel','Doyle',74),('Hasad','Booth',60),('Hall','Walters',84),('Dustin','Velazquez',84),('Randall','Riggs',91); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Harper','Knowles',67),('Jasper','Massey',95),('Hop','Casey',2),('Timon','Bright',25),('Lionel','Mcintyre',74),('Denton','Kennedy',35),('Ethan','Jarvis',43),('Hasad','Stevens',56),('Benedict','Dudley',29),('Shad','Pace',94); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Asher','Williamson',70),('Sylvester','Baldwin',37),('Lucas','Bush',62),('Nissim','Harvey',43),('Anthony','Adkins',4),('Norman','Snow',26),('Coby','Oneill',82);";
    
    return kQueryString;
}

- (NSString *)dropTable {
    return @"DROP TABLE `TestTable`";
}
#pragma mark - setup

- (void)setUp {
    [super setUp];
    // Check this configurations.
    _user = [[OHMySQLUser alloc] initWithUserName:@"root"
                                         password:@"root"
                                       serverName:@"localhost"
                                           dbName:@"mysql"
                                             port:3306
                                           socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
    _query = [[OHMySQLQuery alloc] initWithUser:_user];
    [[OHMySQLManager sharedManager] connectWithUser:_user];
}

- (void)tearDown {
    [[OHMySQLManager sharedManager] disconnect];
    _user = nil;
    
    [super tearDown];
}

// Create
- (void)testA1 {
    _query.queryString = [self createTableString];
    XCTAssert([[OHMySQLManager sharedManager] executeQuery:_query] == 0);
}

- (void)testB1 {
    NSArray *response = [[OHMySQLManager sharedManager] selectAllFrom:@"TestTable"];
    
    XCTAssert(response.count);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)testB2 {
    NSArray *response = [[OHMySQLManager sharedManager] selectAll:@"TestTable" condition:@"name='Dustin'"];
    
    XCTAssert(response.count == 1);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)testB3 {
    NSArray *response = [[OHMySQLManager sharedManager] selectAll:@"TestTable" orderBy:@[@"id"]];
    
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
    XCTAssert([response.firstObject[@"id"] isEqualToString:@"1"]);
    XCTAssert([response[1][@"id"] isEqualToString:@"2"]);
}

- (void)testB4 {
    NSArray *response = [[OHMySQLManager sharedManager] selectAll:@"TestTable"
                                                        condition:@"id>=3 AND id<=20"
                                                          orderBy:@[@"id"]
                                                        ascending:NO];
    
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
    XCTAssert([response.firstObject[@"id"] isEqualToString:@"20"]);
    XCTAssert([response.lastObject[@"id"] isEqualToString:@"3"]);
}

- (void)testC1 {
    NSArray *response = [[OHMySQLManager sharedManager] selectFirst:@"TestTable"];

    XCTAssert(response.count == 1);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
    XCTAssert([response.firstObject[@"id"] isEqualToString:@"1"]);
}

- (void)testC2 {
    NSArray *response = [[OHMySQLManager sharedManager] selectFirst:@"TestTable" condition:@"id>5"];
    
    XCTAssert(response.count == 1);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
    XCTAssert([response.firstObject[@"id"] isEqualToString:@"6"]);
}

- (void)testC3 {
    NSArray *response = [[OHMySQLManager sharedManager] selectFirst:@"TestTable" condition:@"id>1" orderBy:@[@"name"]];
    
    XCTAssert(response.count == 1);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)testC4 {
    NSArray *response = [[OHMySQLManager sharedManager] selectFirst:@"TestTable" condition:@"id>1" orderBy:@[@"name"] ascending:NO];
    
    XCTAssert(response.count == 1);
    XCTAssert([response.firstObject isKindOfClass:[NSDictionary class]]);
}

- (void)testD1 {
    NSUInteger responseCode = [[OHMySQLManager sharedManager] insertInto:@"TestTable"
                                                                     set:@{ @"name" : @"Oleg", @"surname" : @"Hnidets", @"age" : @"21" }];
    
    XCTAssert(responseCode == 0);
}

- (void)testD2 {
    NSUInteger responseCode = [[OHMySQLManager sharedManager] updateAll:@"TestTable" set:@{ @"age" : @"21" }];
    
    XCTAssert(responseCode == 0);
}

- (void)testD3 {
    NSUInteger responseCode = [[OHMySQLManager sharedManager] updateAll:@"TestTable" set:@{ @"age" : @"22" } condition:@"name='Oleg'"];
    
    XCTAssert(responseCode == 0);
}

- (void)testE1 {
    NSUInteger responseCode = [[OHMySQLManager sharedManager] deleteAllFrom:@"TestTable" condition:@"name='Oleg'"];
    
    XCTAssert(responseCode == 0);
}

- (void)testE2 {
    NSUInteger responseCode = [[OHMySQLManager sharedManager] deleteAllFrom:@"TestTable"];
    
    XCTAssert(responseCode == 0);
}

- (void)testF1 {
    NSNumber *count = [[OHMySQLManager sharedManager] countAll:@"TestTable"];
    
    XCTAssert(count.integerValue == 0);
}

// Drop
- (void)testZ1 {
    _query.queryString = [self dropTable];
    XCTAssert([[OHMySQLManager sharedManager] executeQuery:_query] == 0);
}

@end
