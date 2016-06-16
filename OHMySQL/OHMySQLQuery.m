//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLQuery.h"

@interface OHMySQLQuery ()
@end

@implementation OHMySQLQuery

- (nonnull instancetype)initWithQueryString:(nonnull NSString *)query {
    NSParameterAssert(query);
    if (self = [self init]) {
        _queryString = query;
    }
    
    return self;
}

@end
