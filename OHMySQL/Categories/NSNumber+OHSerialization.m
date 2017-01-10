//  Created by Oleg on 1/10/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "NSNumber+OHSerialization.h"


@implementation NSNumber (OHSerialization)

+ (id)serializeFromCString:(const char *)cString defaultValue:(const char *)defaultValue canBeNull:(BOOL)canBeNull {
    if (cString) {
        return [NSNumber numberFromCString:cString];
    } else if (!cString && defaultValue) {
        return [NSNumber numberFromCString:defaultValue];
    } else if (!cString && canBeNull == NO) {
        return @0;
    }
    
    return [NSNull null];
}

+ (NSNumber *)numberFromCString:(const char *)cString {
    NSString *numberString = [NSString stringWithUTF8String:cString];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    return [formatter numberFromString:numberString];
}

@end
