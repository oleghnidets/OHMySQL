//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@interface NSString (SQLQueryString)

//! SELECT column_name(s) FROM table1 'join type' table2 ON table1.column_name=table2.column_name
+ (nonnull NSString *)join:(nonnull NSString *)joinType
                 fromTable:(nonnull NSString *)table
               columnNames:(nonnull NSArray<NSString *> *)columnNames
                 joinInner:(nonnull NSDictionary *)tables;

//! SELECT column_name,column_name FROM table_name (WHERE column_name operator value) LIMIT 1
+ (nonnull NSString *)selectFirstString:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

//! //! SELECT column_name,column_name FROM table_name (WHERE column_name operator value) ORDER BY column_name ASC|DESC, column_name ASC|DESC LIMIT 1
+ (nonnull NSString *)selectFirstString:(nonnull NSString *)tableName
                              condition:(nullable NSString *)condition
                                orderBy:(nonnull NSArray *)columnsNames
                              ascending:(BOOL)isAscending;

//! SELECT column_name,column_name FROM table_name (WHERE column_name operator value)
+ (nonnull NSString *)selectAllString:(nonnull NSString *)tableName
                            condition:(nullable NSString *)condition;

//! SELECT column_name,column_name FROM table_name (WHERE column_name operator value) ORDER BY column_name ASC|DESC, column_name ASC|DESC
+ (nonnull NSString *)selectAllString:(nonnull NSString *)tableName
                            condition:(nullable NSString *)condition
                              orderBy:(nonnull NSArray *)columnsNames
                            ascending:(BOOL)isAscending;

//! UPDATE table_name SET column1=value1,column2=value2,... (WHERE some_column=some_value)
+ (nonnull NSString *)updateString:(nonnull NSString *)tableName
                               set:(nonnull NSDictionary *)set
                         condition:(nullable NSString *)condition;

//! DELETE FROM table_name (WHERE some_column=some_value)
+ (nonnull NSString *)deleteString:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

//! INSERT INTO table_name VALUES (value1,value2,value3,...)
+ (nonnull NSString *)insertString:(nonnull NSString *)tableName set:(nonnull NSDictionary *)set;

//! SELECT COUNT(*) FROM
+ (nonnull NSString *)countString:(nonnull NSString *)tableName;

//! SELECT LAST_INSERT_ID()
+ (nonnull NSString *)lastInsertIDString;

- (nonnull NSString *)stringWithSingleMarks;

@end
