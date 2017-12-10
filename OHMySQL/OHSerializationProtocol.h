//  Created by Oleg Hnidets on 1/10/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHCharsetEncoding.h"

@protocol OHSerialization <NSObject>

+ (nonnull id)serializeFromCString:(nullable const char *)cString
                      defaultValue:(nullable const char *)defaultValue
                         canBeNull:(BOOL)canBeNull
						  encoding:(CharsetEncoding)encoding;

@end
