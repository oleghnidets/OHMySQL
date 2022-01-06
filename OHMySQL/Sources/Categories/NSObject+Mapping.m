//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "OHMySQLMappingProtocol.h"
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

@interface NSObject () <OHMySQLMappingProtocol>

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
