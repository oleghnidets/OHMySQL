//  Created by Oleg Hnidets on 1/10/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "NSString+OHSerialization.h"


@implementation NSString (OHSerialization)

+ (id)serializeFromCString:(const char *)cString defaultValue:(const char *)defaultValue canBeNull:(BOOL)canBeNull encoding:(CharsetEncoding)encoding {
	NSStringEncoding nsEncoding = NSStringEncodingFromCharsetEncoding(encoding);
	
    if (cString) {
        return [[NSString alloc] initWithCString:cString encoding:nsEncoding];
    } else if (!cString && defaultValue) {
        return [[NSString alloc] initWithCString:defaultValue encoding:nsEncoding];
    } else if (!cString && canBeNull == NO) {
        return @"";
    }
    
    return [NSNull null];
}

@end
