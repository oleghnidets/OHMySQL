//  Created by Oleg Hnidets on 10/31/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@interface NSObject (Mapping)

- (void)mapFromResponse:(nonnull NSDictionary *)response;
- (nullable NSString *)indexKeyCondition;
- (nullable NSDictionary *)mapObject;

@end
