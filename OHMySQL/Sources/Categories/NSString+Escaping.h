//  Created by Oleg Hnidets on 2/22/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHCharsetEncoding.h"

@interface NSString (Escaping)

/**
 The method creates a legal SQL string for use in an SQL statement.

 @note https://dev.mysql.com/doc/refman/5.7/en/string-literals.html#character-escape-sequences
 @param encoding Character encoding type.
 @return Escaped string.
 */
- (nonnull NSString *)escapedUsingEncoding:(CharsetEncoding)encoding;

@end
