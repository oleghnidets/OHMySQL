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

#import <XCTest/XCTest.h>
#import "NSString+Escaping.h"
#import "NSString+Utility.h"

#import "XCTestCase+Database_Basic.h"

@interface OHEscapeTests : XCTestCase

@property (nonatomic, assign) CharsetEncoding encoding;

@end

@implementation OHEscapeTests

- (CharsetEncoding)encoding {
	return OHMySQLContainer.shared.storeCoordinator.encoding;
}

- (void)setUp {
	[super setUp];
	[OHEscapeTests configureDatabase];
}

- (void)tearDown {
	[OHMySQLContainer.shared.storeCoordinator disconnect];
	[super tearDown];
}

- (void)testEscapeSingleQuote {
	NSString *escaped = [@"'" escapedUsingEncoding:self.encoding];
	
	XCTAssert([escaped isEqualToString:@"\\'"]);
}

- (void)testEscapeT {
	// when
	NSString *escaped = [@"\t" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\t"]);
}

- (void)testEscape0 {
	// when
	NSString *escaped = [@"\0" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@""]);
}

- (void)testEscapeB {
	// when
	NSString *escaped = [@"\b" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\b"]);
}

- (void)testEscapeN {
	// when
	NSString *escaped = [@"\n" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\n"]);
}

- (void)testEscapeR {
	// when
	NSString *escaped = [@"\r" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\r"]);
}

- (void)DISABLED_testEscapePercent {
	// when
	NSString *escaped = [@"%" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\%"]);
}

- (void)testEscapeQuote {
	// when
	NSString *escaped = [@"\"" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\\""]);
}

- (void)testEscapeBackslash {
	// when
	NSString *escaped = [@"\\" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\\\"]);
}

- (void)testComplexString {
	// when
	NSString *escaped = [@"'\t\b\n\r\"\\" escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:@"\\'\\t\\b\\n\\r\\\"\\\\"]);
}

- (void)testNonEscapedString {
	// given
	NSString *stringToTest = @"Hello Wordl!@#$^&*()";
	// when
	NSString *escaped = [stringToTest escapedUsingEncoding:self.encoding];
	// then
	XCTAssert([escaped isEqualToString:stringToTest]);
}

@end
