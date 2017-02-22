//  Created by Oleg Gnidets on 2/22/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "NSString+Escaping.h"

typedef NS_ENUM(NSInteger, EscapeType) {
	EscapeTypeNormal,
	EscapeTypeEscape,
};

static size_t escape(const char *szOrig, char *szEscaped, size_t bufSize);

@implementation NSString (Escaping)

- (nonnull NSString *)escapedUsingEncoding:(CharsetEncoding)encoding {
	// Get current NSString instance as C string.
	NSStringEncoding nsEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
	const char *chars = [self cStringUsingEncoding:nsEncoding];
	
	// Allocate enought memory for escaped C string.
	NSUInteger bufferSize = 2 * strlen(chars) + 1;
	char *chunk = calloc(bufferSize, sizeof(char));
	
	// Escape characters
	escape(chars, chunk, bufferSize);
	
	// Save result
	NSString *result = [[NSString alloc] initWithCString:chunk encoding:nsEncoding];
	
	// Free memory
	free(chunk);
	
	return result;
}

@end

static int unescape(char *str, size_t strLength, EscapeType state) {
	int sIndex = 0, dIndex = 0;
	
	if (str == 0 || strLength <= 0) { // validate string
		return 0;
	}
	
	while (sIndex < strLength) {
		switch (state) {
				// we are in the NORMAL state until we find a '\\' character
			case EscapeTypeNormal:
				if (str[sIndex] == '\\') {
					state = EscapeTypeEscape;
				} else {
					// Simply copy the non '\\' characters from the source
					// to the destination in the EscapeTypeNormal state.
					str[dIndex] = str[sIndex];
					dIndex += 1;
				}
				break;
			case EscapeTypeEscape:
				// In the EscapeTypeEscape state, copy the sequence,
				// like '\\\n', '\\\r', etc. as '\n', '\r', etc.
				if (
					str[sIndex] == '\0' ||
					str[sIndex] == '\n' ||
					str[sIndex] == '\r' ||
					str[sIndex] == '\\' ||
					str[sIndex] == '\'' ||
					str[sIndex] == '\"' ||
					str[sIndex] == (char) 0x1A /* Ctrl-Z */
					) {
					str[dIndex] = str[sIndex];
					dIndex ++;
				} else {
					// we have (mistakenly) entered the EscapeTypeEscape
					// state, so output the suppressed '\\' character
					// and the current character
					str[dIndex] = '\\';
					dIndex ++;
					str[dIndex] = str[sIndex];
					dIndex ++;
				}
				
				state = EscapeTypeNormal;
				
				break;
		}
		
		sIndex ++;
	}
	
	// In case the last character is a '\\' indicated by the EscapeTypeEscape state at loop termination
	// we have to copy the '\\' character
	if (state == EscapeTypeEscape) {
		str [dIndex] = '\\';
		dIndex ++;
	}
	
	return dIndex;
}

static size_t escape(const char *szOrig, char *szEscaped, size_t bufSize) {
	size_t newLen = 0;
	size_t origLen = strlen(szOrig);
	
	for(int i = 0; i < origLen; i++) {
		switch(szOrig[i]) {
			case '\0':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\0", 2);
				newLen += 2;
				break;
			case '\b':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\b", 2);
				newLen += 2;
				break;
			case '\n':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\n", 2);
				newLen += 2;
				break;
			case '\r':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\r", 2);
				newLen += 2;
				break;
			case '\t':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\t", 2);
				newLen += 2;
				break;
				//			case '\%':
				//				if (bufSize > newLen + 2)
				//					memcpy(&szEscaped[newLen], "\\%", 2);
				//				newLen += 2;
				//				break;
			case '\'':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\'", 2);
				newLen += 2;
				break;
			case '\"':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\\"", 2);
				newLen += 2;
				break;
			case '\\':
				if (bufSize > newLen + 2)
					memcpy(&szEscaped[newLen], "\\\\", 2);
				newLen += 2;
				break;
			default:
				if (bufSize > newLen + 1)
					szEscaped[newLen] = szOrig[i];
				newLen++;
				break;
		}
	}
	
	return newLen;
}
