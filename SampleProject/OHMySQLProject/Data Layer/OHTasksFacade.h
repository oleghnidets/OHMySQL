//  Created by Oleg on 6/27/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;

typedef void(^OHSuccess)(void);
typedef void(^OHGetSuccess)(NSArray *tasks);
typedef void(^OHFailure)(void);

@class OHTask;

@interface OHTasksFacade : NSObject

+ (void)loadTasks:(OHGetSuccess)success failure:(OHFailure)failure;

+ (void)addTask:(OHTask *)task :(OHSuccess)success failure:(OHFailure)failure;

+ (void)update:(OHTask *)task :(OHSuccess)success failure:(OHFailure)failure;

+ (void)deleteTask:(OHTask *)task :(OHSuccess)success failure:(OHFailure)failure;

@end
