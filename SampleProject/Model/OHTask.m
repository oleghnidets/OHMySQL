//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHTask.h"

@implementation OHTask

- (NSDictionary *)mappingDictionary {
    return @{ mysql_key(taskId) : @"id",
              mysql_key(name) : @"name",
              mysql_key(taskDescription) : @"description",
              mysql_key(status) : @"status", };
}

- (NSString *)mySQLTable {
    return @"tasks";
}

- (NSString *)indexKey {
    return mysql_key(taskId);
}

@end
