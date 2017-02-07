//  Created by Oleg Gnidets on 2/7/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "OHCharsetEncoding.h"

@implementation OHCharsetEncoding

+ (NSString *)charsetForEncoding:(CharsetEncoding)encoding {
	switch (encoding) {
		case CharsetEncodingBig5:
			return @"big5";
		case CharsetEncodingCP850:
			return @"cp850";
		case CharsetEncodingKOI8_R:
			return @"koi8r";
		case CharsetEncodingLatin1:
			return @"latin1";
		case CharsetEncodingLatin2:
			return @"latin2";
		case CharsetEncodingASCII:
			return @"ascii";
		case CharsetEncodingUJIS:
			return @"ujis";
		case CharsetEncodingSJIS:
			return @"sjis";
		case CharsetEncodingHebrew:
			return @"hebrew";
		case CharsetEncodingEUCKR:
			return @"euckr";
		case CharsetEncodingKOI8U:
			return @"koi8u";
		case CharsetEncodingGreek:
			return @"greek";
		case CharsetEncodingLatin5:
			return @"latin5";
		case CharsetEncodingUTF8:
			return @"utf8";
		case CharsetEncodingCP866:
			return @"cp866";
		case CharsetEncodingMacRoman:
			return @"macroman";
		case CharsetEncodingCP852:
			return @"cp852";
		case CharsetEncodingLatin7:
			return @"latin7";
		case CharsetEncodingCP1250:
			return @"cp1250";
		case CharsetEncodingCP1251:
			return @"cp1251";
		case CharsetEncodingUTF16:
			return @"utf16";
		case CharsetEncodingUTF16LE:
			return @"utf16le";
		case CharsetEncodingCP1256:
			return @"cp1256";
		case CharsetEncodingUTF32:
			return @"utf32";
		case CharsetEncodingCP932:
			return @"cp932";
		case CharsetEncodingGB2312:
			return @"gb2312";
	}
}

@end
