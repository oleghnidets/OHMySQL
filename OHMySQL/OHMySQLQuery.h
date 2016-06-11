//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@class OHMySQLUser;

@interface OHMySQLQuery : NSObject

@property (strong, readonly) OHMySQLUser *user;
@property (copy) NSString *queryString;

- (instancetype)initWithUser:(OHMySQLUser *)user;
- (instancetype)initWithUser:(OHMySQLUser *)user queryString:(NSString *)query;

@end
