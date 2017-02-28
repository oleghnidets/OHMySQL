//  Created by Oleg Gnidets on 2/7/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;

/**
 Describes available character sets.

 - CharsetEncodingBig5: Big5 Traditional Chinese
 - CharsetEncodingCP850: DOS West European
 - CharsetEncodingKOI8_R: KOI8-R Relcom Russian
 - CharsetEncodingLatin1: cp1252 West European
 - CharsetEncodingLatin2: ISO 8859-2 Central European
 - CharsetEncodingASCII: US ASCII
 - CharsetEncodingUJIS: EUC-JP Japanese
 - CharsetEncodingSJIS: Shift-JIS Japanese
 - CharsetEncodingHebrew: ISO 8859-8 Hebrew
 - CharsetEncodingEUCKR: EUC-KR Korean
 - CharsetEncodingKOI8U: KOI8-U Ukrainian
 - CharsetEncodingGreek: ISO 8859-7 Greek
 - CharsetEncodingLatin5: ISO 8859-9 Turkish
 - CharsetEncodingUTF8: UTF-8 Unicode
 - CharsetEncodingCP866: DOS Russian
 - CharsetEncodingMacRoman: Mac West European
 - CharsetEncodingCP852: DOS Central European
 - CharsetEncodingLatin7: ISO 8859-13 Baltic
 - CharsetEncodingCP1250: Windows Central European
 - CharsetEncodingCP1251: Windows Cyrillic
 - CharsetEncodingUTF16: UTF-16 Unicode
 - CharsetEncodingUTF16LE: UTF-16LE Unicode
 - CharsetEncodingCP1256: Windows Arabic
 - CharsetEncodingUTF32: UTF-32 Unicode
 - CharsetEncodingCP932: SJIS for Windows Japanese
 - CharsetEncodingGB2312: GB2312 Simplified Chinese
 - CharsetEncodingUTF8MB4: UTF-8 Unicode (support emojies)
 */
typedef NS_ENUM(NSUInteger, CharsetEncoding) {
	CharsetEncodingBig5,
	CharsetEncodingCP850,
	CharsetEncodingKOI8_R,
	CharsetEncodingLatin1,
	CharsetEncodingLatin2,
	CharsetEncodingASCII,
	CharsetEncodingUJIS,
	CharsetEncodingSJIS,
	CharsetEncodingHebrew,
	CharsetEncodingEUCKR,
	CharsetEncodingKOI8U,
	CharsetEncodingGreek,
	CharsetEncodingLatin5,
	CharsetEncodingUTF8,
	CharsetEncodingCP866,
	CharsetEncodingMacRoman,
	CharsetEncodingCP852,
	CharsetEncodingLatin7,
	CharsetEncodingCP1250,
	CharsetEncodingCP1251,
	CharsetEncodingUTF16,
	CharsetEncodingUTF16LE,
	CharsetEncodingCP1256,
	CharsetEncodingUTF32,
	CharsetEncodingCP932,
	CharsetEncodingGB2312,
	CharsetEncodingUTF8MB4,
};


/**
 Parses input parameters and returns appropriate character set string.

 @param encoding Defined OHMySQL encoding to use.
 @return Name of the encoding. The behavior is undefined if an invalid string encoding is passed.
 */
NSString *_Nullable MySQLCharsetForEncoding(CharsetEncoding encoding);


/**
 Converts library' encoding to the Cocoa encoding.

 @param encoding Defined OHMySQL encoding to use.
 @return The Cocoa encoding (of type NSStringEncoding) that is closest to the Core Foundation encoding encoding. The behavior is undefined if an invalid string encoding is passed.
 */
NSStringEncoding NSStringEncodingFromCharsetEncoding(CharsetEncoding encoding);

