//  Created by Oleg Hnidets on 6/14/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLQueryContext.h"
#import "OHMySQLStoreCoordinator.h"

#import "OHConstants.h"
#import "OHMySQLQueryRequest.h"
#import "OHMySQLSerialization.h"

#import "OHMappingProtocol.h"
#import "OHMySQLQueryRequestFactory.h"

#import "NSObject+Mapping.h"

#import "lib/include/mysql.h"

static NSString * const kContextDomain = @"mysql.error.domain";

NSError *contextError(NSString *description) {
    return [NSError errorWithDomain:kContextDomain
                               code:OHResultErrorTypeUnknown
                           userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(description, nil) }];
}

@interface OHMySQLQueryContext ()

@property (strong) NSMutableArray *p_insertedObjects;
@property (strong) NSMutableArray *p_updatedObjects;
@property (strong) NSMutableArray *p_deletedObjects;

@end

@implementation OHMySQLQueryContext

- (MYSQL *)mysql {
    return self.storeCoordinator.mysql;
}

- (instancetype)init {
    return [self initWithParentQueryContext:nil];
}

- (instancetype)initWithParentQueryContext:(OHMySQLQueryContext *)parentQueryContext {
    if (self = [super init]) {
        _p_insertedObjects = [NSMutableArray array];
        _p_updatedObjects  = [NSMutableArray array];
        _p_deletedObjects  = [NSMutableArray array];
        
        _parentQueryContext = parentQueryContext;
    }
    
    return self;
}

#pragma mark - Public

- (NSSet<NSObject<OHMappingProtocol> *> *)insertedObjects {
    return [NSSet setWithArray:self.p_insertedObjects];
}

- (NSSet<NSObject<OHMappingProtocol> *> *)updatedObjects {
    return [NSSet setWithArray:self.p_updatedObjects];
}

- (NSSet<NSObject<OHMappingProtocol> *> *)deletedObjects {
    return [NSSet setWithArray:self.p_deletedObjects];
}

#pragma mark - Execute

- (BOOL)executeQueryRequest:(OHMySQLQueryRequest *)query error:(NSError *__autoreleasing *)error {
    NSParameterAssert(query.queryString);
    MYSQL *_mysql = self.mysql;
    if (!self.storeCoordinator.isConnected || !_mysql) {
		__unused NSString *errorString = [NSString stringWithUTF8String:mysql_error(_mysql)];
        OHLogError(@"The connection is broken: %@", errorString);
        OHLogError(@"Cannot connect to DB. Check your configuration properties.");
		
		
        if (error) {
            *error = contextError(@"Cannot connect to DB. Check your configuration properties.");
        }
        
        return NO;
    }
    
    CFAbsoluteTime queryStartTime = CFAbsoluteTimeGetCurrent();
    mysql_set_server_option(_mysql, MYSQL_OPTION_MULTI_STATEMENTS_ON);
    
    // To get proper length of string in different languages.
    NSInteger queryStringLength = strlen(query.queryString.UTF8String);
    NSInteger errorCode = mysql_real_query(_mysql, query.queryString.UTF8String, queryStringLength);
    
    query.timeline.queryDuration = CFAbsoluteTimeGetCurrent() - queryStartTime;
    if (errorCode) {
        NSString *mysqlError = [NSString stringWithUTF8String:mysql_error(_mysql)];
        OHLogError(@"Cannot execute query: %@", mysqlError);
        if (error) {
            *error = contextError(mysqlError);
            return NO;
        }
    }
    
    return YES;
}

- (NSArray<NSDictionary<NSString *,id> *> *)executeQueryRequestAndFetchResult:(OHMySQLQueryRequest *)query error:(NSError *__autoreleasing *)error {
    // http://dev.mysql.com/doc/refman/5.7/en/c-api-threaded-clients.html
    @synchronized (self) {
        [self executeQueryRequest:query error:error];
        if (error && *error) {
            OHLogError(@"Cannot get results: %@", *error);
            return nil;
        }
        
        CFAbsoluteTime seralizationStartTime = CFAbsoluteTimeGetCurrent();
        NSArray *result = [self fetchResult];
        query.timeline.serializationDuration = CFAbsoluteTimeGetCurrent() - seralizationStartTime;
        
        return result;
    }
}

