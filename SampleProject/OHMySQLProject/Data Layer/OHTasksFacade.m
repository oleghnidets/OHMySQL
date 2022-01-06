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
    NSArray *tasks = [OHMySQLContainer.shared.mainQueryContext executeQueryRequestAndFetchResult:query error:&error];
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
    childContext.parentQueryContext = OHMySQLContainer.shared.mainQueryContext;
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
    [OHMySQLContainer.shared.mainQueryContext updateObject:task];
    NSError *error;
    if (![OHMySQLContainer.shared.mainQueryContext save:&error]) {
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
    [OHMySQLContainer.shared.mainQueryContext deleteObject:task];
    NSError *error;
    if (![OHMySQLContainer.shared.mainQueryContext save:&error]) {
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
