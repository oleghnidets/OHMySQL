//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@class OHMySQLUser;

@interface OHMySQLQuery : NSObject

@property (copy, nonnull) NSString *queryString;

- (nonnull instancetype)initWithQueryString:(nonnull NSString *)query;

@end
