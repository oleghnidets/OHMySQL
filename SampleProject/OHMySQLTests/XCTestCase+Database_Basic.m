//  Created by Oleg on 8/15/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import "XCTestCase+Database_Basic.h"

NSString *const kDatabaseName    = @"mysql";
NSString *const kTableName       = @"TestTable";
NSString *const kDropTableString = @"DROP TABLE `TestTable`";

static NSString *const kCreateTableString = @"CREATE TABLE `TestTable` ( `id` mediumint(8) unsigned NOT NULL auto_increment, `name` varchar(255) default NULL, `surname` varchar(255) default NULL, `age` mediumint default NULL, PRIMARY KEY (`id`) ) AUTO_INCREMENT=1; INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Bradley','Oneill',90),('Levi','Moses',25),('Orlando','Cummings',9),('Hasad','Maldonado',5),('Carlos','Lowery',57),('Axel','Doyle',74),('Hasad','Booth',60),('Hall','Walters',84),('Dustin','Velazquez',84),('Randall','Riggs',91); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Harper','Knowles',67),('Jasper','Massey',95),('Hop','Casey',2),('Timon','Bright',25),('Lionel','Mcintyre',74),('Denton','Kennedy',35),('Ethan','Jarvis',43),('Hasad','Stevens',56),('Benedict','Dudley',29),('Shad','Pace',94); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Asher','Williamson',70),('Sylvester','Baldwin',37),('Lucas','Bush',62),('Nissim','Harvey',43),('Anthony','Adkins',4),('Norman','Snow',26),('Coby','Oneill',82);";

static NSString *const kEmptyTableString = @"CREATE TABLE `TestTable` ( `id` mediumint(8) unsigned NOT NULL auto_increment, `name` varchar(255) default NULL, `surname` varchar(255) default NULL, `age` mediumint default NULL, PRIMARY KEY (`id`) ) AUTO_INCREMENT=1; INSERT INTO `TestTable` (`name`,`surname`,`age`);";

@implementation XCTestCase (Database_Basic)

- (OHMySQLQueryContext *)mainQueryContext {
    return [OHMySQLManager sharedManager].mainQueryContext;
}

- (void)setMainQueryContext:(OHMySQLQueryContext *)mainQueryContext {
    NSAssert(NO, @"You must not set this property");
}

- (OHMySQLStoreCoordinator *)storeCoordinator {
    return [OHMySQLManager sharedManager].storeCoordinator;
}

- (void)setStoreCoordinator:(OHMySQLStoreCoordinator *)storeCoordinator {
    NSAssert(NO, @"You must not set this property");
}

+ (void)configureDatabase {
    OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root"
                                                     password:@"root"
                                                   serverName:@"localhost"
                                                       dbName:kDatabaseName
                                                         port:3306
                                                       socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
    OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
    [coordinator connect];
    
    OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
    queryContext.storeCoordinator = coordinator;
    
    [OHMySQLManager sharedManager].mainQueryContext = queryContext;
}

- (void)createTable {
    [self createTableWithQuery:kCreateTableString];
}

- (void)createTableWithQuery:(NSString *)query {
    // given
    OHMySQLQueryRequest *dropQueryRequest =[[OHMySQLQueryRequest alloc] initWithQueryString:kDropTableString];
    [self.mainQueryContext executeQueryRequest:dropQueryRequest error:nil];
    
    // when
    OHMySQLQueryRequest *queryRequest = [[OHMySQLQueryRequest alloc] initWithQueryString:query];
    NSError *error;
    BOOL success = [self.mainQueryContext executeQueryRequest:queryRequest error:&error];
    
    // then
    XCTAssert(success && !error);
}

- (void)createEmptyTable {
    [self createTableWithQuery:kEmptyTableString];
}

@end
