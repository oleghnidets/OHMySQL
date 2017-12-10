//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import "OHTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface OHTask (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *taskId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *taskDescription;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSData *taskData;
@property (nullable, nonatomic, copy) NSNumber *decimalValue;

@end

NS_ASSUME_NONNULL_END
