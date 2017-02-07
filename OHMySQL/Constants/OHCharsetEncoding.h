//  Created by Oleg Gnidets on 2/7/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(CFStringEncoding, CharsetEncoding) {
	CharsetEncodingBig5 = kCFStringEncodingBig5,
	CharsetEncodingCP850 = kCFStringEncodingDOSLatin1,
	CharsetEncodingKOI8_R = kCFStringEncodingKOI8_R,
	CharsetEncodingLatin1 = kCFStringEncodingWindowsLatin1,
	CharsetEncodingLatin2 = kCFStringEncodingISOLatin2,
	CharsetEncodingASCII = kCFStringEncodingASCII,
	CharsetEncodingUJIS = kCFStringEncodingEUC_JP,
	CharsetEncodingSJIS = kCFStringEncodingShiftJIS,
	CharsetEncodingHebrew = kCFStringEncodingISOLatinHebrew,
	CharsetEncodingEUCKR = kCFStringEncodingEUC_KR,
	CharsetEncodingKOI8U = kCFStringEncodingKOI8_U,
	CharsetEncodingGreek = kCFStringEncodingISOLatinGreek,
	CharsetEncodingLatin5 = kCFStringEncodingISOLatin5,
	CharsetEncodingUTF8 = kCFStringEncodingUTF8,
	CharsetEncodingCP866 = kCFStringEncodingDOSRussian,
	CharsetEncodingMacRoman = kCFStringEncodingMacRoman,
	CharsetEncodingCP852 = kCFStringEncodingDOSLatin2,
	CharsetEncodingLatin7 = kCFStringEncodingISOLatin7,
	CharsetEncodingCP1250 = kCFStringEncodingWindowsLatin2,
	CharsetEncodingCP1251 = kCFStringEncodingWindowsCyrillic,
	CharsetEncodingUTF16 = kCFStringEncodingUTF16,
	CharsetEncodingUTF16LE = kCFStringEncodingUTF16LE,
	CharsetEncodingCP1256 = kCFStringEncodingWindowsArabic,
	CharsetEncodingUTF32 = kCFStringEncodingUTF32,
	CharsetEncodingCP932 = kCFStringEncodingDOSJapanese,
	CharsetEncodingGB2312 = kCFStringEncodingGB_2312_80,
};


@interface OHCharsetEncoding : NSObject

+ (nullable NSString *)charsetForEncoding:(CharsetEncoding)encoding;

@end
