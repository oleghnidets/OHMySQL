//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLQueryContext.h"
#import "OHMySQLStoreCoordinator.h"

#import "OHConstants.h"
#import "OHMySQLQuery.h"
#import "OHMySQLSerialization.h"

#import "OHMappingProtocol.h"
#import "OHMySQLQueryFactory.h"

#import "NSObject+Mapping.h"

#import <mysql.h>

static NSString *const kContextDomain = @"mysql.error.domain";

NSError *contextError(OHResultErrorType type, NSString *description) {
    return [NSError errorWithDomain:kContextDomain
                               code:OHResultErrorTypeUnknown
                           userInfo:@{ NSLocalizedDescriptionKey : description }];
}

@implementation OHMySQLQueryContext

- (MYSQL *)mysql {
    return self.storeCoordinator.mysql;
}

- (void)executeQuery:(OHMySQLQuery *)query error:(NSError *__autoreleasing *)error {
    if (!query.queryString) {
        OHLogError(@"Query cannot be empty");
        if (error) {
            *error = contextError(OHResultErrorTypeUnknown, NSLocalizedString(@"Required properties in query are absent.", nil));
        }
        return ;
    } else if (!self.storeCoordinator.isConnected) {
        OHLogError(@"No connection.");
        if (error) {
            *error = contextError(OHResultErrorTypeUnknown, NSLocalizedString(@"No connection.", nil));
        }
        return ;
    }
    
    if (self.storeCoordinator.pingMySQL != OHResultErrorTypeNone) {
        OHLogError(@"The connection is broken.");
        OHLogError(@"Cannot connect to DB. Check your configuration properties.");
        if (error) {
            *error = contextError(OHResultErrorTypeUnknown, NSLocalizedString(@"Cannot connect to DB. Check your configuration properties.", nil));
        }
        return ;
    }
    
    query.timeline.queryStartTime = CFAbsoluteTimeGetCurrent();
    
    MYSQL *_mysql = self.storeCoordinator.mysql;
    mysql_set_server_option(_mysql, MYSQL_OPTION_MULTI_STATEMENTS_ON);
    
    // To get proper length of string in different languages.
    NSInteger queryStringLength = strlen(query.queryString.UTF8String);
    NSInteger errorCode = mysql_real_query(_mysql, query.queryString.UTF8String, queryStringLength);
    
    query.timeline.queryDuration = query.timeline.queryStartTime - CFAbsoluteTimeGetCurrent();
    if (errorCode) {
        NSString *mysqlError = [NSString stringWithUTF8String:mysql_error(_mysql)];
        OHLogError(@"Cannot execute query: %@", mysqlError);
        if (error) {
            *error = contextError(OHResultErrorTypeUnknown, NSLocalizedString(mysqlError, nil));
        }
    }
}

- (NSArray<NSDictionary<NSString *,id> *> *)executeQueryAndFetchResult:(OHMySQLQuery *)query error:(NSError *__autoreleasing *)error {
    [self executeQuery:query error:error];
    if (error && *error) {
        OHLogError(@"Cannot get results: %@", *error);
        return nil;
    }
    
    return [self fetchResult];
}

- (NSNumber *)affectedRows {
    @synchronized (self) {
        my_ulonglong affectedRowsResult = mysql_affected_rows(self.mysql);
        if (affectedRowsResult == (my_ulonglong)-1) {
            return @(-1);
        } else {
            return @(affectedRowsResult);
        }
    }
}

- (NSNumber *)lastInsertID {
    @synchronized (self) {
        return self.mysql != NULL ? @(mysql_insert_id(self.mysql)) : @0;
    }
}

#pragma mark - Objects

- (BOOL)insertObject:(NSObject<OHMappingProtocol> *)object {
    OHMySQLQuery *query = [OHMySQLQueryFactory INSERT:[object mySQLTable] set:[object mapObject]];
    NSError *error;
    [self executeQuery:query error:&error];
    OHLogError(@"Object cannot be inserted: %@", error);
    
    return error == nil;
}

- (BOOL)updateObject:(NSObject<OHMappingProtocol> *)object {
    NSString *condition = [object indexKeyCondition];
    OHMySQLQuery *query = [OHMySQLQueryFactory UPDATE:[object mySQLTable]
                                                  set:[object mapObject]
                                            condition:condition];
    
    // If object doesn't have index key don't update anything.
    NSError *error;
    if (condition) {
        [self executeQuery:query error:&error];
        OHLogError(@"Object cannot be updated: %@", error);
    } else {
        return NO;
    }
    
    return error == nil;
}

- (BOOL)deleteObject:(NSObject<OHMappingProtocol> *)object {
    NSString *condition = [object indexKeyCondition];
    OHMySQLQuery *query = [OHMySQLQueryFactory DELETE:[object mySQLTable] condition:condition];
    
    // If object doesn't have index key don't update anything.
    NSError *error;
    if (condition) {
        OHLogError(@"Object cannot be deleted: %@", error);
        [self executeQuery:query error:&error];
    } else {
        return NO;
    }
    
    return error == nil;
}

#pragma mark - Private

- (NSArray<NSDictionary<NSString *,id> *> *)fetchResult {
    MYSQL *_mysql = self.storeCoordinator.mysql;
    MYSQL_RES *_result  = mysql_store_result(_mysql);
    MYSQL_FIELD *fields = mysql_fetch_fields(_result);
    
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    
    MYSQL_ROW row;
    while ((row = mysql_fetch_row(_result))) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        NSInteger countOfFields = mysql_num_fields(_result);
        for (CFIndex i=0; i<countOfFields; ++i) {
            NSString *key = [NSString stringWithUTF8String:fields[i].name];
            id value = [OHMySQLSerialization objectFromCString:row[i] field:&fields[i]];
            
            jsonDict[key] = value;
        }
        
        [arrayOfDictionaries addObject:jsonDict];
    }
    
    mysql_free_result(_result);
    
    return arrayOfDictionaries;
}

@end
