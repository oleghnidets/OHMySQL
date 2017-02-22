//  Created by Oleg Gnidets on 2/22/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Escaping.h"
#import "NSString+Utility.h"

#import "XCTestCase+Database_Basic.h"

@interface OHEscapeTests : XCTestCase

@property (class, readonly) CharsetEncoding encoding;

@end

@implementation OHEscapeTests

- (CharsetEncoding)encoding {
	return [OHMySQLManager sharedManager].storeCoordinator.encoding;
}

- (void)setUp {
	[super setUp];
	[OHEscapeTests configureDatabase];
}

- (void)tearDown {
	[[OHMySQLManager sharedManager].storeCoordinator disconnect];
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
