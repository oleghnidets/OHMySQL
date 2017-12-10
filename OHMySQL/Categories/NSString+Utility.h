//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@interface NSString (SELECT)

/// SELECT column_name,column_name FROM table_name (WHERE column_name operator value) LIMIT 1
+ (nonnull NSString *)SELECTFirstString:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/// /// SELECT column_name,column_name FROM table_name (WHERE column_name operator value) ORDER BY column_name ASC|DESC, column_name ASC|DESC LIMIT 1
+ (nonnull NSString *)SELECTFirstString:(nonnull NSString *)tableName
							  condition:(nullable NSString *)condition
								orderBy:(nonnull NSArray<NSString *> *)columnsNames
							  ascending:(BOOL)isAscending;

/// SELECT column_name,column_name FROM table_name (WHERE column_name operator value)
+ (nonnull NSString *)SELECTString:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

/// SELECT column_name,column_name FROM table_name (WHERE column_name operator value) ORDER BY column_name ASC|DESC, column_name ASC|DESC
+ (nonnull NSString *)SELECTString:(nonnull NSString *)tableName
						 condition:(nullable NSString *)condition
						   orderBy:(nullable NSArray<NSString *> *)columnsNames
						 ascending:(BOOL)isAscending;

@end

@interface NSString (UPDATE)

/// UPDATE table_name SET column1=value1,column2=value2,... (WHERE some_column=some_value)
+ (nonnull NSString *)UPDATEString:(nonnull NSString *)tableName
							   set:(nonnull NSDictionary<NSString *, id> *)set
						 condition:(nullable NSString *)condition;

@end

@interface NSString (DELETE)

/// DELETE FROM table_name (WHERE some_column=some_value)
+ (nonnull NSString *)DELETEString:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

@end

@interface NSString (JOIN)

+ (nonnull NSString *)JOINString:(nonnull NSString *)joinType
					   fromTable:(nonnull NSString *)table
					 columnNames:(nonnull NSArray<NSString *> *)columnNames
					   joinInner:(nonnull NSDictionary<NSString *, NSString *> *)tables;

@end

@interface NSString (INSERT)

+ (nonnull NSString *)INSERTString:(nonnull NSString *)tableName
							   set:(nonnull NSDictionary<NSString *, id> *)set;

@end

@interface NSString (OTHER)

/// SELECT COUNT(*) FROM
+ (nonnull NSString *)countString:(nonnull NSString *)tableName;

/// SELECT LAST_INSERT_ID()
+ (nonnull NSString *)lastInsertIDString;

@end

@interface NSString (Helper)

/// Removes the last character in string.
- (nonnull NSString *)stringByRemovingLastCharacter;

/// Adds commas beetwen string.
- (nonnull NSString *)stringByCommaWithArray:(nullable NSArray<NSString *> *)strings;

/// Appends the function LIMIT.
- (nonnull NSString *)appendLimit:(nullable NSNumber *)limit;

/// Appends condition WHERE.
- (nonnull NSString *)appendCondition:(nonnull NSString *)condition;

/// Appends ORDER BY and sorting type.
- (nonnull NSString *)appendOrderBy:(nullable NSArray<NSString *> *)columnNames ascending:(BOOL)isAscending;

/// Returns a string like 'string'.
@property (class, readonly, nonnull) NSString *stringWithSingleMarks;

@end
