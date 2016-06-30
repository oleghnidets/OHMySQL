//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHListViewController.h"
#import "OHEditViewController.h"

#import "OHMySQL.h"
#import "AppDelegate.h"
#import "OHTasksFacade.h"

#import "OHTask.h"

#import "OHTaskTableViewCell.h"

@interface OHListViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSMutableArray<OHTask *> *listOfTasks;
@property (nonatomic, strong) NSMutableArray<OHTask *> *filteredTasks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *allItemsController;

@end

@implementation OHListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureResultsController];
    [self configureMySQL];
    
    [OHTasksFacade loadTasks:^(NSArray *tasks) {
        [self.allItemsController performFetch:nil];
    } failure:^{
        // handle
    }];
}

- (void)configureResultsController {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([OHTask class])];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:mysql_key(taskId) ascending:NO]];
    self.allItemsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:appDelegate.managedObjectContext
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:nil];
    self.allItemsController.delegate = self;
}

- (void)configureMySQL {
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
    [OHMySQLManager sharedManager].mainQueryContext = queryContext;
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    OHTask *task = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([OHTask class])
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    task.name = @"Something important"; 
    task.taskDescription = [@"Do something important: " stringByAppendingFormat:@"%@", [NSDate date]];
    task.status = @(rand() % 2);
    [OHTasksFacade addTask:task :nil failure:^{
        // Handle
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allItemsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OHTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OHTaskCellIdentifier" forIndexPath:indexPath];
    [cell configureWithTask:self.allItemsController.fetchedObjects[indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OHEditViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OHEditViewController"];
    viewController.task = self.allItemsController.fetchedObjects[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        OHTask *task = self.allItemsController.fetchedObjects[indexPath.row];
        [OHTasksFacade deleteTask:task :nil failure:^{
            // Handle
        }];
    }
}

#pragma mark - NSFetchedResultsController

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [NSException raise:@"Not implemented" format:@"NSFetchedResultsChangeMove is not implemented for sections on screen %@", [self class]];
            break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    // Fix for iOS8. Xcode 7 has a bug with FRC.
    if ([indexPath isEqual:newIndexPath]) {
        return ;
    }
    
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove: {
            //[self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}

@end
