//  Created by Oleg Gnidets on 2/22/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHCharsetEncoding.h"

@interface NSString (Escaping)

- (nonnull NSString *)escapedUsingEncoding:(CharsetEncoding)encoding;

@end
