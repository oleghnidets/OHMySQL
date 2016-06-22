//  Created by Oleg on 6/20/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLManager.h"
#import "OHMySQLQueryContext.h"

static OHMySQLManager *_sharedManager = nil;

@implementation OHMySQLManager

+ (OHMySQLManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [OHMySQLManager new];
    });
    
    return _sharedManager;
}

- (OHMySQLStoreCoordinator *)storeCoordinator {
    return self.mainQueryContext.storeCoordinator;
}

@end
