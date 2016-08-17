//  Created by Oleg on 8/15/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHMySQL.h"

@interface OHTestPerson : NSObject<OHMappingProtocol>

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;
@property (nonatomic, strong) NSNumber *age;

@end

@interface OHTestPerson (MockObject)

+ (instancetype)mockObject;

@end
