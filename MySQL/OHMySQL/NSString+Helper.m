//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (SQLQueryString)

#pragma mark - Helpers

- (NSString *)removeLastCharacter {
    return [self substringToIndex:self.length-1];
}

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
        return [self stringByAppendingFormat:@" LIMIT %li", limit.integerValue];
    }
    
    return self;
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

+ (NSString *)innerJoinStringFrom:(NSString *)tableName1 joinInner:(NSString *)tableName2 columnNames:(NSArray *)columnNames onCondition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT %@ FROM %@ INNER JOIN %@ ON %@", [@"" stringByCommaWithArray:columnNames], tableName1, tableName2, condition];
}

+ (NSString *)rightJoinStringFrom:(NSString *)tableName1 joinInner:(NSString *)tableName2 columnNames:(NSArray *)columnNames onCondition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT %@ FROM %@ RIGHT OUTER JOIN %@ ON %@", [@"" stringByCommaWithArray:columnNames], tableName1, tableName2, condition];
}

+ (NSString *)leftJoinStringFrom:(NSString *)tableName1 joinInner:(NSString *)tableName2 columnNames:(NSArray *)columnNames onCondition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT %@ FROM %@ LEFT OUTER JOIN %@ ON %@", [@"" stringByCommaWithArray:columnNames], tableName1, tableName2, condition];
}

+ (NSString *)fullJoinStringFrom:(NSString *)tableName1 joinInner:(NSString *)tableName2 columnNames:(NSArray *)columnNames onCondition:(NSString *)condition {
    return [NSString stringWithFormat:@"SELECT %@ FROM %@ FULL OUTER JOIN %@ ON %@", [@"" stringByCommaWithArray:columnNames], tableName1, tableName2, condition];
}

+ (NSString *)selectFirstStringFor:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnsNames ascending:(BOOL)isAscending {
    return [[NSString selectAllStringFor:tableName condition:condition orderBy:columnsNames ascending:isAscending] appendLimit:@1];
}

+ (NSString *)selectAllStringFor:(NSString *)tableName condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"SELECT * FROM %@", tableName] appendCondition:condition];
}

+ (NSString *)selectAllStringFor:(NSString *)tableName condition:(NSString *)condition orderBy:(NSArray *)columnsNames ascending:(BOOL)isAscending {
    return [[NSString stringWithFormat:@"SELECT * FROM %@", tableName] appendOrderBy:columnsNames ascending:isAscending];
}

+ (NSString *)updateStringFor:(NSString *)tableName set:(NSDictionary *)set condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, [NSString updateSetStringFrom:set]] appendCondition:condition];
}

+ (NSString *)deleteFrom:(NSString *)tableName condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"DELETE FROM %@", tableName] appendCondition:condition];
}

+ (NSString *)insertIntoFor:(NSString *)tableName set:(NSDictionary *)set {
    NSString *values = @"";
    for (NSString *value in set.allValues) {
        values = [values stringByAppendingFormat:@"'%@',", value];
    }
    
    // (%@, %@, %@) VALUES ('%@', '%@', '%@')
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, [@"" stringByCommaWithArray:set.allKeys], [values removeLastCharacter]];
}

@end
