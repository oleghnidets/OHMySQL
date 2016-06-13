//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import "NSObject+Mapping.h"
#import "OHMySQLManager.h"
#import "NSString+Helper.h"
#import "OHMappingProtocol.h"

@interface NSDictionary (Mirroring)

- (NSDictionary *)mirror;

@end

@implementation NSDictionary (Mirroring)

- (NSDictionary *)mirror {
    return [NSDictionary dictionaryWithObjects:self.allKeys forKeys:self.allValues];
}

@end

@interface NSObject () <OHMappingProtocol>

@end

@implementation NSObject (Mapping)

#pragma GCC diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (OHResultErrorType)insert {
    OHResultErrorType errorType = [[OHMySQLManager sharedManager] insertInto:self.mySQLTable set:[self mapObjectToDictionary]];
    
    if (!errorType) {
        NSNumber *lastID = [[OHMySQLManager sharedManager] lastInsertID];
        if (lastID && ![lastID isEqualToNumber:@0]) {
            [self setValue:lastID forKey:self.indexKey];
            OHLog(@"Last ID %@", lastID);
        }
    }
    
    return errorType;
}

- (OHResultErrorType)update {
    return [self updateWithCondition:[self indexKeyCondition]];
}

- (OHResultErrorType)updateWithCondition:(NSString *)condition {
    NSParameterAssert(condition);
    return [[OHMySQLManager sharedManager] updateAll:self.mySQLTable
                                                 set:[self mapObjectToDictionary]
                                           condition:condition];
}

- (OHResultErrorType)deleteObject {
    return [[OHMySQLManager sharedManager] deleteAllFrom:self.indexKey condition:[self indexKeyCondition]];
}

- (void)mapFromResponse:(NSDictionary *)response {
    NSParameterAssert(response);
    NSDictionary *mirrorMappingDictionary = [self.mappingDictionary mirror];
    for (NSString *key in mirrorMappingDictionary.allKeys) {
        [self setValue:response[key] forKey:mirrorMappingDictionary[key]];
    }
}

#pragma mark - Private

- (NSString *)indexKeyCondition {
    NSString *indexKey = self.indexKey;
    // Get object by calling property.
    id object = [self performSelector:NSSelectorFromString(indexKey)];
    
    BOOL isNumber = [object isKindOfClass:[NSNumber class]];
    
    NSAssert(isNumber || [object isKindOfClass:[NSString class]], @"Current class is not supported. Please, use NSNumber or NSString.");
    NSString *conditionValue = isNumber ? [object stringValue] : [object stringWithSingleMarks];
    
    if (conditionValue && self.mappingDictionary[indexKey]) {
        return [NSString stringWithFormat:@"%@=%@", self.mappingDictionary[indexKey], conditionValue];
    }
    
    OHLogWarn(@"This object doesn't have index key. It'll update all records in table.");
    
    return nil;
}

- (NSDictionary *)mapObjectToDictionary {
    NSMutableDictionary *objectDictionary = [NSMutableDictionary dictionary];
    
    NSDictionary *mirrorMappingDictionary = [self.mappingDictionary mirror];
    for (NSString *key in mirrorMappingDictionary.allKeys) {
        // Get object by calling property.
        id object = [self performSelector:NSSelectorFromString(mirrorMappingDictionary[key])];
        if (object) {
            [objectDictionary setObject:object forKey:key];
        }
    }
    
    return objectDictionary;
}

@end
