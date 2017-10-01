//  Created by Oleg on 6/27/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import "OHTasksFacade.h"

#import "AppDelegate.h"
#import "OHMySQL.h"

#import "OHTask.h"

@implementation OHTasksFacade

+ (NSManagedObjectContext *)context {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

+ (void)loadTasks:(OHGetSuccess)success failure:(OHFailure)failure {
    NSString *entityName = NSStringFromClass([OHTask class]);
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = entityDescription;
    
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tasks" condition:nil];
    NSError *error = nil;
    NSArray *tasks = [[OHMySQLContainer sharedContainer].mainQueryContext executeQueryRequestAndFetchResult:query error:&error];
    // For example offline mode.
    if (error) {
        NSArray *_tasks = [self.context executeFetchRequest:fetch error:nil];
        success(_tasks);
        return ;
    }
    
    NSLog(@"%f", query.timeline.queryDuration);
    NSLog(@"Seralization duration: %f", query.timeline.serializationDuration);
    NSLog(@"Time execution: %f", query.timeline.totalTime);
    
    NSMutableArray *listOfTasks = [NSMutableArray array];
    for (NSDictionary *taskDict in tasks) {
        fetch.predicate = [NSPredicate predicateWithFormat:@"taskId == %@", taskDict[@"id"]];
        NSArray *fetchedObjects = [self.context executeFetchRequest:fetch error:nil];
        OHTask *task = fetchedObjects.count ? fetchedObjects.firstObject : [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
        [task mapFromResponse:taskDict];
        [listOfTasks addObject:task];
    }
    
    if (![self.context save:&error]) {
        OHLogError(@"Error saving context: %@\n%@", error.localizedDescription, error.userInfo);
        !failure ?: failure();
        return ;
    }
    
    success(listOfTasks);
}

+ (void)addTask:(OHTask *)task :(OHSuccess)success failure:(OHFailure)failure {
    OHMySQLQueryContext *childContext = [OHMySQLQueryContext new];
    childContext.parentQueryContext = [OHMySQLContainer sharedContainer].mainQueryContext;
    [childContext insertObject:task];
    
    [childContext saveToPersistantStore:^(NSError *error) {
        if (error) {
            !failure ?: failure();
            return ;
        }
        
        if (![task.managedObjectContext save:nil]) {
            !failure ?: failure();
            return ;
        }
        
        !success ?: success();
    }];
}

+ (void)update:(OHTask *)task :(OHSuccess)success failure:(OHFailure)failure {
    [[OHMySQLContainer sharedContainer].mainQueryContext updateObject:task];
    NSError *error;
    if (![[OHMySQLContainer sharedContainer].mainQueryContext save:&error]) {
        !failure ?: failure();
        return ;
    }
    
    if (![task.managedObjectContext save:nil]) {
        !failure ?: failure();
        return ;
    }
    
    !success ?: success();
}

+ (void)deleteTask:(OHTask *)task :(OHSuccess)success failure:(OHFailure)failure {
    [[OHMySQLContainer sharedContainer].mainQueryContext deleteObject:task];
    NSError *error;
    if (![[OHMySQLContainer sharedContainer].mainQueryContext save:&error]) {
        !failure ?: failure();
        return ;
    }
    
    [task.managedObjectContext deleteObject:task];
    if (![task.managedObjectContext save:nil]) {
        !failure ?: failure();
        return ;
    }
    
    !success ?: success();
}

@end
