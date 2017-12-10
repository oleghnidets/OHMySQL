//  Created by Oleg Hnidets on 10/31/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMappingProtocol.h"
#import "OHConstants.h"

#import "NSObject+Mapping.h"
#import "NSString+Utility.h"

@interface NSDictionary (Mirroring)

- (NSDictionary *)mirror;

@end

@implementation NSDictionary (Mirroring)

- (NSDictionary *)mirror {
    NSMutableDictionary *mirroDictionary = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, __unused BOOL * _Nonnull stop) {
        mirroDictionary[obj] = key;
    }];
    
    return mirroDictionary;
}

@end

@interface NSObject () <OHMappingProtocol>

@end

@implementation NSObject (Mapping)

- (void)mapFromResponse:(NSDictionary *)response {
    NSParameterAssert(response);
    NSDictionary *mirrorMappingDictionary = [self.mappingDictionary mirror];
    for (NSString *key in mirrorMappingDictionary.allKeys) {
        id value = response[key] == [NSNull null] ? nil : response[key];
        [self setValue:value forKey:mirrorMappingDictionary[key]];
    }
}

#pragma GCC diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (NSString *)indexKeyCondition {
    NSString *indexKey = self.primaryKey;
    // Get object by calling property.
    id object = [self performSelector:NSSelectorFromString(indexKey)];
    
    BOOL isNumber = [object isKindOfClass:[NSNumber class]];
    
    NSAssert(isNumber || [object isKindOfClass:[NSString class]], @"Current class is not supported. Please, use NSNumber or NSString.");
    NSString *conditionValue = isNumber ? [object stringValue] : [object stringWithSingleMarks];
    
    if (conditionValue && self.mappingDictionary[indexKey]) {
        return [NSString stringWithFormat:@"%@=%@", self.mappingDictionary[indexKey], conditionValue];
    }
    
    OHLogWarn(@"This object doesn't have index key.");
    
    return nil;
}

#pragma GCC diagnostic pop

- (NSDictionary *)mapObject {
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
