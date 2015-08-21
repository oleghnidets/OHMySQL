//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQL.h"
#import "NSString+Helper.h"

#import <mysql-connector-c/mysql.h>

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
        NSLog(@"Failed to connect to database: Error: %s", mysql_error(&local));
    } else {
        _mysql = &local;
    }
}

- (void)dealloc {
    [self disconnect];
}

#pragma mark - Abstract queries

- (NSArray *)selectAll:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString selectAllStringFor:tableName condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query];
}

- (OHQueryResultErrorType)updateAll:(NSString *)tableName set:(NSDictionary *)set condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString updateStringFor:tableName set:set condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

- (OHQueryResultErrorType)deleteAllFrom:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString deleteFrom:tableName condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

- (OHQueryResultErrorType)insertInto:(NSString *)tableName set:(NSDictionary *)set {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString insertIntoFor:tableName set:set];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

#pragma mark - Based on OHMySQLQuery

- (NSArray *)executeSELECTQuery:(OHMySQLQuery *)sqlQuery {
    NSInteger error = 0;
    if ((error = [self executeQuery:sqlQuery])) {
        NSLog(@"%s Error: %li", __PRETTY_FUNCTION__, error);
        
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
            NSString *value = [NSString stringWithUTF8String:row[i]];
            
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
        NSLog(@"%s Error: %li", __PRETTY_FUNCTION__, error);
    }
}

- (void)executeUPDATEQuery:(OHMySQLQuery *)sqlQuery {
    NSInteger error = OHQueryResultErrorTypeNone;
    if ((error = [self executeQuery:sqlQuery])) {
        NSLog(@"%s Error: %li", __PRETTY_FUNCTION__, error);
    }
}

- (OHQueryResultErrorType)executeQuery:(OHMySQLQuery *)sqlQuery {
    if (!sqlQuery.queryString || !sqlQuery.user) {
        NSLog(@"Unexpected prolem with the query.");
        
        return OHQueryResultErrorTypeUnknown; // CR_UNKNOWN_ERROR
    } else if (![OHMySQLManager sharedManager].isConnected) {
        [[OHMySQLManager sharedManager] connectWithUser:sqlQuery.user];
    }
    
    if (!_mysql) {
        NSLog(@"Cannot connect to DB. Check your configuration properties.");
        
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
