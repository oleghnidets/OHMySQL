//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "OHMySQLQueryContext.h"
#import "OHMySQLStoreCoordinator.h"

#import "OHConstants.h"
#import "OHMySQLQueryRequest.h"
#import "OHMySQLSerialization.h"

#import "OHMySQLMappingProtocol.h"
#import "OHMySQLQueryRequestFactory.h"

#import "NSObject+Mapping.h"

@import MySQL;
//#import "lib/include/mysql.h"

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

- (NSSet<NSObject<OHMySQLMappingProtocol> *> *)insertedObjects {
    @synchronized (self.p_insertedObjects) {
        return [NSSet setWithArray:self.p_insertedObjects];
    }
}

- (NSSet<NSObject<OHMySQLMappingProtocol> *> *)updatedObjects {
    @synchronized (self.p_updatedObjects) {
        return [NSSet setWithArray:self.p_updatedObjects];
    }
}

- (NSSet<NSObject<OHMySQLMappingProtocol> *> *)deletedObjects {
    @synchronized (self.p_deletedObjects) {
        return [NSSet setWithArray:self.p_deletedObjects];
    }
}

#pragma mark - Execute

- (BOOL)executeQueryRequest:(OHMySQLQueryRequest *)query error:(NSError *__autoreleasing *)error {
    // http://dev.mysql.com/doc/refman/5.7/en/c-api-threaded-clients.html
    @synchronized(self) {
        NSParameterAssert(query.query);
        
        if ((!self.storeCoordinator.isConnected || self.mysql == NULL) && ![self.storeCoordinator reconnect]) {
            __unused NSString *errorString = [NSString stringWithUTF8String:mysql_error(self.mysql)];
            OHLogError(@"The connection is broken: %@", errorString);
            OHLogError(@"Cannot connect to DB. Check your configuration properties.");
            
            if (error) {
                *error = contextError(@"Cannot connect to DB. Check your configuration properties.");
            }
            
            return NO;
        }
        
        CFAbsoluteTime queryStartTime = CFAbsoluteTimeGetCurrent();
        mysql_set_server_option(self.mysql, MYSQL_OPTION_MULTI_STATEMENTS_ON);
        
        // To get proper length of string in different languages.
        NSInteger queryStringLength = strlen(query.query.UTF8String);
        NSInteger errorCode = mysql_real_query(self.mysql, query.query.UTF8String, queryStringLength);
        
        query.timeline.queryDuration = CFAbsoluteTimeGetCurrent() - queryStartTime;
        if (errorCode) {
            if ([self.storeCoordinator reconnect]) {
                OHLog(@"Reconnection succeeded.");
            }
            
            NSString *mysqlError = [NSString stringWithUTF8String:mysql_error(self.mysql)];
            OHLogError(@"Cannot execute the query: %@", mysqlError);
            
            if (error) {
                *error = contextError(mysqlError);
                return NO;
            }
        }
        
        return YES;
    }
}

- (NSArray<NSDictionary<NSString *,id> *> *)executeQueryRequestAndFetchResult:(OHMySQLQueryRequest *)query error:(NSError *__autoreleasing *)error {
    [self executeQueryRequest:query error:error];
    
    if (error && *error) {
        OHLogError(@"Cannot get the results: %@", *error);
        return nil;
    }
    
    CFAbsoluteTime seralizationStartTime = CFAbsoluteTimeGetCurrent();
    NSArray *result = [self fetchResult];
    query.timeline.serializationDuration = CFAbsoluteTimeGetCurrent() - seralizationStartTime;
    
    return result;
}

