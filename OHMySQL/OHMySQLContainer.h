//  Created by Oleg Hnidets on 6/20/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@class OHMySQLQueryContext, OHMySQLStoreCoordinator;

/// Represents a main context and store coordinator.
@interface OHMySQLContainer : NSObject

/// Shared manager.
/// @warning Will be removed in the future.
+ (nonnull OHMySQLContainer *)sharedManager __deprecated;

/// Shared container
@property (class, strong, readonly, nonnull) OHMySQLContainer *sharedContainer;

/// Single context that is used in the app. Context should be set by a user of this class.
@property (nonatomic, strong, nullable) OHMySQLQueryContext *mainQueryContext;

/// Single store coordinator.
@property (nonatomic, strong, readonly, nullable) OHMySQLStoreCoordinator *storeCoordinator;

@end

@compatibility_alias OHMySQLManager OHMySQLContainer;
