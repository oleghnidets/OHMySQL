//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@interface NSObject (Mapping)

- (void)mapFromResponse:(nonnull NSDictionary *)response;
- (nullable NSString *)indexKeyCondition;
- (nullable NSDictionary *)mapObject;

@end
