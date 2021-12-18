//  Created by Oleg Hnidets on 2/7/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

@import Foundation;

/**
 * Available character sets.
 */
typedef NS_ENUM(NSUInteger, CharsetEncoding) {
	/**  Big5 Traditional Chinese */
	CharsetEncodingBig5,

	/** DOS West European */
	CharsetEncodingCP850,

	/** KOI8-R Relcom Russian */
	CharsetEncodingKOI8_R,

	/** cp1252 West European */
	CharsetEncodingLatin1,

	/** ISO 8859-2 Central European */
	CharsetEncodingLatin2,

	/** US ASCII */
	CharsetEncodingASCII,

	/** EUC-JP Japanese */
	CharsetEncodingUJIS,

	/** Shift-JIS Japanese */
	CharsetEncodingSJIS,

	/** ISO 8859-8 Hebrew */
	CharsetEncodingHebrew,

	/** EUC-KR Korean */
	CharsetEncodingEUCKR,

	/** KOI8-U Ukrainian */
	CharsetEncodingKOI8U,

	/** ISO 8859-7 Greek */
	CharsetEncodingGreek,

	/** ISO 8859-9 Turkish */
	CharsetEncodingLatin5,

	/** UTF-8 Unicode */
	CharsetEncodingUTF8,

	/** DOS Russian */
	CharsetEncodingCP866,

	/** Mac West European */
	CharsetEncodingMacRoman,

	/** DOS Central European */
	CharsetEncodingCP852,

	/** ISO 8859-13 Baltic */
	CharsetEncodingLatin7,

	/** Windows Central European */
	CharsetEncodingCP1250,

	/** Windows Cyrillic */
	CharsetEncodingCP1251,

	/** UTF-16 Unicode */
	CharsetEncodingUTF16,

	/** UTF-16LE Unicode */
	CharsetEncodingUTF16LE,

	/** Windows Arabic */
	CharsetEncodingCP1256,

	/** UTF-32 Unicode */
	CharsetEncodingUTF32,

	/** SJIS for Windows Japanese */
	CharsetEncodingCP932,

	/** GB2312 Simplified Chinese */
	CharsetEncodingGB2312,

	/** UTF-8 Unicode (support emojies) */
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

