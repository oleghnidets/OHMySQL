//  Created by Oleg Hnidets on 10/16/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "NSData+OHSerialization.h"
#import "NSString+OHSerialization.h"

@implementation NSData (OHSerialization)

+ (id)serializeFromCString:(const char *)cString defaultValue:(const char *)defaultValue canBeNull:(BOOL)canBeNull encoding:(CharsetEncoding)encoding {
	id string = [NSString serializeFromCString:cString defaultValue:defaultValue canBeNull:canBeNull encoding:encoding];

	if (string && (string != [NSNull null])) {
		NSStringEncoding nsEncoding = NSStringEncodingFromCharsetEncoding(encoding);
		return [(NSString *)string dataUsingEncoding:nsEncoding];
	}

	return [NSNull null];
}

@end
