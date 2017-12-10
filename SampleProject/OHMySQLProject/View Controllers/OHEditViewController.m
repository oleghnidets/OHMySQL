//  Created by Oleg Hnidets on 6/29/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#import "OHEditViewController.h"
#import "OHTask.h"
#import "OHMySQL.h"
#import "OHTasksFacade.h"

@interface OHEditViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation OHEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.task.taskDescription;
}

- (IBAction)saveButtonPressed {
    self.task.taskDescription = self.textView.text;
    
    [OHTasksFacade update:self.task :^{
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        
    }];
}

@end
