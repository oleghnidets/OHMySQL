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

final class TestPerson: NSObject {

    @objc var id: NSNumber?
    @objc var name: String?
    @objc var surname: String?
    @objc var age: NSNumber?
    @objc var data: NSData?
    
    init(id: NSNumber? = nil, name: String? = nil, surname: String? = nil, age: NSNumber? = nil, data: NSData? = nil) {
        self.id = id
        self.name = name
        self.surname = surname
        self.age = age
        self.data = data
    }
}

extension TestPerson: MySQLMappingProtocol {
    func primaryKey() -> String {
        "id"
    }
    
    func mySQLTable() -> String {
        "TestTable"
    }
    
    func mappingDictionary() -> [AnyHashable : Any] {
        [
            "id": "id",
            "name": "name",
            "surname": "surname",
            "age": "age",
            "data": "data",
        ]
    }
}

extension TestPerson {
    static func mockObject() -> TestPerson {
        let person = TestPerson()
        person.name    = "Mock name"
        person.age     = 22
        person.data    = NSData()
        
        return person
    }
}
