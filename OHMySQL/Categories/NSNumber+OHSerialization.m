//  Created by Oleg on 1/10/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "NSNumber+OHSerialization.h"
@import CoreFoundation;

@implementation NSNumber (OHSerialization)

+ (id)serializeFromCString:(const char *)cString defaultValue:(const char *)defaultValue canBeNull:(BOOL)canBeNull encoding:(CharsetEncoding)encoding {
    if (cString) {
        return [NSNumber numberFromCString:cString encoding:encoding];
    } else if (!cString && defaultValue) {
        return [NSNumber numberFromCString:defaultValue encoding:encoding];
    } else if (!cString && canBeNull == NO) {
        return @0;
    }
    
    return [NSNull null];
}

+ (NSNumber *)numberFromCString:(const char *)cString encoding:(CharsetEncoding)encoding {
	NSStringEncoding nsEncoding = NSStringEncodingFromCharsetEncoding(encoding);
	
    NSString *numberString = [[NSString alloc] initWithCString:cString encoding:nsEncoding];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    
    return [formatter numberFromString:numberString];
}

@end
