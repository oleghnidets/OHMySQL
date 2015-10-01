//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHViewController.h"

#import "OHMySQL.h"

@interface OHViewController ()

@end

@implementation OHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *startDate  = [NSDate date];
    //--Code here.
    NSLog(@"Time execution: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
}

@end
