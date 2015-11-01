//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import "OHUser.h"

@implementation OHUser

- (NSDictionary *)mappingDictionary {
    return @{ mysql_key(userId) : @"id",
              mysql_key(name) : @"userName",
              mysql_key(lastName) : @"userLastName", };
}

- (NSString *)mySQLTable {
    return @"students";
}

- (NSString *)indexKey {
    return mysql_key(userId);
}

@end
