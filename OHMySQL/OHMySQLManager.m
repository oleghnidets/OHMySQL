//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQL.h"
#import "NSString+Helper.h"
#import "OHMySQLSerialization.h"
#import <mysql.h>

@interface OHMySQLManager ()

@property (strong, readwrite) OHMySQLUser *user;

@end

static OHMySQLManager *sharedManager = nil;

@implementation OHMySQLManager {
    MYSQL *_mysql;
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[OHMySQLManager alloc] init];
    });
}

+ (OHMySQLManager *)sharedManager {
    return sharedManager;
}

- (void)connectWithUser:(OHMySQLUser *)user {
    NSParameterAssert(user);
    
    [self disconnect];
    
    self.user = user;
    static MYSQL local;
    
    mysql_library_init;
    
    mysql_init(&local);
    
    mysql_options(&local, MYSQL_OPT_COMPRESS, 0);
    my_bool reconnect = 1;
    mysql_options(&local, MYSQL_OPT_RECONNECT, &reconnect);
    
    if (self.user.sslConfig) {
        mysql_ssl_set(&local, self.user.sslConfig.key.UTF8String, self.user.sslConfig.certPath.UTF8String,
                      self.user.sslConfig.certAuthPath.UTF8String, self.user.sslConfig.certAuthPEMPath.UTF8String,
                      self.user.sslConfig.cipher.UTF8String);
    }
    
    if (!mysql_real_connect(&local, user.serverName.UTF8String, user.userName.UTF8String, user.password.UTF8String, user.dbName.UTF8String, (unsigned int)user.port, user.socket.UTF8String, 0)) {
        OHLogError(@"Failed to connect to database: Error: %s", mysql_error(&local));
    } else {
        _mysql = &local;
    }
    
    mysql_options(&local, MYSQL_OPT_RECONNECT, &reconnect);
    mysql_options(&local, MYSQL_OPT_COMPRESS, 0);
    
    OHLog(@"%s", mysql_get_server_info(&local));
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
- (NSDictionary *)selectFirst:(NSString *)tableName {
    return [self selectFirst:tableName condition:nil];
}

- (NSDictionary *)selectFirst:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString selectFirstString:tableName condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query].firstObject;
}

- (NSDictionary *)selectFirst:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnNames {
    return [self selectFirst:tableName condition:condition orderBy:columnNames ascending:YES];
}

- (NSDictionary *)selectFirst:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnNames ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString selectFirstString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query].firstObject;
}

#pragma mark SELECT JOIN
- (NSArray *)selectJOINType:(NSString *)joinType fromTable:(NSString *)tableName columnNames:(NSArray<NSString *> *)columnNames joinOn:(NSDictionary<NSString *,NSString *> *)joinOn {
    NSParameterAssert(tableName && joinOn.count && columnNames.count);
    
    NSString *queryString = [NSString join:joinType
                                 fromTable:tableName
                               columnNames:columnNames
                                 joinInner:joinOn];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeSELECTQuery:query];
}

#pragma mark INSERT
- (OHResultErrorType)insertInto:(NSString *)tableName set:(NSDictionary *)set {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString insertString:tableName set:set];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

#pragma mark UPDATE
- (OHResultErrorType)updateAll:(NSString *)tableName set:(NSDictionary *)set {
    return [self updateAll:tableName set:set condition:nil];
}


- (OHResultErrorType)updateAll:(NSString *)tableName set:(NSDictionary *)set condition:(NSString *)condition {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString updateString:tableName set:set condition:condition];
    OHMySQLQuery *query = [[OHMySQLQuery alloc] initWithUser:self.user queryString:queryString];
    
    return [self executeQuery:query];
}

#pragma mark DELETE
- (OHResultErrorType)deleteAllFrom:(NSString *)tableName {
    return [self deleteAllFrom:tableName condition:nil];
}

- (OHResultErrorType)deleteAllFrom:(NSString *)tableName condition:(NSString *)condition {
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

- (NSNumber *)lastInsertID {
    @synchronized (self) {
        return _mysql != NULL ? @(mysql_insert_id(_mysql)) : @0;
    }
}

- (OHResultErrorType)selectDataBase:(NSString *)dbName {
    NSParameterAssert(dbName);
    @synchronized (self) {
        return mysql_select_db(_mysql, dbName.UTF8String);
    }
}

- (OHResultErrorType)refresh:(OHRefreshOptions)options {
    @synchronized (self) {
        return mysql_refresh(_mysql, options);
    }
}

#pragma mark - Executing

- (NSArray *)executeSELECTQuery:(OHMySQLQuery *)sqlQuery {
    OHResultErrorType error = OHResultErrorTypeNone;
    if ((error = [self executeQuery:sqlQuery])) {
        OHLogError(@"%li", error);
        
        return nil;
    }
    
    MYSQL_RES *_result  = mysql_store_result(_mysql);
    MYSQL_FIELD *fields = mysql_fetch_fields(_result);
    
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    
    MYSQL_ROW row;
    while ((row = mysql_fetch_row(_result))) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        for (CFIndex i=0; i<mysql_num_fields(_result); ++i) {
            NSString *key = [NSString stringWithUTF8String:fields[i].name];
            id value = [OHMySQLSerialization objectFromCString:row[i] field:&fields[i]];
            
            jsonDict[key] = value;
        }
        
        [arrayOfDictionaries addObject:jsonDict];
    }
    
    mysql_free_result(_result);
    
    return arrayOfDictionaries;
}

- (OHResultErrorType)executeQuery:(OHMySQLQuery *)sqlQuery {
    if (!sqlQuery.queryString || !sqlQuery.user) {
        OHLogError(@"Unexpected prolem with the query.");
        
        return OHResultErrorTypeUnknown; // CR_UNKNOWN_ERROR
    } else if (![OHMySQLManager sharedManager].isConnected) {
        OHLogError(@"Try to reconnect user");
        [[OHMySQLManager sharedManager] connectWithUser:sqlQuery.user];
    }
    
    if (!_mysql) {
        OHLogError(@"The connection is broken.");
        OHLogError(@"Cannot connect to DB. Check your configuration properties.");
        return OHResultErrorTypeUnknown;
    }
    
    mysql_set_server_option(_mysql, MYSQL_OPTION_MULTI_STATEMENTS_ON);
    
    NSInteger error = mysql_real_query(_mysql, sqlQuery.queryString.UTF8String, sqlQuery.queryString.length);
    if (error) { OHLogError(@"%s", mysql_error(_mysql)); }
    
    return error;
}

#pragma mark - Helpers

- (void)disconnect {
    @synchronized (self) {
        if (_mysql) {
            mysql_close(_mysql);
            _mysql = nil;
            mysql_library_end;
        }
    }
}

- (OHResultErrorType)pingMySQL {
    @synchronized (self) {
        return _mysql != NULL ? mysql_ping(_mysql) : OHResultErrorTypeUnknown;
    }
}

- (BOOL)isConnected {
    return (_mysql != NULL) && ![self pingMySQL];
}

@end
