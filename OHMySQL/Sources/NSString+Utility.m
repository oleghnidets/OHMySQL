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

#import "NSString+Utility.h"
#import "NSString+Escaping.h"

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
	NSString *keys = @"";
	for (id key in set.allKeys) {
		keys = [keys stringByAppendingFormat:@"%@,", key];
		values = [values stringByAppendingFormat:@"'%@',", set[key]];
	}
	
	keys = [keys stringByRemovingLastCharacter];
	values = [values stringByRemovingLastCharacter];
	
	// (%@, %@, %@) VALUES ('%@', '%@', '%@')
	return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, keys, values];
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

@dynamic stringWithSingleMarks;

- (void)stringWithSingleMarks:(NSString *)newString {
	NSAssert(NO, @"You mustn't set this property.");
}

- (NSString *)stringWithSingleMarks {
    return [NSString stringWithFormat:@"'%@'", self];
}

@end
