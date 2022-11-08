//
//  TestPerson.swift
//  OHMySQLTests
//
//  Created by ognidets on 18.10.2022.
//  Copyright © 2022 Oleg Hnidets. All rights reserved.
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
