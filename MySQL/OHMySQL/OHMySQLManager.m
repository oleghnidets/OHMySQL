//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQL.h"
#import "NSString+Helper.h"

#import <mysql-connector-c/mysql.h>

extern NSString *_Nonnull const OHJoinInner;
extern NSString *_Nonnull const OHJoinRight;
extern NSString *_Nonnull const OHJoinLeft;
extern NSString *_Nonnull const OHJoinFull;

NSString *const OHJoinInner = @"INNER";
NSString *const OHJoinRight = @"RIGHT";
NSString *const OHJoinLeft  = @"LEFT";
NSString *const OHJoinFull  = @"FULL";

@interface OHMySQLManager ()

@property (nonatomic, assign, readwrite) NSUInteger countOfFields;
@property (nonatomic, strong, readwrite) OHMySQLUser *user;

@end

@implementation OHMySQLManager {
    MYSQL *_mysql;
    MYSQL_RES *_result;
}

+ (OHMySQLManager *)sharedManager {
    static OHMySQLManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[OHMySQLManager alloc] init];
    });
    
    return sharedManager;
}

- (void)connectWithUser:(OHMySQLUser *)user {
    NSParameterAssert(user);
    
    [self disconnect];
    
    self.user = user;
    static MYSQL local;
    
    mysql_init(&local);
    if (!mysql_real_connect(&local, user.serverName.UTF8String, user.userName.UTF8String, user.password.UTF8String, user.dbName.UTF8String, (unsigned int)user.port, user.socket.UTF8String, 0)) {
        OHLogError(@"Failed to connect to database: Error: %s", mysql_error(&local));
    } else {
        _mysql = &local;
    }
}

- (void)dealloc {
    [self disconnect];
}

#pragma mark - Abstract queries

#pragma mark SELECT
- (NSArray *)selectAllFrom:(NSString *)tableName {
    return [self selectAll:tableName condition:nil];
}

- (NSArray *)selectAll:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString selectAllString:tableName condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query];
}

- (NSArray *)selectAll:(NSString *)tableName orderBy:(NSArray *)columnNames {
    return [self selectAll:tableName condition:nil orderBy:columnNames ascending:YES];
}

- (NSArray *)selectAll:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnNames ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString selectAllString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query];
}

#pragma mark SELECT FIRST
- (NSArray *)selectFirst:(NSString *)tableName {
    return [self selectAll:tableName condition:nil];
}

- (NSArray *)selectFirst:(NSString *)tableName condition:(NSString *)condition {
    return [self selectAll:tableName condition:condition];
}

- (NSArray *)selectFirst:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnNames {
    return [self selectFirst:tableName condition:condition orderBy:columnNames ascending:YES];
}

- (NSArray *)selectFirst:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnNames ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString selectFirstString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query];
}

#pragma mark SELECT JOIN
- (NSArray *)selectJoinType:(NSString *)joinType
                       from:(NSString *)tableName1
                       join:(NSString *)tableName2
                columnNames:(NSArray *)columnNames
                onCondition:(NSString *)condition {
    NSParameterAssert(tableName1 && tableName2 && columnNames.count && condition);
    
    NSString *queryString = nil;
    if ([joinType isEqualToString:OHJoinInner]) {
        queryString = [NSString innerJoinString:tableName1 joinInner:tableName2 columnNames:columnNames onCondition:condition];
    } else if ([joinType isEqualToString:OHJoinRight]) {
        queryString = [NSString rightJoinString:tableName1 joinInner:tableName2 columnNames:columnNames onCondition:condition];
    } else if ([joinType isEqualToString:OHJoinLeft]) {
        queryString = [NSString leftJoinString:tableName1 joinInner:tableName2 columnNames:columnNames onCondition:condition];
    } else if ([joinType isEqualToString:OHJoinFull]) {
        queryString = [NSString fullJoinString:tableName1 joinInner:tableName2 columnNames:columnNames onCondition:condition];
    } else {
        NSAssert(queryString, @"You must specify correct join type");
    }
    
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query];
}

#pragma mark INSERT
- (OHQueryResultErrorType)insertInto:(NSString *)tableName set:(NSDictionary *)set {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString insertString:tableName set:set];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

#pragma mark UPDATE
- (OHQueryResultErrorType)updateAll:(NSString *)tableName set:(NSDictionary *)set {
    return [self updateAll:tableName set:set condition:nil];
}


- (OHQueryResultErrorType)updateAll:(NSString *)tableName set:(NSDictionary *)set condition:(NSString *)condition {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString updateString:tableName set:set condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

#pragma mark DELETE
- (OHQueryResultErrorType)deleteAllFrom:(NSString *)tableName {
    return [self deleteAllFrom:tableName condition:nil];
}

- (OHQueryResultErrorType)deleteAllFrom:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString deleteString:tableName condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

#pragma mark Other

- (NSNumber *)countAll:(NSString *)tableName {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString countString:tableName];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [[self executeSELECTQuery:query].firstObject allValues].firstObject;
}

#pragma mark - Based on OHMySQLQuery

- (NSArray *)executeSELECTQuery:(OHMySQLQuery *)sqlQuery {
    NSInteger error = 0;
    if ((error = [self executeQuery:sqlQuery])) {
        OHLogError(@"%li", error);
        
        return nil;
    }
    
    _result = mysql_store_result(_mysql);
    
    MYSQL_FIELD *fields = mysql_fetch_fields(_result);
    
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    
    MYSQL_ROW row;
    while ((row = mysql_fetch_row(_result))) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        for (NSUInteger i=0; i<self.countOfFields; ++i) {
            NSString *key = [NSString stringWithUTF8String:fields[i].name];
            NSString *value = [NSString stringWithUTF8String:row[i] ?: "null"];
            
            jsonDict[key] = value;
        }
        
        [arrayOfDictionaries addObject:jsonDict];
    }
    
    
    mysql_free_result(_result);
    
    return arrayOfDictionaries;
}

- (void)executeDELETEQuery:(OHMySQLQuery *)sqlQuery {
    NSInteger error = OHQueryResultErrorTypeNone;
    if ((error = [self executeQuery:sqlQuery])) {
        OHLogError(@"%li", error);
    }
}

- (void)executeUPDATEQuery:(OHMySQLQuery *)sqlQuery {
    NSInteger error = OHQueryResultErrorTypeNone;
    if ((error = [self executeQuery:sqlQuery])) {
        OHLogError(@"%li", error);
    }
}

- (OHQueryResultErrorType)executeQuery:(OHMySQLQuery *)sqlQuery {
    if (!sqlQuery.queryString || !sqlQuery.user) {
        OHLogError(@"Unexpected prolem with the query.");
        
        return OHQueryResultErrorTypeUnknown; // CR_UNKNOWN_ERROR
    } else if (![OHMySQLManager sharedManager].isConnected) {
        [[OHMySQLManager sharedManager] connectWithUser:sqlQuery.user];
    }
    
    if (!_mysql) {
        OHLogError(@"Cannot connect to DB. Check your configuration properties.");
        return OHQueryResultErrorTypeUnknown;
    }
    
    return mysql_real_query(_mysql, sqlQuery.queryString.UTF8String, sqlQuery.queryString.length);
}

#pragma mark - Helpers

- (NSUInteger)countOfFields {
    return mysql_num_fields(_result);
}

- (void)disconnect {
    if (_mysql) {
        mysql_close(_mysql);
        _mysql = nil;
    }
}

- (BOOL)isConnected {
    return (_mysql != NULL) && mysql_stat(_mysql);
}

@end
