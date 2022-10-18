//
//  TestPerson.swift
//  OHMySQLTests
//
//  Created by ognidets on 18.10.2022.
//  Copyright © 2022 Oleg Hnidets. All rights reserved.
//

import Foundation

final class TestPerson: NSObject {

    var id: NSNumber?
    var name: String?
    var surname: String?
    var age: NSNumber?
    var data: NSData?
    
    init(id: NSNumber? = nil, name: String? = nil, surname: String? = nil, age: NSNumber? = nil, data: NSData? = nil) {
        self.id = id
        self.name = name
        self.surname = surname
        self.age = age
        self.data = data
    }
}

extension TestPerson {
    func mockObject() -> TestPerson {
        let person = TestPerson()
        person.name    = "Mock name"
        person.age     = 22
        person.data    = NSData()
        
        return person
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
