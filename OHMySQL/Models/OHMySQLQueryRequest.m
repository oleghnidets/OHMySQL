//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLQueryRequest.h"

@interface OHMySQLQueryRequest ()
@end

@implementation OHMySQLQueryRequest

- (nonnull instancetype)initWithQueryString:(nonnull NSString *)query {
    NSParameterAssert(query);
    if (self = [self init]) {
        _queryString = query;
        _timeline = [OHMySQLTimeline new];
    }
    
    return self;
}

@end
