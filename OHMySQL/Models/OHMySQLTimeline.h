//  Created by Oleg on 6/16/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@import CoreGraphics.CGBase;

@interface OHMySQLTimeline : NSObject

//! The time when the serialization was completed.
@property (nonatomic, assign) CFAbsoluteTime serializationDuration;

//! The time the request was initialized.
@property (nonatomic, assign) CFAbsoluteTime queryStartTime;

//! The time interval from the time the request started to the time the request completed.
@property (nonatomic, assign) CFAbsoluteTime queryDuration;

@end
