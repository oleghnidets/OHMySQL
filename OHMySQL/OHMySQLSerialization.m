//  Created by Oleg Hnidets on 9/29/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLSerialization.h"
#import "lib/include/mysql.h"

#import "NSData+OHSerialization.h"
#import "NSNumber+OHSerialization.h"
#import "NSString+OHSerialization.h"

// According to documentation:
// IS_BLOB(flags) - 'True if this field is a BLOB or TEXT (deprecated; test field->type instead)'.
// One more remark: TEXT type is treated as BLOB as well.
#define IS_TYPE_BLOB(v) (v && field->type == MYSQL_TYPE_BLOB)

@implementation OHMySQLSerialization

+ (id)objectFromCString:(const char *)cString field:(const void *)pointer encoding:(CharsetEncoding)encoding {
	MYSQL_FIELD *field = (MYSQL_FIELD *)pointer;
	// Indicates whether the value can be 'NULL'.
	BOOL canBeNull = !IS_NOT_NULL(field->flags);
	BOOL isNumber = IS_NUM(field->type);
	BOOL isBlob = IS_TYPE_BLOB(field->type);
	BOOL hasDefaultValue = (field->def_length > 0 && field->def != nil);
	char *defaultaValue = hasDefaultValue ? field->def : nil;

	Class<OHSerialization> class;

	if (isBlob) {
		class = [NSData class];
	} else if (isNumber) {
		class = [NSNumber class];
	} else {
		class = [NSString class];
	}

	return [class serializeFromCString:cString
						  defaultValue:defaultaValue
							 canBeNull:canBeNull
							  encoding:encoding];
}

@end
