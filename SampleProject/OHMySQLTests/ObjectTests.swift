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

final class ObjectTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        
        configureDatabase()
        Self().createEmptyTable()
        
        MySQLContainer.shared.mainQueryContext?.storeCoordinator.reconnect()
    }
    
    override func tearDown() {
        super.tearDown()
        
        clearTableNamed(kTableName)
    }
    
    func testInsertObject() throws {
        // given
        let person = OHTestPerson.mockObject()
        // when
        mainQueryContext.insertObject(person)
        
        // then
        XCTAssertNoThrow(try mainQueryContext.save())
        
        let firstPerson = try! fetchFirstPerson()
        
        XCTAssertEqual(countOfObjects(), 1)
        XCTAssertNotNil(firstPerson.id)
        XCTAssertNotNil(firstPerson.name)
        XCTAssertNotNil(firstPerson.surname)
        XCTAssertNotNil(firstPerson.age)
    }
    
    func fetchFirstPerson() throws -> OHTestPerson {
        let queryRequest = MySQLQueryRequestFactory.selectFirst(kTableName, condition: nil)
        
        let dictionary = try mainQueryContext.executeQueryRequestAndFetchResult(queryRequest).first
        
        let person = OHTestPerson()
        person.map(fromResponse: dictionary ?? [:])
        
        return person
    }
     
    func testAffectedObjects() throws {
        XCTAssertEqual(mainQueryContext.affectedRows(), 0)
        // given
        try testInsertObject()
        let person = try! fetchFirstPerson()
        mainQueryContext.insertObject(person)
        // then
        XCTAssertEqual(mainQueryContext.insertedObjects?.count, 1)
        XCTAssertThrowsError(try mainQueryContext.save())
        
        // given
        mainQueryContext.refreshObject(person)
        // then
        XCTAssertEqual(mainQueryContext.insertedObjects?.count, .zero)
        XCTAssertEqual(mainQueryContext.updatedObjects?.count, .zero)
        XCTAssertEqual(mainQueryContext.deletedObjects?.count, .zero)
        
        // given
        mainQueryContext.deleteObject(person)
        // then
        XCTAssertEqual(mainQueryContext.deletedObjects?.count, 1)
        XCTAssertNoThrow(try mainQueryContext.save())
        XCTAssertEqual(mainQueryContext.affectedRows(), 1)
        
        // given
        mainQueryContext.updateObject(person)
        // then
        XCTAssertEqual(mainQueryContext.updatedObjects?.count, 1)
        XCTAssertNoThrow(try mainQueryContext.save())
        XCTAssertEqual(mainQueryContext.affectedRows(), 0)
    }
    
    func testInsertObjectWithChildContext() {
        let person = OHTestPerson.mockObject()
        let persistantStoreExpectation = expectation(description: "Saved successfully")
        
        let childContext = MySQLQueryContext(parentQueryContext: mainQueryContext)
        childContext.insertObject(person)
        
        childContext.save { error in
            XCTAssertNil(error)
            persistantStoreExpectation.fulfill()
        }
        
        wait(for: [persistantStoreExpectation], timeout: 5)
    }
    
    func testUpdateObjectWithChildContext() throws {
        try testInsertObject()
        
        let person = OHTestPerson.mockObject()
        person?.id = mainQueryContext.lastInsertID()
        person?.name = person?.id.stringValue
        
        let persistantStoreExpectation = expectation(description: "Saved successfully")
        let childContext = MySQLQueryContext(parentQueryContext: mainQueryContext)
        childContext.updateObject(person)
        
        childContext.save { error in
            XCTAssertNil(error)
            persistantStoreExpectation.fulfill()
        }
        
        wait(for: [persistantStoreExpectation], timeout: 5)
        
        XCTAssertEqual(countOfObjects(), 1)
    }
    
    func testInsertionOfManyObjects() {
        let threadingExpectation = expectation(description: "Saved successfully")
        let childContext = MySQLQueryContext(parentQueryContext: mainQueryContext)
        
        childContext.perform {
            DispatchQueue.concurrentPerform(iterations: 1000) { _ in
                let person = OHTestPerson.mockObject()
                childContext.insertObject(person)
            }
            
            childContext.save { error in
                XCTAssertNil(error)
                XCTAssertEqual(self.countOfObjects(), 1000)
                
                threadingExpectation.fulfill()
            }
        }
        
        wait(for: [threadingExpectation], timeout: 10)
    }
}
