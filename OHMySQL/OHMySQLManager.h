//  Created by Oleg on 6/20/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@class OHMySQLQueryContext, OHMySQLStoreCoordinator;

/// Represents a main context and store coordinator.
@interface OHMySQLManager : NSObject

//! Shared manager.
+ (nonnull OHMySQLManager *)sharedManager;

//! Single context that is used in the app. Context should be set by a user of this class.
@property (nonatomic, strong, nullable) OHMySQLQueryContext *mainQueryContext;

//! Single store coordinator.
@property (nonatomic, strong, readonly, nullable) OHMySQLStoreCoordinator *storeCoordinator;

@end
