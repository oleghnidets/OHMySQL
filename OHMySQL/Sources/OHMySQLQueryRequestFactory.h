//
//  Copyright (c) 2015-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

@import Foundation;
@class OHMySQLQueryRequest;

NS_SWIFT_NAME(MySQLQueryRequestFactory)
/// Convenience class for making specific ``OHMySQLQueryRequest`` instances.
@interface OHMySQLQueryRequestFactory : NSObject

@end

@interface OHMySQLQueryRequestFactory (SELECT)

/// Select all records with condition.
/// - Parameters:
///   - tableName: Name of the target table.
///   - condition: SQL condition (e.g: WHERE id='10').
+ (nonnull OHMySQLQueryRequest *)SELECT:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/// Select all records with condition, ordering and sorting.
/// - Parameters:
///   - tableName: Name of the target table.
///   - condition: SQL condition (e.g: WHERE id='10').
///   - columnNames: Set of one or more columns.
///   - isAscending: Indicates if ascending order.
+ (nonnull OHMySQLQueryRequest *)SELECT:(nonnull NSString *)tableName
                              condition:(nullable NSString *)condition
                                orderBy:(nonnull NSArray<NSString *> *)columnNames
                              ascending:(BOOL)isAscending;

/// Select the first record of the selected table with condition.
/// - Parameters:
///   - tableName: Name of the target table.
///   - condition: SQL condition (e.g: WHERE id='10').
+ (nonnull OHMySQLQueryRequest *)SELECTFirst:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/// Select the first record of the selected table with condition, ordering and sorting.
/// - Parameters:
///   - tableName: Name of the target table.
///   - condition: SQL condition (e.g: WHERE id='10').
///   - columnNames: Set of one or more columns.
///   - isAscending: Indicates if ascending order.
+ (nonnull OHMySQLQueryRequest *)SELECTFirst:(nonnull NSString *)tableName
                                   condition:(nullable NSString *)condition
                                     orderBy:(nonnull NSArray<NSString *> *)columnNames
                                   ascending:(BOOL)isAscending;

@end

@interface OHMySQLQueryRequestFactory (INSERT)

/// Insert a new record.
/// - Parameters:
///   - tableName: Name of the target table.
///   - set: Key is column' name in table, value is your object.
+ (nonnull OHMySQLQueryRequest *)INSERT:(nonnull NSString *)tableName set:(nonnull NSDictionary<NSString *, id> *)set;

@end

@interface OHMySQLQueryRequestFactory (UPDATE)

/// Updates all records with condition.
/// - Parameters:
///   - tableName: Name of the target table.
///   - set: Key is column' name in table, value is your object.
///   - condition: SQL condition (e.g: WHERE id='10').
+ (nonnull OHMySQLQueryRequest *)UPDATE:(nonnull NSString *)tableName
                                    set:(nonnull NSDictionary<NSString *, id> *)set
                              condition:(nullable NSString *)condition;

@end

@interface OHMySQLQueryRequestFactory (DELETE)

/// Deletes all records with condition.
/// - Parameters:
///   - tableName: Name of the target table.
///   - condition: SQL condition (e.g: WHERE id='10').
+ (nonnull OHMySQLQueryRequest *)DELETE:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

@end

@interface OHMySQLQueryRequestFactory (JOIN)

/// Combines rows from two or more tables, based on a common field between them.
/// - Parameters:
///   - joinType: Type of join (Use one of the constants from ``OHJoin``).
///   - tableName: Name of the target table.
///   - columnNames: Columns to fetch.
///   - joinOn: In format `[Table:Condition]`. Example: `{ "Users":"Users.id=Company.userId" }`.
+ (nonnull OHMySQLQueryRequest *)JOINType:(nonnull NSString *)joinType
                                fromTable:(nonnull NSString *)tableName
                              columnNames:(nonnull NSArray<NSString *> *)columnNames
                                   joinOn:(nonnull NSDictionary<NSString *,NSString *> *)joinOn;

@end

@interface OHMySQLQueryRequestFactory (Other)

/// Counts records in a table.
/// - Parameter tableName: Name of the target table.
+ (nonnull OHMySQLQueryRequest *)countAll:(nonnull NSString *)tableName;

@end
