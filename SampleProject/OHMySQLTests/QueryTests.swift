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

final class QueryTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        configureDatabase()
        QueryTests().createTable()
    }
    
    override func tearDown() {
        super.tearDown()
        
        clearTableNamed(kTableName)
    }
    
    func testInsertNewRow() throws {
        let insertSet = ["name": "Oleg", "surname": "Hnidets", "age": "23"] as [String : Any]
        
        let queryRequest = MySQLQueryRequestFactory.insert(kTableName, set: insertSet)
        
        XCTAssertNoThrow(try mainQueryContext.execute(queryRequest))
    }
    
    func testUpdateAll() throws {
        try testInsertNewRow()
        
        let updateSet = ["name": "Oleg", "surname": "Hnidets", "age": "23"]
        
        let queryRequest = MySQLQueryRequestFactory.update(kTableName, set: updateSet, condition: nil)
        
        XCTAssertNoThrow(try mainQueryContext.execute(queryRequest))
    }
    
    func testUpdateAllWithCondition() throws {
        try testInsertNewRow()
        
        let queryRequest = MySQLQueryRequestFactory.update(kTableName, set: ["age": "25"], condition: "name='Oleg'")
        
        XCTAssertNoThrow(try mainQueryContext.execute(queryRequest))
    }
    
    func testDeleAllWithCondition() throws {
        try testInsertNewRow()
        
        let queryRequest = MySQLQueryRequestFactory.delete(kTableName, condition: "name='Oleg'")
        
        XCTAssertNoThrow(try mainQueryContext.execute(queryRequest))
    }
    
    func testDeleteAll() throws {
        try testInsertNewRow()
        
        let queryRequest = MySQLQueryRequestFactory.delete(kTableName, condition: nil)
        
        XCTAssertNoThrow(try mainQueryContext.execute(queryRequest))
    }
    
    func testIncorrectQuery() throws {
        let incorrectQueryString = "SELECT qwe FROM 'something'"
        let queryRequest = MySQLQueryRequest(query: incorrectQueryString)
        
        XCTAssertThrowsError(try mainQueryContext.executeQueryRequestAndFetchResult(queryRequest))
    }
    
    func testAffectedRows() throws {
        try testInsertNewRow()
        
        let numberOfRows = try XCTUnwrap(mainQueryContext.affectedRows() as? Int)
        XCTAssertEqual(numberOfRows, 1)
    }
    
}
