//
//  Copyright (c) 2022-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import OHMySQL
import XCTest


final class EscapeTests: XCTestCase {
    private var encoding: CharsetEncoding {
        MySQLContainer.shared.storeCoordinator!.encoding
    }
    
    override class func setUp() {
        super.setUp()
        
        configureDatabase()
    }
    
    override class func tearDown() {
        super.tearDown()
        
        MySQLContainer.shared.storeCoordinator?.disconnect()
    }
    
    func testEscapeSingleQuote() {
        XCTAssertEqual("'".escaped(using: encoding), "\\'")
    }
    
    func testEscapeT() {
        XCTAssertEqual("\t".escaped(using: encoding), "\\t")
    }
    
    func testEscape0() {
        XCTAssertEqual("\0".escaped(using: encoding), "")
    }
    
    func testEscapeB() {
        XCTAssertEqual("\u{8}".escaped(using: encoding), "\\b")
    }
    
    func testEscapeN() {
        XCTAssertEqual("\n".escaped(using: encoding), "\\n")
    }
    
    func testEscapeR() {
        XCTAssertEqual("\r".escaped(using: encoding), "\\r")
    }
    
    func testEscapeQuote() {
        XCTAssertEqual("\"".escaped(using: encoding), "\\\"")
    }
    
    func testComplexString() {
        XCTAssertEqual("'\t\u{8}\n\r\"\\".escaped(using: encoding), "\\'\\t\\b\\n\\r\\\"\\\\")
    }
    
    func testNonEscapedString() {
        XCTAssertEqual("Hello Wordl!@#$^&*()".escaped(using: encoding), "Hello Wordl!@#$^&*()")
    }
    
    /*

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
     */
}
