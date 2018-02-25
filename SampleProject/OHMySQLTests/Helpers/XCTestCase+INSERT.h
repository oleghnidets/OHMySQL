//  Created by Oleg Hnidets on 2/5/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

@import XCTest;
#import "OHTestPerson.h"

@interface XCTestCase (INSERT)

- (OHTestPerson *)createPersonWithSet:(NSDictionary *)insertSet in:(NSString *)tableName;

@end
