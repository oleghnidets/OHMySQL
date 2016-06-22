//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@class OHMySQLQueryRequest, OHMySQLStoreCoordinator;
@protocol OHMappingProtocol;

@interface OHMySQLQueryContext : NSObject

//! Should be set by a user of this class.
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
//! Returns bool value which indicates whether an object inserted successfully or not.
- (void)insertObject:(nullable NSObject<OHMappingProtocol> *)object;
//! Returns bool value which indicates whether an object updated successfully or not.
- (void)updateObject:(nullable NSObject<OHMappingProtocol> *)object;
//! Returns bool value which indicates whether an object deleted successfully or not.
- (void)deleteObject:(nullable NSObject<OHMappingProtocol> *)object;

- (BOOL)save:(NSError *_Nullable*_Nullable)error;

@end
