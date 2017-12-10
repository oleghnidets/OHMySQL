//  Created by Oleg Hnidets on 6/14/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@class OHMySQLQueryRequest;

/// Convenience class for making specific OHMySQLQueryRequest instances.
@interface OHMySQLQueryRequestFactory : NSObject

@end

@interface OHMySQLQueryRequestFactory (SELECT)

/**
 *  Select all records.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)SELECT:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Select all records with sorting.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *  @param columnNames Result-set of one or more columns.
 *  @param isAscending Ascending or descending order.
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)SELECT:(nonnull NSString *)tableName
                              condition:(nullable NSString *)condition
                                orderBy:(nonnull NSArray<NSString *> *)columnNames
                              ascending:(BOOL)isAscending;

/**
 *  Select the first record of the selected table.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)SELECTFirst:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Select the first record of the selected table.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *  @param columnNames Result-set of one or more columns.
 *  @param isAscending Ascending or descending order.
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)SELECTFirst:(nonnull NSString *)tableName
                                   condition:(nullable NSString *)condition
                                     orderBy:(nonnull NSArray<NSString *> *)columnNames
                                   ascending:(BOOL)isAscending;

@end

@interface OHMySQLQueryRequestFactory (INSERT)

/**
 *  Insert a new record.
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)INSERT:(nonnull NSString *)tableName set:(nonnull NSDictionary<NSString *, id> *)set;

@end

@interface OHMySQLQueryRequestFactory (UPDATE)

/**
 *  Update all records with condition.
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *  @param condition Likes in real SQL query (e.g: WHERE name='Name'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)UPDATE:(nonnull NSString *)tableName
                                    set:(nonnull NSDictionary<NSString *, id> *)set
                              condition:(nullable NSString *)condition;

@end

@interface OHMySQLQueryRequestFactory (DELETE)

/**
 *  Deletes all records with condition.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id>'10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)DELETE:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

@end

@interface OHMySQLQueryRequestFactory (JOIN)

/**
 *  Combines rows from two or more tables, based on a common field between them.
 *
 *  @param joinType    Type of join (Use one of the constants from OHJoinConstants).
 *  @param tableName   Destination table.
 *  @param columnNames Columns to fetch.
 *  @param joinOn      [Table:Condition]. { "Users":"Users.id=Company.userId" }
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)JOINType:(nonnull NSString *)joinType
                                fromTable:(nonnull NSString *)tableName
                              columnNames:(nonnull NSArray<NSString *> *)columnNames
                                   joinOn:(nonnull NSDictionary<NSString *,NSString *> *)joinOn;

@end

@interface OHMySQLQueryRequestFactory (Other)

/**
 *  Counts records in a table.
 *
 *  @param tableName Name of the target table
 *
 *  @return An instance of OHMySQLQueryRequest.
 */
+ (nonnull OHMySQLQueryRequest *)countAll:(nonnull NSString *)tableName;

@end
