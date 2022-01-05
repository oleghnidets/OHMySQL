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
@class OHMySQLQueryRequest;

NS_SWIFT_NAME(MySQLQueryRequestFactory)
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
