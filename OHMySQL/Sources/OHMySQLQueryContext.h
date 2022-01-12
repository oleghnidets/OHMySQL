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

@import Foundation;
@class OHMySQLQueryRequest, OHMySQLStoreCoordinator;
@protocol OHMySQLMappingProtocol;

NS_SWIFT_NAME(MySQLQueryContext)
/// An instance of this class is responsible for executing queries, saving/updating/deleting objects.
@interface OHMySQLQueryContext : NSObject

/**
 Initializes a context with a given parent context.

 @param parentQueryContext The parent of the context.
 @return Initialized context with set parent context.
 */
- (nonnull instancetype)initWithParentQueryContext:(nullable OHMySQLQueryContext *)parentQueryContext;

/// The parent of the context.
@property (strong, nullable) OHMySQLQueryContext *parentQueryContext;

/// Should be set before using the class.
@property (strong, nonnull) OHMySQLStoreCoordinator *storeCoordinator;

/// The set of objects that have been inserted into the context but not yet saved in a persistent store.
@property (nonatomic, readonly, strong, nullable) NSSet<__kindof NSObject<OHMySQLMappingProtocol> *> *insertedObjects;
/// The set of objects that have been updated into the context but not yet saved in a persistent store.
@property (nonatomic, readonly, strong, nullable) NSSet<__kindof NSObject<OHMySQLMappingProtocol> *> *updatedObjects;
/// The set of objects that have been deleted into the context but not yet saved in a persistent store.
@property (nonatomic, readonly, strong, nullable) NSSet<__kindof NSObject<OHMySQLMappingProtocol> *> *deletedObjects;

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
- (void)insertObject:(nullable NSObject<OHMySQLMappingProtocol> *)object;
/// Makes object ready to be updated.
- (void)updateObject:(nullable NSObject<OHMySQLMappingProtocol> *)object;
/// Makes object ready to be deleted.
- (void)deleteObject:(nullable NSObject<OHMySQLMappingProtocol> *)object;

/// Removes object from deleted/inserted/updated.
- (void)refreshObject:(nullable NSObject<OHMySQLMappingProtocol> *)object;

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
