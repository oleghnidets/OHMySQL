//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

@import MySQL;

#import "OHMySQLSerialization.h"

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
