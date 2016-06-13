//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@class OHMySQLUser;

@interface OHMySQLQuery : NSObject

@property (strong, readonly, nullable) OHMySQLUser *user;
@property (copy, nonnull) NSString *queryString;

- (nonnull instancetype)initWithUser:(nonnull OHMySQLUser *)user;
- (nonnull instancetype)initWithUser:(nonnull OHMySQLUser *)user queryString:(nonnull NSString *)query;

@end
