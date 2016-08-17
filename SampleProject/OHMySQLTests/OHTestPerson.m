//  Created by Oleg on 8/15/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import "OHTestPerson.h"

@implementation OHTestPerson

- (NSString *)primaryKey {
    return mysql_key(ID);
}

- (NSString *)mySQLTable {
    return @"TestTable";
}

- (NSDictionary *)mappingDictionary {
    return @{ mysql_key(ID): @"id",
              mysql_key(name): @"name",
              mysql_key(surname): @"surname",
              mysql_key(age): @"age" };
}

@end

@implementation OHTestPerson (MockObject)

+ (instancetype)mockObject {
    OHTestPerson *person = [OHTestPerson new];
    person.name    = @"Mock name";
    person.surname = @"Mock surname";
    person.age     = @22;
    return person;
}

@end
