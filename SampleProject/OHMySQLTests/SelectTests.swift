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

final class SelectTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        configureDatabase()
        SelectTests().createTable()
    }
    
    func DISABLE_testSelectAll() throws {
        // given
        let queryRequest = MySQLQueryRequestFactory.select(kTableName, condition: nil)
        // when
        let response = try XCTUnwrap(mainQueryContext.executeQueryRequestAndFetchResult(queryRequest))
        // then
        XCTAssertFalse(response.isEmpty)
        XCTAssertNotNil(response.first)
        XCTAssertEqual(response.first?["id"] as? Int, 1)
    }
    
    func DISABLE_testSelectAllWithCondition() throws {
        // given
        let queryRequest = MySQLQueryRequestFactory.select(kTableName, condition: "name='Dustin'")
        // when
        let response = try XCTUnwrap(mainQueryContext.executeQueryRequestAndFetchResult(queryRequest))
        // then
        
        XCTAssertNotNil(response.first)
        XCTAssertEqual(response.count, 1)
    }
    
    func DISABLE_testSelectAllWithOrderAsc() throws {
        // given
        let queryRequest = MySQLQueryRequestFactory.select(kTableName, condition: nil, orderBy: ["id"], ascending: true)
        // when
        let response = try XCTUnwrap(mainQueryContext.executeQueryRequestAndFetchResult(queryRequest))
        // then
        XCTAssertNotNil(response.first)
        XCTAssertEqual(response.first?["id"] as? Int, 1)
        XCTAssertEqual(response[1]["id"] as? Int, 2)
    }
    
    func DISABLE_testSelectAllWithConditionAndOrderDesc() throws {
        // given
        let firstObjectIDLimit = 3
        let lastObjectIDLimit  = 20
        let condition = "id>=\(firstObjectIDLimit) AND id<=\(lastObjectIDLimit)"
        let queryRequest = MySQLQueryRequestFactory.select(kTableName, condition: condition, orderBy: ["id"], ascending: false)
        // when
        let response = try XCTUnwrap(mainQueryContext.executeQueryRequestAndFetchResult(queryRequest))
        // then
        XCTAssertEqual(response.first?["id"] as? Int, lastObjectIDLimit)
        XCTAssertEqual(response.last?["id"] as? Int, firstObjectIDLimit)
    }
    
    func DISABLE_testSelectFirstWithConditionOrderedAsc() throws {
        // given
        let queryRequest = MySQLQueryRequestFactory.select(kTableName, condition: "id>1", orderBy: ["name"], ascending: true)
        // when
        let response = try XCTUnwrap( mainQueryContext.executeQueryRequestAndFetchResult(queryRequest))
        // then
        XCTAssertNotNil(response.first)
    }
}
