//  Created by Oleg Hnidets on 9/29/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHCharsetEncoding.h"

/// Responsible for seralization of responses.
@interface OHMySQLSerialization : NSObject

/**
 *  Serialize C string into an object. Takes into account default value of the fields.
 *
 *  @param cString C array of bytes.
 *  @param field Representation of one row of data.
 *
 *  @return Object of NSString or NSSNumber classes, or [NSNull null] if the value can be 'NULL'. 
 */
+ (nonnull id)objectFromCString:(nullable const char *)cString
						  field:(nonnull const void *)field
					   encoding:(CharsetEncoding)encoding;

@end
