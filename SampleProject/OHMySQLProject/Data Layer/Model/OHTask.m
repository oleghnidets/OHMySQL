//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import "OHTask.h"

@implementation OHTask

- (NSDictionary *)mappingDictionary {
    return @{ mysql_key(taskId) : @"id",
              mysql_key(name) : @"name",
              mysql_key(taskDescription) : @"description",
              mysql_key(status) : @"status",
			  mysql_key(taskData) : @"data",
			  mysql_key(decimalValue) : @"preciseValue",
			  };
}

- (NSString *)mySQLTable {
    return @"tasks";
}

- (NSString *)indexKey {
    return mysql_key(taskId);
}

- (NSString *)primaryKey {
    return mysql_key(taskId);
}

@end
