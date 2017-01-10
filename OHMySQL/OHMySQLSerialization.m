//  Created by Oleg on 9/29/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLSerialization.h"
#import <mysql.h>

#import "NSNumber+OHSerialization.h"
#import "NSString+OHSerialization.h"


@implementation OHMySQLSerialization

+ (id)objectFromCString:(const char *)cString field:(const void *)pointer {
    MYSQL_FIELD *field = (MYSQL_FIELD *)pointer;
    // Indicates whether the value can be 'NULL'.
    BOOL canBeNull = !IS_NOT_NULL(field->flags);
    BOOL isNumber = IS_NUM(field->type);
    BOOL hasDefaultValue = (field->def_length > 0 && field->def != nil);
    char *defaultaValue = hasDefaultValue ? field->def : nil;
    
    if (isNumber) {
        return [NSNumber serializeFromCString:cString
                                 defaultValue:defaultaValue
                                    canBeNull:canBeNull];
    }
    
    
    return [NSString serializeFromCString:cString
                             defaultValue:defaultaValue
                                canBeNull:canBeNull];
}

@end
