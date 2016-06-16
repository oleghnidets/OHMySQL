//  Created by Oleg on 6/16/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@import CoreGraphics.CGBase;

@interface OHMySQLTimeline : NSObject

@property (nonatomic, assign) CFAbsoluteTime serializationDuration;

@property (nonatomic, assign) CFAbsoluteTime queryStartTime;
@property (nonatomic, assign) CFAbsoluteTime queryDuration;

@end
