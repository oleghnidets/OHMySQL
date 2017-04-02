//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "OHMappingProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OHTask : NSManagedObject<OHMappingProtocol>

@end

NS_ASSUME_NONNULL_END

#import "OHTask+CoreDataProperties.h"
