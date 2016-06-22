//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHViewController.h"

#import "AppDelegate.h"
#import "OHMySQL.h"

#import "OHTask.h"
#import "NSObject+Mapping.h"
#import "OHTaskTableViewCell.h"

@interface OHViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<OHTask *> *listOfTasks;
@property (nonatomic, copy) NSArray<OHTask *> *tasks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation OHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listOfTasks = [NSMutableArray array];
    
    OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root"
                                                     password:@"root"
                                                   serverName:@"localhost"
                                                       dbName:@"sample"
                                                         port:3306
                                                       socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
    OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
    [coordinator connect];
    
    OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
    queryContext.storeCoordinator = coordinator;
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tasks" condition:nil];
    
    [OHMySQLManager sharedManager].mainQueryContext = queryContext;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSArray *tasks = [queryContext executeQueryRequestAndFetchResult:query error:nil];
    
    NSLog(@"%f", query.timeline.queryDuration);
    NSLog(@"Seralization duration: %f", query.timeline.serializationDuration);
    NSLog(@"Time execution: %f", query.timeline.totalTime);
    
    NSString *entityName = NSStringFromClass([OHTask class]);
    for (NSDictionary *taskDict in tasks) {
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        fetch.entity = entityDescription;
        fetch.predicate = [NSPredicate predicateWithFormat:@"(taskId == %@)", taskDict[@"id"]];
        NSArray *fetchedObjects = [context executeFetchRequest:fetch error:nil];
        
        OHTask *task = fetchedObjects.count ? fetchedObjects.firstObject : [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        [task mapFromResponse:taskDict];
        [self.listOfTasks addObject:task];
    }
    
    self.tasks = self.listOfTasks;
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSAssert(NO, @"Error saving context: %@\n%@", error.localizedDescription, error.userInfo);
    }
    
    
    [self.tableView reloadData];
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    OHTask *task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([OHTask class])
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    task.name = @"Something important";
    task.taskDescription = [@"Do something important: " stringByAppendingFormat:@"%@", [NSDate date]];
    task.status = @0;
    [[OHMySQLManager sharedManager].mainQueryContext insertObject:task];
    [[OHMySQLManager sharedManager].mainQueryContext save:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OHTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OHTaskCellIdentifier" forIndexPath:indexPath];
    [cell configureWithTask:self.tasks[indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        OHTask *task = self.tasks[indexPath.row];
        [[OHMySQLManager sharedManager].mainQueryContext deleteObject:task];
        if ([[OHMySQLManager sharedManager].mainQueryContext save:nil]) {
            NSMutableArray *updatedTasks = [self.tasks mutableCopy];
            [updatedTasks removeObject:task];
            self.tasks = updatedTasks;
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - UITableViewDelegate

#pragma mark - Actions

- (IBAction)switchedSegmentControl:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.tasks = self.listOfTasks;
    } else if (sender.selectedSegmentIndex == 1) {
        self.tasks = [self.listOfTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status == %@", @1]];
    } else {
        self.tasks = [self.listOfTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status == %@", @0]];
    }
    
    [self.tableView reloadData];
}

@end
