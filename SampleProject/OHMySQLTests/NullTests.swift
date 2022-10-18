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
    
    static let tableName = "TestNull"
    
    override class func setUp() {
        super.setUp()
        
        Self.configureDatabase()
        
        NullTests().createTable(withQuery: """
                    CREATE TABLE TestNull (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `surname` VARCHAR(1) NOT NULL DEFAULT '', `name` VARCHAR(255) NULL, `age` INT NULL, `data` BLOB(20) NULL);
                    """)
    }
    
    override func setUp() {
        super.setUp()
        
        clearTableNamed(Self.tableName)
    }
    
    func testCreateNullRecord() {
        let insertSet: [AnyHashable: Any] = [:]
        // when
        let response = createPerson(withSet: insertSet, in: Self.tableName)
        // then
        XCTAssertNotNil(response?.id)
        XCTAssertEqual(response?.name as? NSNull, NSNull())
        XCTAssertEqual(response?.surname as? String, "")
        XCTAssertEqual(response?.age as? NSNull, NSNull())
        XCTAssertEqual(response?.data as? NSNull, NSNull())
    }
    
    func testCreateWithNullAndNotNullRecord() {
        // when
        let insertSet = ["name": NSNull(), "age": 22] as [AnyHashable: Any]
        // then
        let response = createPerson(withSet: insertSet, in: Self.tableName)
        
        XCTAssertNotNil(response?.id)
        XCTAssertEqual(response?.name as? NSNull, NSNull())
        XCTAssertEqual(response?.surname as? String, "")
        XCTAssertEqual(response?.age as? Int, 22)
        XCTAssertEqual(response?.data as? NSNull, NSNull())
    }
    
    func testCreateRecord() {
        // when
        let insertSet = ["name": "Oleg", "age": 23, "surname": "H", "data": "Data(123)"] as [AnyHashable : Any]
        // then
        let response = createPerson(withSet: insertSet, in: Self.tableName)
        
        XCTAssertNotNil(response?.id)
        XCTAssertEqual(response?.name as? String, "Oleg")
        XCTAssertEqual(response?.surname as? String, "H")
        XCTAssertEqual(response?.age as? Int, 23)
        XCTAssertEqual(response?.data as? Data, "Data(123)".data(using: .utf8))
    }
    
    func testCreateIncorrectRecord() {
        // when
        let insertSet = ["name": 24, "age": "Oleg", "data": 245] as [AnyHashable : Any]
        // then
        let response = createPerson(withSet: insertSet, in: Self.tableName)
        
        XCTAssertNotNil(response)
        XCTAssertNil(response?.id)
        XCTAssertNil(response?.name)
        XCTAssertNil(response?.surname)
        XCTAssertNil(response?.age)
        XCTAssertNil(response?.data)
    }
}