- (NSNumber *)affectedRows {
    @synchronized (self) {
        if (self.mysql == NULL) {
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

- (void)insertObject:(NSObject<OHMySQLMappingProtocol> *)object {
    @synchronized (self.p_insertedObjects) {
        if (!object || [self.p_insertedObjects containsObject:object]) { return ; }
        [self.p_insertedObjects addObject:object];
    }
}

- (void)updateObject:(NSObject<OHMySQLMappingProtocol> *)object {
    @synchronized (self.p_updatedObjects) {
        if (!object || [self.p_updatedObjects containsObject:object]) { return ; }
        [self.p_updatedObjects addObject:object];
    }
}

- (void)deleteObject:(NSObject<OHMySQLMappingProtocol> *)object {
    @synchronized (self.p_deletedObjects) {
        if (!object || [self.p_deletedObjects containsObject:object]) { return ; }
        [self.p_deletedObjects addObject:object];
    }
}

- (void)refreshObject:(NSObject<OHMySQLMappingProtocol> *)object {
    @synchronized (self.p_insertedObjects) {
        [self.p_insertedObjects removeObject:object];
    }
    
    @synchronized (self.p_updatedObjects) {
        [self.p_updatedObjects removeObject:object];
    }
        
    @synchronized (self.p_deletedObjects) {
        [self.p_deletedObjects removeObject:object];
    }
}

- (BOOL)save:(NSError **)error {
    @synchronized (self) {
        if (self.parentQueryContext) {
            for (NSObject<OHMySQLMappingProtocol> *objectToInsert in self.insertedObjects) {
                [self.parentQueryContext insertObject:objectToInsert];
            }
            
            for (NSObject<OHMySQLMappingProtocol> *objectToUpdate in self.updatedObjects) {
                [self.parentQueryContext updateObject:objectToUpdate];
            }
            
            for (NSObject<OHMySQLMappingProtocol> *objectToDelete in self.deletedObjects) {
                [self.parentQueryContext deleteObject:objectToDelete];
            }
            
            return YES;
        }
        
        
        NSArray *p_insertedObjectsCopy = [self.p_insertedObjects copy];
        for (NSObject<OHMySQLMappingProtocol> *objectToInsert in p_insertedObjectsCopy) {
            if ([self insertObject:objectToInsert error:error] == NO) { return NO; }
            [objectToInsert setValue:self.lastInsertID forKey:objectToInsert.primaryKey];
            [self.p_insertedObjects removeObject:objectToInsert];
        }
        
        NSArray *p_updatedObjectsCopy = [self.p_updatedObjects copy];
        for (NSObject<OHMySQLMappingProtocol> *objectToUpdate in p_updatedObjectsCopy) {
            if ([self updateObject:objectToUpdate error:error] == NO) { return NO; }
            [self.p_updatedObjects removeObject:objectToUpdate];
        }
        
        NSArray *p_deletedObjectsCopy = [self.p_deletedObjects copy];
        for (NSObject<OHMySQLMappingProtocol> *objectToDelete in p_deletedObjectsCopy) {
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

- (BOOL)insertObject:(NSObject<OHMySQLMappingProtocol> *)object error:(NSError **)error {
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory INSERT:[object mySQLTable] set:[object mapObject]];
    return [self executeQueryRequest:query error:error];
}

- (BOOL)updateObject:(NSObject<OHMySQLMappingProtocol> *)object error:(NSError **)error {
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

- (BOOL)deleteObject:(NSObject<OHMySQLMappingProtocol> *)object error:(NSError **)error {
    NSString *condition = [object indexKeyCondition];
    // If object doesn't have index key don't update anything.
    if (!condition) {
        return NO;
    }
    
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory DELETE:[object mySQLTable] condition:condition];
    return [self executeQueryRequest:query error:error];
}

- (NSArray<NSDictionary<NSString *,id> *> *)fetchResult {
    @synchronized (self) {
        MYSQL *mysql = self.mysql;
        
        if (!mysql) {
            return nil;
        }
        
        MYSQL_RES *result = mysql_use_result(mysql);
        if (!result) {
            if (mysql_field_count(mysql) == 0) {
                OHLog(@"%@ rows affected\n", self.affectedRows);
            } else {
                OHLogWarn(@"Could not retrieve a result set\n");
            }
            
            return nil;
        }
        
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
}

@end
