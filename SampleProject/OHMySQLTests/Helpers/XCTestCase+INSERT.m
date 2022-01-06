//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
