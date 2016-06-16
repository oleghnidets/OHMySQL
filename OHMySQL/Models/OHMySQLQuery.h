//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHMySQLTimeline.h"

@interface OHMySQLQuery : NSObject

@property (strong, nonnull) OHMySQLTimeline *timeline;
@property (nonatomic, copy, nonnull) NSString *queryString;

- (nonnull instancetype)initWithQueryString:(nonnull NSString *)query;

@end
