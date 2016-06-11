//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (SQLQueryString)

#pragma mark - Helpers
#pragma mark Append
- (NSString *)appendCondition:(NSString *)condition {
    if (condition && ![condition isEqualToString:@""]) {
        return [self stringByAppendingFormat:@" WHERE %@", condition];
    }
    
    return self;
}

- (NSString *)appendOrderBy:(NSArray *)columnNames ascending:(BOOL)isAscending {
    if (!columnNames.count) {
        return self;
    }
    
    NSString *orderByString = @" ORDER BY";
    return [self stringByAppendingString:[[orderByString stringByCommaWithArray:columnNames] stringByAppendingFormat:isAscending ? @" ASC" : @" DESC"]];;
}

- (NSString *)appendLimit:(NSNumber *)limit {
    if (limit.integerValue > 0) {
        return [self stringByAppendingFormat:@" LIMIT %li", (long)limit.integerValue];
    }
    
    return self;
}

#pragma mark Other
- (NSString *)removeLastCharacter {
    return [self substringToIndex:self.length-1];
}

+ (NSString *)updateSetStringFrom:(NSDictionary *)set {
    if (!set.count) {
        return nil;
    }
    
    NSString *setString = @"";
    for (NSString *key in set.allKeys) {
        NSString *value = set[key];
        NSString *oneSet = [NSString stringWithFormat:@"%@='%@',", key, value];
        setString = [setString stringByAppendingString:oneSet];
    }
    
    // Deletes the last coma.
    return [setString removeLastCharacter];
}

- (NSString *)stringByCommaWithArray:(NSArray *)strings {
    if (!strings.count) {
        return self;
    }
    
    NSString *result = self;
    for (NSString *column in strings) {
        result = [result stringByAppendingFormat:@" %@,", column];
    }
    
    return [result removeLastCharacter];
}

#pragma mark - Queries

#pragma mark SELECT ALL
+ (NSString *)selectAllString:(NSString *)tableName condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"SELECT * FROM %@", tableName] appendCondition:condition];
}

+ (NSString *)selectAllString:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnsNames ascending:(BOOL)isAscending {
    return [[[NSString stringWithFormat:@"SELECT * FROM %@", tableName] appendCondition:condition] appendOrderBy:columnsNames ascending:isAscending];
}

#pragma mark JOINS

+ (NSString *)join:(NSString *)joinType
         fromTable:(NSString *)table
       columnNames:(NSArray<NSString *> *)columnNames
         joinInner:(NSDictionary *)tables {
    return [NSString stringWithFormat:@"SELECT %@ FROM %@ %@", [@"" stringByCommaWithArray:columnNames], table, [NSString joinType:joinType joinOn:tables]];
}

+ (NSString *)joinType:(NSString *)joinType joinOn:(NSDictionary *)joinOn {
    NSMutableString *result = [NSMutableString new];
    for (NSString *table in joinOn.allKeys) {
        [result appendFormat:@" %@ %@ ON %@ ", joinType, table, joinOn[table]];
    }
    
    return result;
}

#pragma mark SELECT FIRST

+ (NSString *)selectFirstString:(NSString *)tableName condition:(NSString *)condition {
    return [[NSString selectAllString:tableName condition:condition] appendLimit:@1];
}

+ (NSString *)selectFirstString:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnsNames ascending:(BOOL)isAscending {
    return [[NSString selectAllString:tableName condition:condition orderBy:columnsNames ascending:isAscending] appendLimit:@1];
}


#pragma mark UPDATE
+ (NSString *)updateString:(NSString *)tableName set:(NSDictionary *)set condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, [NSString updateSetStringFrom:set]] appendCondition:condition];
}

#pragma mark DELETE
+ (NSString *)deleteString:(NSString *)tableName condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"DELETE FROM %@", tableName] appendCondition:condition];
}

#pragma mark INSERT
+ (NSString *)insertString:(NSString *)tableName set:(NSDictionary *)set {
    NSString *values = @"";
    for (NSString *value in set.allValues) {
        values = [values stringByAppendingFormat:@"'%@',", value];
    }
    
    // (%@, %@, %@) VALUES ('%@', '%@', '%@')
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, [@"" stringByCommaWithArray:set.allKeys], [values removeLastCharacter]];
}

#pragma mark Other

+ (NSString *)countString:(NSString *)tableName {
    return [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
}

+ (NSString *)lastInsertIDString {
    return @"SELECT LAST_INSERT_ID()";
}

// TODO: remove from here
- (NSString *)stringWithSingleMarks {
    return [NSString stringWithFormat:@"'%@'", self];
}

@end
