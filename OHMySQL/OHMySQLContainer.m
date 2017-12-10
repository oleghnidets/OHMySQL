//  Created by Oleg Hnidets on 6/20/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLContainer.h"
#import "OHMySQLQueryContext.h"

static OHMySQLContainer *_sharedManager = nil;

@implementation OHMySQLContainer

+ (OHMySQLContainer *)sharedManager {
	return [self sharedContainer];
}

+ (OHMySQLContainer *)sharedContainer {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [OHMySQLContainer new];
	});

	return _sharedManager;
}

- (OHMySQLStoreCoordinator *)storeCoordinator {
    return self.mainQueryContext.storeCoordinator;
}

@end