- (NSNumber *)affectedRows {
    @synchronized (self) {
        if (!self.mysql) {
            return @(-1);
        }
        
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

- (void)insertObject:(NSObject<OHMappingProtocol> *)object {
    if (!object || [self.p_insertedObjects containsObject:object]) { return ; }
    [self.p_insertedObjects addObject:object];
}

- (void)updateObject:(NSObject<OHMappingProtocol> *)object {
    if (!object || [self.p_updatedObjects containsObject:object]) { return ; }
    [self.p_updatedObjects addObject:object];
}

- (void)deleteObject:(NSObject<OHMappingProtocol> *)object {
    if (!object || [self.p_deletedObjects containsObject:object]) { return ; }
    [self.p_deletedObjects addObject:object];
}

- (void)refreshObject:(NSObject<OHMappingProtocol> *)object {
    [self.p_insertedObjects removeObject:object];
    [self.p_updatedObjects removeObject:object];
    [self.p_deletedObjects removeObject:object];
}

- (BOOL)save:(NSError **)error {
    @synchronized (self) {
        if (self.parentQueryContext) {
            for (NSObject<OHMappingProtocol> *objectToInsert in self.insertedObjects) {
                [self.parentQueryContext insertObject:objectToInsert];
            }
            
            for (NSObject<OHMappingProtocol> *objectToUpdate in self.updatedObjects) {
                [self.parentQueryContext updateObject:objectToUpdate];
            }
            
            for (NSObject<OHMappingProtocol> *objectToDelete in self.deletedObjects) {
                [self.parentQueryContext deleteObject:objectToDelete];
            }
            
            return YES;
        }
        
        
        NSArray *p_insertedObjectsCopy = [self.p_insertedObjects copy];
        for (NSObject<OHMappingProtocol> *objectToInsert in p_insertedObjectsCopy) {
            if ([self insertObject:objectToInsert error:error] == NO) { return NO; }
            [objectToInsert setValue:self.lastInsertID forKey:objectToInsert.primaryKey];
            [self.p_insertedObjects removeObject:objectToInsert];
        }
        
        NSArray *p_updatedObjectsCopy = [self.p_updatedObjects copy];
        for (NSObject<OHMappingProtocol> *objectToUpdate in p_updatedObjectsCopy) {
            if ([self updateObject:objectToUpdate error:error] == NO) { return NO; }
            [self.p_updatedObjects removeObject:objectToUpdate];
        }
        
        NSArray *p_deletedObjectsCopy = [self.p_deletedObjects copy];
        for (NSObject<OHMappingProtocol> *objectToDelete in p_deletedObjectsCopy) {
            if ([self deleteObject:objectToDelete error:error] == NO) { return NO; }
            [self.p_deletedObjects removeObject:objectToDelete];
        }
        
        return YES;
    }
}

- (void)performBlock:(dispatch_block_t)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block();
    });
}

- (void)saveToPersistantStore:(void(^)(NSError *))completionHandler {
    [self performBlock:^{
        NSError *error;
        [self save:&error];
        if (error) {
            completionHandler(error);
            return ;
        }
        
        // If it's the main context then this property will be nil and method won't execute.
        [self.parentQueryContext save:&error];
        completionHandler(error);
    }];
}

#pragma mark - Private

- (BOOL)insertObject:(NSObject<OHMappingProtocol> *)object error:(NSError **)error {
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory INSERT:[object mySQLTable] set:[object mapObject]];
    return [self executeQueryRequest:query error:error];
}

- (BOOL)updateObject:(NSObject<OHMappingProtocol> *)object error:(NSError **)error {
    NSString *condition = [object indexKeyCondition];
    // If object doesn't have index key don't update anything.
    if (!condition) {
        return NO;
    }
    
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory UPDATE:[object mySQLTable]
                                                                set:[object mapObject]
                                                          condition:condition];
    return [self executeQueryRequest:query error:error];
}

- (BOOL)deleteObject:(NSObject<OHMappingProtocol> *)object error:(NSError **)error {
    NSString *condition = [object indexKeyCondition];
    // If object doesn't have index key don't update anything.
    if (!condition) {
        return NO;
    }
    
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory DELETE:[object mySQLTable] condition:condition];
    return [self executeQueryRequest:query error:error];
}

- (NSArray<NSDictionary<NSString *,id> *> *)fetchResult {
    MYSQL *mysql = self.mysql;
    if (!mysql) { return nil; }
    
    MYSQL_RES *result  = mysql_store_result(mysql);
    if (!result) { return nil; }
    
    MYSQL_FIELD *fields = mysql_fetch_fields(result);
    
    NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
    
    MYSQL_ROW row = nil;
    while ((row = mysql_fetch_row(result))) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        NSInteger countOfFields = mysql_num_fields(result);
        for (CFIndex i=0; i<countOfFields; ++i) {
            NSString *key = [NSString stringWithUTF8String:fields[i].name];
            id value = [OHMySQLSerialization objectFromCString:row[i]
														 field:&fields[i]
													  encoding:self.storeCoordinator.encoding];
            jsonDict[key] = value;
        }
        
        [arrayOfDictionaries addObject:jsonDict];
    }
    
    mysql_free_result(result);
    
    return arrayOfDictionaries;
}

@end
