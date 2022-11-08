//
// Copyright (c) 2022-Present Oleg Hnidets
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

import Foundation
import OHMySQL
import XCTest

final class NullTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        
        configureDatabase()
    }
    
    override func setUp() {
        super.setUp()
        
        XCTAssertNoThrow(try Self.createTable(.nullTableQuery))
    }
    
    func testCreateNullRecord() throws {
        // given
        let insertSet: [String: Any] = [:]
        // when
        let person = try insertPersonObject(insertSet, table: .nullTableQuery)
        // then
        XCTAssertNotNil(person.id)
        XCTAssertNil(person.name)
        XCTAssertEqual(person.surname, "")
        XCTAssertNil(person.age)
        XCTAssertNil(person.data)
    }
    
    func testCreateWithNullAndNotNullRecord() throws {
        // given
        let insertSet = ["name": NSNull(), "age": 22] as [String: Any]
        // when
        let person = try insertPersonObject(insertSet, table: .nullTableQuery)
        // then
        XCTAssertNotNil(person.id)
        XCTAssertNil(person.name)
        XCTAssertEqual(person.surname, "")
        XCTAssertEqual(person.age, 22)
        XCTAssertNil(person.data)
    }

    func testCreateRecord() throws {
        // given
        let insertSet = ["name": "Oleg", "age": 23, "surname": "H", "data": "Data(123)"] as [String : Any]
        // when
        let person = try insertPersonObject(insertSet, table: .nullTableQuery)
        // then
        XCTAssertNotNil(person.id)
        XCTAssertEqual(person.name, "Oleg")
        XCTAssertEqual(person.surname, "H")
        XCTAssertEqual(person.age, 23)
        XCTAssertEqual(person.data, "Data(123)".data(using: .utf8) as? NSData)
    }

    func testCreateIncorrectRecord() throws {
        // given
        let insertSet = ["name": 24, "age": "Oleg", "data": 245] as [String : Any]
        // when/then
        try XCTAssertThrowsError(insertPersonObject(insertSet, table: .nullTableQuery))
    }
}
