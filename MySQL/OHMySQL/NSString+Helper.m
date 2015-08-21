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
        return  [self stringByAppendingFormat:@" WHERE %@", condition];
    }
    
    return self;
}

+ (NSString *)updateSetStringFrom:(NSDictionary *)set {
    NSString *setString = @"";
    for (NSString *key in set.allKeys) {
        NSString *value = set[key];
        NSString *oneSet = [NSString stringWithFormat:@"%@='%@',", key, value];
        setString = [setString stringByAppendingString:oneSet];
    }
    
    // Deletes the last coma.
    return [setString removeLastCharacter];
}

#pragma mark - Queries

+ (NSString *)selectAllStringFor:(NSString *)tableName condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"SELECT * FROM %@", tableName] appendCondition:condition];
}

+ (NSString *)updateStringFor:(NSString *)tableName set:(NSDictionary *)set condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, [NSString updateSetStringFrom:set]] appendCondition:condition];
}

+ (NSString *)deleteFrom:(NSString *)tableName condition:(NSString *)condition {
    return [[NSString stringWithFormat:@"DELETE FROM %@", tableName] appendCondition:condition];
}

+ (NSString *)insertIntoFor:(NSString *)tableName set:(NSDictionary *)set {
    NSString *columnsString = @"";
    for (NSString *column in set.allKeys) {
        columnsString = [columnsString stringByAppendingFormat:@"%@,", column];
    }
    
    NSString *values = @"";
    for (NSString *value in set.allValues) {
        values = [values stringByAppendingFormat:@"'%@',", value];
    }
    
    return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, [columnsString removeLastCharacter], [values removeLastCharacter]];
}

@end
