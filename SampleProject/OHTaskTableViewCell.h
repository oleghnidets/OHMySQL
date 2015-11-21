//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHTask;

@interface OHTaskTableViewCell : UITableViewCell

- (void)configureWithTask:(OHTask *)task;

@end
