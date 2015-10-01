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

//! Pings the server and indicates whether the connection to the server is working.
@property (nonatomic, assign, readonly, getter=isConnected) BOOL connected;
@property (nonatomic, strong, readonly, null_unspecified) OHMySQLUser *user;

+ (nonnull OHMySQLManager *)sharedManager;

//! Attempts to establish a connection to a MySQL database engine. Also tries establish SSL connection if it is specified.
- (void)connectWithUser:(nonnull OHMySQLUser *)user;

#pragma mark SELECT
/**
 *  Select all records.
 *
 *  @param tableName Name of the target table.
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectAllFrom:(nonnull NSString *)tableName;

/**
 *  Select all records.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectAll:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Select all records with sorting. Sorts the records in ascending order by default.
 *
 *  @param tableName Name of the target table.
 *  @param columnNames Result-set of one or more columns.
 *
 *  @return Array of dictionaries (JSON).
 */
- (nullable NSArray<NSDictionary *> *)selectAll:(nonnull NSString *)tableName orderBy:(nonnull NSArray<NSString *> *)columnNames;

/**
 *  Select all records with sorting.
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
 *
 *  @param tableName Name of the target table.
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSDictionary<NSString *, id> *)selectFirst:(nonnull NSString *)tableName;

/**
 *  Select the first record of the selected table.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSDictionary<NSString *, id> *)selectFirst:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/**
 *  Select the first record of the selected table. Sorts the records in ascending order by default.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *  @param columnNames Result-set of one or more columns.
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSDictionary<NSString *, id> *)selectFirst:(nonnull NSString *)tableName
                                             condition:(nullable NSString *)condition
                                               orderBy:(nonnull NSArray<NSString *> *)columnNames;

/**
 *  Select the first record of the selected table.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id='10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *  @param columnNames Result-set of one or more columns.
 *  @param isAscending Ascending or descending order.
 *
 *  @return Array of dictionary (JSON).
 */
- (nullable NSDictionary<NSString *, id> *)selectFirst:(nonnull NSString *)tableName
                                             condition:(nullable NSString *)condition
                                               orderBy:(nonnull NSArray<NSString *> *)columnNames
                                             ascending:(BOOL)isAscending;

#pragma mark INSERT
/**
 *  Insert a new record.
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHResultErrorType)insertInto:(nonnull NSString *)tableName set:(nonnull NSDictionary<NSString *, id> *)set;

#pragma mark JOIN
/**
 *  Combines rows from two or more tables, based on a common field between them.
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
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHResultErrorType)updateAll:(nonnull NSString *)tableName set:(nonnull NSDictionary<NSString *, id> *)set;

/**
 *  Update all records with condition.
 *
 *  @param tableName Name of the target table.
 *  @param set       Key is column' name in table, value is your object.
 *  @param condition Likes in real SQL query (e.g: WHERE name='Name'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHResultErrorType)updateAll:(nonnull NSString *)tableName
                           set:(nonnull NSDictionary<NSString *, id> *)set
                     condition:(nullable NSString *)condition;

#pragma mark DELETE
/**
 *  Deletes all records.
 *
 *  @param tableName Name of the target table.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHResultErrorType)deleteAllFrom:(nonnull NSString *)tableName;

/**
 *  Deletes all records with condition.
 *
 *  @param tableName Name of the target table.
 *  @param condition Likes in real SQL query (e.g: WHERE id>'10'). https://en.wikipedia.org/wiki/Where_%28SQL%29
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHResultErrorType)deleteAllFrom:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

#pragma mark Other
/**
 *  Counts records in a table.
 *
 *  @param tableName Name of the target table
 *
 *  @return The returns the number of records in a table.
 */
- (nonnull NSNumber *)countAll:(nonnull NSString *)tableName;

/**
 *  Checks whether the connection to the server is working. If the connection has gone down and auto-reconnect is enabled an attempt to reconnect is made.
 *
 *  @return Zero if the connection to the server is active. Nonzero if an error occurred. A nonzero return does not indicate whether the MySQL server itself is down; the connection might be broken for other reasons such as network problems.
 */
- (OHResultErrorType)pingMySQL;

/**
 *  Causes the database specified by dbName to become the default (current) database on the current connection.
 *
 *  @param dbName Name of the target db.
 *
 *  @return Zero for success. Nonzero if an error occurred (see enum).
 */
- (OHResultErrorType)selectDataBase:(nonnull NSString *)dbName;

/**
 *  @return Returns a value representing the first automatically generated value that was set for an AUTO_INCREMENT column by the most recently executed INSERT statement to affect such a column. Returns 0, which reflects that no row was inserted. Or returns 0 if the previous statement does not use an AUTO_INCREMENT value.
 */
- (nonnull NSNumber *)lastInsertID;

/**
 *  Flushes tables or caches, or resets replication server information. The connected user must have the RELOAD privilege.
 *
 *  @param Options A bit mask composed from any combination.
 *
 *  @return Zero for success. Nonzero if an error occurred (see enum).
 */
- (OHResultErrorType)refresh:(OHRefreshOptions)options;

//! Closes a previously opened connection.
- (void)disconnect;

#pragma mark Execute
//! Executes SELECT query if only sqlQuery.queryString is SELECT-based.
- (nullable NSArray<NSDictionary<NSString *, id> *> *)executeSELECTQuery:(nonnull OHMySQLQuery *)sqlQuery;

//! Executes any query.
- (OHResultErrorType)executeQuery:(nonnull OHMySQLQuery *)sqlQuery;

@end
