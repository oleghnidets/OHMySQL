//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHConstants.h"

@interface NSObject (Mapping)

- (OHResultErrorType)insert;
- (OHResultErrorType)update;
- (OHResultErrorType)updateWithCondition:(NSString *)condition;
- (OHResultErrorType)deleteObject;

@end
