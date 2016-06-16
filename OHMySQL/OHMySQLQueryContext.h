//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
@class OHMySQLQuery, OHMySQLStoreCoordinator;

@interface OHMySQLQueryContext : NSObject

@property (strong, nonnull) OHMySQLStoreCoordinator *storeCoordinator;

- (void)executeQuery:(nonnull OHMySQLQuery *)query error:(NSError *_Nullable*_Nullable)error;

- (nullable NSArray<NSDictionary<NSString *,id> *> *)executeQueryAndFetchResult:(nonnull OHMySQLQuery *)query
                                                                 error:(NSError *_Nullable*_Nullable)error;

- (nullable NSArray<NSDictionary<NSString *, id> *> *)fetchResult;

@end
