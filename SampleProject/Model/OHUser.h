//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMappingProtocol.h"

@interface OHUser : NSObject<OHMappingProtocol>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastName;

@end
