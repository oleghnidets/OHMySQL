//  Created by Oleg Hnidets on 6/16/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLTimeline.h"

@interface OHMySQLTimeline ()

@property (nonatomic, assign, readwrite) CFAbsoluteTime totalTime;

@end

@implementation OHMySQLTimeline

- (CFAbsoluteTime)totalTime {
    _totalTime = self.queryDuration + self.serializationDuration;
    return _totalTime;
}

@end
