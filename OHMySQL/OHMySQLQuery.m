//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLQuery.h"

@interface OHMySQLQuery ()

@property (nonatomic, strong, readwrite) OHMySQLUser *user;

@end

@implementation OHMySQLQuery

- (instancetype)initWithUser:(OHMySQLUser *)user {
    if (self = [super init]) {
        _user = user;
    }
    
    return self;
}

- (instancetype)initWithUser:(OHMySQLUser *)user queryString:(NSString *)query {
    if (self = [self initWithUser:user]) {
        _queryString = query;
    }
    
    return self;
}

@end
