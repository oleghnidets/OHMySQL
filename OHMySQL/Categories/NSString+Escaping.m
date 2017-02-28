//  Created by Oleg Gnidets on 2/22/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import "NSString+Escaping.h"

static size_t escape(const char *szOrig, char *szEscaped, size_t bufSize);

@implementation NSString (Escaping)

- (nonnull NSString *)escapedUsingEncoding:(CharsetEncoding)encoding {
	// Get current NSString instance as C string.
	NSStringEncoding nsEncoding = NSStringEncodingFromCharsetEncoding(encoding);
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
