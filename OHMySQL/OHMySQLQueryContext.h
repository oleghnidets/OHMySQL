//  Created by Oleg Hnidets on 6/14/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@class OHMySQLQueryRequest, OHMySQLStoreCoordinator;
@protocol OHMappingProtocol;

/// An instance of this class is responsible for executing queries, saving/updating/deleting objects.
@interface OHMySQLQueryContext : NSObject

- (nonnull instancetype)initWithParentQueryContext:(nullable OHMySQLQueryContext *)parentQueryContext NS_DESIGNATED_INITIALIZER;

@property (strong, nonnull) OHMySQLQueryContext *parentQueryContext;

/// Should be set by a user of this class.
@property (strong, nonnull) OHMySQLStoreCoordinator *storeCoordinator;

@property (nonatomic, readonly, strong, nullable) NSSet<__kindof NSObject<OHMappingProtocol> *> *insertedObjects;
@property (nonatomic, readonly, strong, nullable) NSSet<__kindof NSObject<OHMappingProtocol> *> *updatedObjects;
@property (nonatomic, readonly, strong, nullable) NSSet<__kindof NSObject<OHMappingProtocol> *> *deletedObjects;

/**
 *  Executes a query.
 *
 *  @param query An query that should be executed.
 *  @param error The error that occurred during the attempt to execute.
 */
- (BOOL)executeQueryRequest:(nonnull OHMySQLQueryRequest *)query error:(NSError *_Nullable*_Nullable)error;

/**
 *  Executes a query and returns result. This method is the most applicable for SELECT queries.
 *
 *  @param query An query that should be executed.
 *  @param error The error that occurred during the attempt to execute.
 *
 *  @return Result parsed as an array of dictionaries.
 */
- (nullable NSArray<NSDictionary<NSString *,id> *> *)executeQueryRequestAndFetchResult:(nonnull OHMySQLQueryRequest *)query
                                                                                 error:(NSError *_Nullable*_Nullable)error;

/**
 *  @return Returns a value representing the first automatically generated value that was set for an AUTO_INCREMENT column by the most recently executed INSERT statement to affect such a column. Returns 0, which reflects that no row was inserted. Or returns 0 if the previous statement does not use an AUTO_INCREMENT value.
 */
- (nonnull NSNumber *)lastInsertID;

/**
 *  @return An integer greater than zero indicates the number of rows affected or retrieved. Zero indicates that no records were updated for an UPDATE statement, no rows matched the WHERE clause in the query or that no query has yet been executed. -1 indicates that the query returned an error.
 */
- (nullable NSNumber *)affectedRows;


// MARK: Temporary solution... maybe.
/// Makes object ready to be inserted.
- (void)insertObject:(nullable NSObject<OHMappingProtocol> *)object;
/// Makes object ready to be updated.
- (void)updateObject:(nullable NSObject<OHMappingProtocol> *)object;
/// Makes object ready to be deleted.
- (void)deleteObject:(nullable NSObject<OHMappingProtocol> *)object;

/// Removes object from deleted/inserted/updated.
- (void)refreshObject:(nullable NSObject<OHMappingProtocol> *)object;

/**
 *  Attempts to commit unsaved changes.
 *
 *  @param error A pointer to an NSError object. 
 *
 *  @return YES if the save succeeds, otherwise NO.
 */
- (BOOL)save:(NSError *_Nullable*_Nullable)error;

/// Performs block asynchronously.
- (void)performBlock:(nonnull dispatch_block_t)block;

/// Saves to MySQL store asynchronously in global queue.
- (void)saveToPersistantStore:(nonnull void(^)(NSError *_Nullable error))completionHandler;

@end
