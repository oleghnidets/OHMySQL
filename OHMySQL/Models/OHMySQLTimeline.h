//  Created by Oleg Hnidets on 6/16/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@import CoreGraphics.CGBase;

/// An instance of OHMySQLTimeline represents lifecycle of the query.
@interface OHMySQLTimeline : NSObject

/// The time when the serialization was completed.
@property (nonatomic, assign) CFAbsoluteTime serializationDuration;

/// The time interval from the time the request started to the time the request completed.
@property (nonatomic, assign) CFAbsoluteTime queryDuration;

/// The time interval in seconds from the time the request started to the time response serialization completed.
@property (nonatomic, assign, readonly) CFAbsoluteTime totalTime;

@end
