//  Created by Oleg Gnidets on 2/7/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "OHCharsetEncoding.h"

NSString *_Nullable MySQLCharsetForEncoding(CharsetEncoding encoding) {
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
		case CharsetEncodingUTF8MB4:
			return @"utf8mb4";
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

NSStringEncoding NSStringEncodingFromCharsetEncoding(CharsetEncoding encoding) {
	CFStringEncoding cfEncoding;
	
	switch (encoding) {
		case CharsetEncodingBig5:
			cfEncoding = kCFStringEncodingBig5;
			break;
		case CharsetEncodingCP850:
			cfEncoding = kCFStringEncodingDOSLatin1;
			break;
		case CharsetEncodingKOI8_R:
			cfEncoding = kCFStringEncodingKOI8_R;
			break;
		case CharsetEncodingLatin1:
			cfEncoding = kCFStringEncodingWindowsLatin1;
			break;
		case CharsetEncodingLatin2:
			cfEncoding = kCFStringEncodingISOLatin2;
			break;
		case CharsetEncodingASCII:
			cfEncoding = kCFStringEncodingASCII;
			break;
		case CharsetEncodingUJIS:
			cfEncoding = kCFStringEncodingEUC_JP;
			break;
		case CharsetEncodingSJIS:
			cfEncoding = kCFStringEncodingShiftJIS;
			break;
		case CharsetEncodingHebrew:
			cfEncoding = kCFStringEncodingISOLatinHebrew;
			break;
		case CharsetEncodingEUCKR:
			cfEncoding = kCFStringEncodingEUC_KR;
			break;
		case CharsetEncodingKOI8U:
			cfEncoding = kCFStringEncodingKOI8_U;
			break;
		case CharsetEncodingGreek:
			cfEncoding = kCFStringEncodingISOLatinGreek;
			break;
		case CharsetEncodingLatin5:
			cfEncoding = kCFStringEncodingISOLatin5;
			break;
		case CharsetEncodingUTF8:
			cfEncoding = kCFStringEncodingUTF8;
			break;
		case CharsetEncodingUTF8MB4:
			cfEncoding = kCFStringEncodingUTF8;
			break;
		case CharsetEncodingCP866:
			cfEncoding = kCFStringEncodingDOSRussian;
			break;
		case CharsetEncodingMacRoman:
			cfEncoding = kCFStringEncodingMacRoman;
			break;
		case CharsetEncodingCP852:
			cfEncoding = kCFStringEncodingDOSLatin2;
			break;
		case CharsetEncodingLatin7:
			cfEncoding = kCFStringEncodingISOLatin7;
			break;
		case CharsetEncodingCP1250:
			cfEncoding = kCFStringEncodingWindowsLatin2;
			break;
		case CharsetEncodingCP1251:
			cfEncoding = kCFStringEncodingWindowsCyrillic;
			break;
		case CharsetEncodingUTF16:
			cfEncoding = kCFStringEncodingUTF16;
			break;
		case CharsetEncodingUTF16LE:
			cfEncoding = kCFStringEncodingUTF16LE;
			break;
		case CharsetEncodingCP1256:
			cfEncoding = kCFStringEncodingWindowsArabic;
			break;
		case CharsetEncodingUTF32:
			cfEncoding = kCFStringEncodingUTF32;
			break;
		case CharsetEncodingCP932:
			cfEncoding = kCFStringEncodingDOSJapanese;
			break;
		case CharsetEncodingGB2312:
			cfEncoding = kCFStringEncodingGB_2312_80;
			break;
	}
	
	return CFStringConvertEncodingToNSStringEncoding(cfEncoding);
}
