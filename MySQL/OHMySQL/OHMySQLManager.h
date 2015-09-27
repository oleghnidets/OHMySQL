//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

#import "OHConstants.h"

@class OHMySQLUser, OHMySQLQuery;

extern NSString *_Nonnull const OHJoinInner;
extern NSString *_Nonnull const OHJoinRight;
extern NSString *_Nonnull const OHJoinLeft;
extern NSString *_Nonnull const OHJoinFull;

@interface OHMySQLManager : NSObject

@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, strong, readonly, null_unspecified) OHMySQLUser *user;

+ (nonnull OHMySQLManager *)sharedManager;
- (void)connectWithUser:(nonnull OHMySQLUser *)user;
- (void)disconnect;

#pragma mark SELECT
/**
 *  Select all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectAllFrom:(nonnull NSString *)tableName;

/**
 *  Select all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectAll:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Select all records with sorting. Sorts the records in ascending order by default.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param columnNames Result-set of one or more columns.
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectAll:(nonnull NSString *)tableName orderBy:(nonnull NSArray<NSString *> *)columnNames;

/**
 *  Select all records with sorting.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *  @param columnNames Result-set of one or more columns.
 *  @param isAscending Ascending or descending order.
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectAll:(nonnull NSString *)tableName
                                      condition:(nullable NSString *)condition
                                        orderBy:(nonnull NSArray<NSString *> *)columnNames
                                      ascending:(BOOL)isAscending;

#pragma mark SELECT FIRST
/**
 *  Select the first record of the selected table.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSArray *)selectFirst:(nonnull NSString *)tableName;

/**
 *  Select the first record of the selected table.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSArray *)selectFirst:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Select the first record of the selected table. Sorts the records in ascending order by default.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *  @param columnNames Result-set of one or more columns.
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSArray *)selectFirst:(nonnull NSString *)tableName
                        condition:(nullable NSString *)condition
                          orderBy:(nonnull NSArray<NSString *> *)columnNames;

/**
 *  Select the first record of the selected table.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *  @param columnNames Result-set of one or more columns.
 *  @param isAscending Ascending or descending order.
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectFirst:(nonnull NSString *)tableName
                                        condition:(nullable NSString *)condition
                                          orderBy:(nonnull NSArray<NSString *> *)columnNames
                                        ascending:(BOOL)isAscending;

#pragma mark INSERT
/**
 *  Insert a new record.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)insertInto:(nonnull NSString *)tableName set:(nonnull NSDictionary<NSString *, id> *)set;

#pragma mark JOIN
/**
 *  Combines rows from two or more tables, based on a common field between them.
 *  @pre You must connect user once.
 *
 *  @param joinType    Type of join.
 *  @param tableName1  Left table.
 *  @param tableName2  Right table.
 *  @param columnNames Array of column names.
 *  @param condition   Common condition.
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray *)selectJoinType:(nonnull NSString *)joinType
                                from:(nonnull NSString *)tableName1
                                join:(nonnull NSString *)tableName2
                         columnNames:(nonnull NSArray<NSString *> *)columnNames
                         onCondition:(nonnull NSString *)condition;

#pragma mark UPDATE
/**
 *  Update all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)updateAll:(nonnull NSString *)tableName set:(nonnull NSDictionary<NSString *, id> *)set;

/**
 *  Update all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *  @param condition Likes in real SQL query (e.g: WHERE name='Name'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)updateAll:(nonnull NSString *)tableName
                                set:(nonnull NSDictionary<NSString *, id> *)set
                          condition:(nullable NSString *)condition;

#pragma mark DELETE
/**
 *  Deletes all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)deleteAllFrom:(nonnull NSString *)tableName;

/**
 *  Deletes all records.
 *  @pre You must connect user once.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id>'10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHQueryResultErrorType)deleteAllFrom:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

#pragma mark Other

- (nonnull NSNumber *)countAll:(nonnull NSString *)tableName;

#pragma mark Execute
//! Executes SELECT query if only sqlQuery.queryString is SELECT-based.
- (nullable NSArray *)executeSELECTQuery:(nonnull OHMySQLQuery *)sqlQuery;
//! Executes UPDATE query if only sqlQuery.queryString is UPDATE-based.
- (void)executeUPDATEQuery:(nonnull OHMySQLQuery *)sqlQuery;
//! Executes DELETE query if only sqlQuery.queryString is DELETE-based.
- (void)executeDELETEQuery:(nonnull OHMySQLQuery *)sqlQuery;

//! Executes any query.
- (OHQueryResultErrorType)executeQuery:(nonnull OHMySQLQuery *)sqlQuery;

@end
