//  Created by Oleg Hnidets on 6/16/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#ifdef DEBUG
#define OHLog(frmt, ...) NSLog(@"%s -[INFO] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
#define OHLog(frmt, ...) ;
#endif

#ifdef DEBUG
#define OHLogError(frmt, ...) NSLog(@"%s -[ERROR] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
#define OHLogError(frmt, ...) ;
#endif

#ifdef DEBUG
#define OHLogWarn(frmt, ...) NSLog(@"%s -[WARNING] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
#define OHLogWarn(frmt, ...) ;
#endif
