//  Created by Oleg Hnidets on 2/5/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

#import "XCTestCase+INSERT.h"
#import "XCTestCase+Database_Basic.h"

@implementation XCTestCase (INSERT)

- (OHTestPerson *)createPersonWithSet:(NSDictionary *)insertSet in:(NSString *)tableName {
    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory INSERT:tableName
                                                                       set:insertSet];
    [self.mainQueryContext executeQueryRequest:queryRequest error:nil];
    
    NSString *conditionString = [NSString stringWithFormat:@"id=%@", [self.mainQueryContext lastInsertID]];
    OHMySQLQueryRequest *firstRequest = [OHMySQLQueryRequestFactory SELECTFirst:tableName
                                                                      condition:conditionString];
    
    NSDictionary *response = [self.mainQueryContext executeQueryRequestAndFetchResult:firstRequest error:nil].firstObject;
    
    OHTestPerson *person = [OHTestPerson new];
    person.ID = response[@"id"];
    person.name = response[@"name"];
    person.age = response[@"age"];
    
    return person;
}

@end
