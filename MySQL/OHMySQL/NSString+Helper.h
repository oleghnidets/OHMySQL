//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SQLQueryString)

//
+ (nonnull NSString *)innerJoinString:(nonnull NSString *)tableName1
                            joinInner:(nonnull NSString *)tableName2
                          columnNames:(nonnull NSArray *)columnNames
                          onCondition:(nonnull NSString *)condition;

+ (nonnull NSString *)leftJoinString:(nonnull NSString *)tableName1
                           joinInner:(nonnull NSString *)tableName2
                         columnNames:(nonnull NSArray *)columnNames
                         onCondition:(nonnull NSString *)condition;

+ (nonnull NSString *)rightJoinString:(nonnull NSString *)tableName1
                            joinInner:(nonnull NSString *)tableName2
                          columnNames:(nonnull NSArray *)columnNames
                          onCondition:(nonnull NSString *)condition;

+ (nonnull NSString *)fullJoinString:(nonnull NSString *)tableName1
                           joinInner:(nonnull NSString *)tableName2
                         columnNames:(nonnull NSArray *)columnNames
                         onCondition:(nonnull NSString *)condition;

//
+ (nonnull NSString *)selectFirstString:(nonnull NSString *)tableName
                              condition:(nullable NSString *)condition
                                orderBy:(nonnull NSArray *)columnsNames
                              ascending:(BOOL)isAscending;

+ (nonnull NSString *)selectAllString:(nonnull NSString *)tableName
                            condition:(nullable NSString *)condition;

+ (nonnull NSString *)selectAllString:(nonnull NSString *)tableName
                            condition:(nullable NSString *)condition
                              orderBy:(nonnull NSArray *)columnsNames
                            ascending:(BOOL)isAscending;

//
+ (nonnull NSString *)updateString:(nonnull NSString *)tableName
                               set:(nonnull NSDictionary *)set
                         condition:(nullable NSString *)condition;

//
+ (nonnull NSString *)deleteString:(nonnull NSString *)tableName condition:(nullable NSString *)condition;

+ (nonnull NSString *)insertString:(nonnull NSString *)tableName set:(nonnull NSDictionary *)set;

+ (nonnull NSString *)countString:(nonnull NSString *)tableName;

@end
