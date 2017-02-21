//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "NSString+Utility.h"


@implementation NSString (SELECT)

+ (NSString *)SELECTString:(NSString *)tableName condition:(NSString *)condition {
	return [NSString SELECTString:tableName condition:condition orderBy:nil ascending:NO];
}

+ (NSString *)SELECTString:(NSString *)tableName
				 condition:(NSString *)condition
				   orderBy:(NSArray *)columnsNames
				 ascending:(BOOL)isAscending {
	return [[[NSString stringWithFormat:@"SELECT * FROM %@", tableName] appendCondition:condition] appendOrderBy:columnsNames ascending:isAscending];
}

+ (NSString *)SELECTFirstString:(NSString *)tableName condition:(NSString *)condition {
	return [[NSString SELECTString:tableName condition:condition] appendLimit:@1];
}

+ (NSString *)SELECTFirstString:(NSString *)tableName
					  condition:(NSString *)condition
						orderBy:(NSArray *)columnsNames
					  ascending:(BOOL)isAscending {
	return [[NSString SELECTString:tableName condition:condition orderBy:columnsNames ascending:isAscending] appendLimit:@1];
}

@end


@implementation NSString (UPDATE)

+ (NSString *)UPDATEString:(NSString *)tableName
					   set:(NSDictionary *)set
				 condition:(NSString *)condition {
	return [[NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, [NSString _updateSetStringFrom:set]] appendCondition:condition];
}

+ (NSString *)_updateSetStringFrom:(NSDictionary *)set {
	if (!set.count) {
		return nil;
	}
	
	NSString *setString = @"";
	for (NSString *key in set.allKeys) {
		NSString *oneSet = [NSString stringWithFormat:@"%@='%@',", key, set[key]];
		setString = [setString stringByAppendingString:oneSet];
	}
	
	// Deletes the last coma.
	return [setString stringByRemovingLastCharacter];
}

@end


@implementation NSString (DELETE)

+ (NSString *)DELETEString:(NSString *)tableName condition:(NSString *)condition {
	return [[NSString stringWithFormat:@"DELETE FROM %@", tableName] appendCondition:condition];
}

@end

@implementation NSString (JOIN)

+ (NSString *)JOINString:(NSString *)joinType
			   fromTable:(NSString *)table
			 columnNames:(NSArray<NSString *> *)columnNames
			   joinInner:(NSDictionary *)tables {
	NSString *joinPart = [NSString _joinType:joinType joinOn:tables];
	return [NSString stringWithFormat:@"SELECT %@ FROM %@ %@", [@"" stringByCommaWithArray:columnNames], table, joinPart];
}

+ (NSString *)_joinType:(NSString *)joinType joinOn:(NSDictionary *)joinOn {
	NSMutableString *result = [NSMutableString new];
	for (NSString *table in joinOn.allKeys) {
		[result appendFormat:@" %@ %@ ON %@ ", joinType, table, joinOn[table]];
	}
	
	return result;
}

@end

@implementation NSString (INSERT)

+ (NSString *)INSERTString:(NSString *)tableName set:(NSDictionary *)set {
	NSString *values = @"";
	for (id value in set.allValues) {
		values = [values stringByAppendingFormat:@"'%@',", value];
	}
	
	values = [values stringByRemovingLastCharacter];
	
	// (%@, %@, %@) VALUES ('%@', '%@', '%@')
	return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, [@"" stringByCommaWithArray:set.allKeys], values];
}

@end

@implementation NSString (OTHER)

#pragma mark Other
+ (NSString *)countString:(NSString *)tableName {
    return [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@", tableName];
}

+ (NSString *)lastInsertIDString {
    return @"SELECT LAST_INSERT_ID()";
}

@end

@implementation NSString (Helper)

- (NSString *)stringByRemovingLastCharacter {
    if ([self isEqualToString:@""]) {
        return self;
    }
    
    return [self substringToIndex:self.length-1];
}

- (NSString *)stringByCommaWithArray:(NSArray *)strings {
    if (!strings.count) {
        return self;
    }
    
    NSString *result = self;
    for (NSString *column in strings) {
        result = [result stringByAppendingFormat:@" %@,", column];
    }
    
    // Deletes the last coma.
    return [result stringByRemovingLastCharacter];
}

- (NSString *)appendLimit:(NSNumber *)limit {
    if (limit.integerValue > 0) {
        return [self stringByAppendingFormat:@" LIMIT %li", (long)limit.integerValue];
    }
    
    return self;
}

- (NSString *)appendCondition:(NSString *)condition {
    if (!condition.length) {
        return self;
    }
    
    return [self stringByAppendingFormat:@" WHERE %@", condition];
}

- (NSString *)appendOrderBy:(NSArray *)columnNames ascending:(BOOL)isAscending {
    if (!columnNames.count) {
        return self;
    }
    
    NSString *orderByString = @" ORDER BY";
    NSString *sortingString = isAscending ? @" ASC" : @" DESC";
    NSString *stringWithComma = [orderByString stringByCommaWithArray:columnNames];
    return [self stringByAppendingString:[stringWithComma stringByAppendingString:sortingString]];
}

- (NSString *)stringWithSingleMarks {
    return [NSString stringWithFormat:@"'%@'", self];
}

@end
