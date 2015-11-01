//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHViewController.h"

#import "OHMySQL.h"

#import "OHUser.h"
#import "NSObject+Mapping.h"

@interface OHViewController ()

@end

@implementation OHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *startDate  = [NSDate date];
    OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root"
                                                     password:@"root"
                                                   serverName:@"localhost"
                                                       dbName:@"sample"
                                                         port:3306
                                                       socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
    [[OHMySQLManager sharedManager] connectWithUser:user];
    
    OHUser *user1 = [[OHUser alloc] init];
    user1.name = @"Oleg";
    user1.lastName = @"Hnidets";
    
    [user1 insert];
    user1.name = @"Mr Oleg";
    [user1 update];
    
    
    //--Code here.
    NSLog(@"Time execution: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
}

@end
