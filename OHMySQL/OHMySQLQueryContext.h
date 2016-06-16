//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@class OHMySQLQuery, OHMySQLStoreCoordinator;

@interface OHMySQLQueryContext : NSObject

@property (strong, nonnull) OHMySQLStoreCoordinator *storeCoordinator;

- (void)executeQuery:(nonnull OHMySQLQuery *)query error:(NSError *_Nullable*_Nullable)error;

- (nullable NSArray<NSDictionary<NSString *,id> *> *)executeQueryAndFetchResult:(nonnull OHMySQLQuery *)query
                                                                 error:(NSError *_Nullable*_Nullable)error;

/**
 *  @return Returns a value representing the first automatically generated value that was set for an AUTO_INCREMENT column by the most recently executed INSERT statement to affect such a column. Returns 0, which reflects that no row was inserted. Or returns 0 if the previous statement does not use an AUTO_INCREMENT value.
 */
- (nonnull NSNumber *)lastInsertID;

/**
 *  @return An integer greater than zero indicates the number of rows affected or retrieved. Zero indicates that no records were updated for an UPDATE statement, no rows matched the WHERE clause in the query or that no query has yet been executed. -1 indicates that the query returned an error.
 */
- (nullable NSNumber *)affectedRows;

@end
