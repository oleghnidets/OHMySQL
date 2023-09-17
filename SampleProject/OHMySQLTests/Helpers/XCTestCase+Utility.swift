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

import XCTest
import OHMySQL

extension XCTestCase {
    var mainQueryContext: MySQLQueryContext {
        MySQLContainer.shared.mainQueryContext!
    }
    
    static var mainQueryContext: MySQLQueryContext {
        MySQLContainer.shared.mainQueryContext!
    }
    
    static func configureDatabase() {
//        guard let database = ProcessInfo.processInfo.environment["DB_NAME"],
//              let username = ProcessInfo.processInfo.environment["USER_NAME"],
//              let password = ProcessInfo.processInfo.environment["USER_PASSWORD"],
//              let serverName = ProcessInfo.processInfo.environment["DB_HOST"],
//              let portString = ProcessInfo.processInfo.environment["DB_PORT"],
//              let port = UInt(portString),
//              let socket = ProcessInfo.processInfo.environment["DB_SOCKET"] else {
//            XCTFail("Cannot configure database")
//            return
//        }
        
        let database = "mysql"
        let username = "root"
        let password = ""
        let serverName = "localhost"
        let port: UInt = 3306
        let socket = "/tmp/mysql.sock"
        
        let configuration = MySQLConfiguration(user: username,
                                               password: password,
                                               serverName: serverName,
                                               dbName: database,
                                               port: port,
                                               socket: socket)
        let queryContext = MySQLQueryContext()
        queryContext.storeCoordinator = MySQLStoreCoordinator(configuration: configuration)
        
        MySQLContainer.shared.mainQueryContext = queryContext
    }
    
    static func createTable(_ table: DatabaseTable) throws {
        dropTable(name: table.tableName)
        
        let queryRequest = MySQLQueryRequest(query: table.createTableQuery)
        
        try mainQueryContext.execute(queryRequest)
    }
    
    static func clearTable(_ table: DatabaseTable) throws {
        let deleteQuery =  MySQLQueryRequest(query: "DELETE FROM \(table.tableName)")
        try mainQueryContext.execute(deleteQuery)
    }
    
    func insertPersonObject(_ inputDictionary: [String: Any], table: DatabaseTable) throws -> TestPerson {
        let queryRequest = MySQLQueryRequestFactory.insert(table.tableName, set: inputDictionary)
        
        try mainQueryContext.execute(queryRequest)
        
        let firstObjectRequest = MySQLQueryRequestFactory.selectFirst(table.tableName, condition: "id=\(mainQueryContext.lastInsertID().stringValue)")
        let response = try XCTUnwrap(try mainQueryContext.executeQueryRequestAndFetchResult(firstObjectRequest).first)

        let person = TestPerson(id: response["id"] as? NSNumber,
                                name: response["name"] as? String,
                                surname: response["surname"] as? String,
                                age: response["age"] as? NSNumber,
                                data: response["data"] as? NSData)
        
        return person
    }
    
    private static func dropTable(name: String) {
        let dropQueryString = "DROP TABLE \(name)"
        let queryRequest = MySQLQueryRequest(query: dropQueryString)
        
        try? mainQueryContext.execute(queryRequest)
    }
}

struct DatabaseTable {
    let tableName: String
    let createTableQuery: String
}

extension DatabaseTable {
    private static let defaultTableName = "TestTable"
    private static let nullTableName = "TestNull"
    
    static let defaultTestQuery = DatabaseTable(
        tableName: defaultTableName,
        createTableQuery: "CREATE TABLE `\(defaultTableName)` ( `id` mediumint(8) unsigned NOT NULL auto_increment, `name` varchar(255) default NULL, `surname` varchar(255) default NULL, `age` mediumint default NULL, PRIMARY KEY (`id`) ) AUTO_INCREMENT=1; INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Bradley','Oneill',90),('Levi','Moses',25),('Orlando','Cummings',9),('Hasad','Maldonado',5),('Carlos','Lowery',57),('Axel','Doyle',74),('Hasad','Booth',60),('Hall','Walters',84),('Dustin','Velazquez',84),('Randall','Riggs',91); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Harper','Knowles',67),('Jasper','Massey',95),('Hop','Casey',2),('Timon','Bright',25),('Lionel','Mcintyre',74),('Denton','Kennedy',35),('Ethan','Jarvis',43),('Hasad','Stevens',56),('Benedict','Dudley',29),('Shad','Pace',94); INSERT INTO `TestTable` (`name`,`surname`,`age`) VALUES ('Asher','Williamson',70),('Sylvester','Baldwin',37),('Lucas','Bush',62),('Nissim','Harvey',43),('Anthony','Adkins',4),('Norman','Snow',26),('Coby','Oneill',82);")
    
    static let objectTableQuery = DatabaseTable(
        tableName: defaultTableName,
        createTableQuery: "CREATE TABLE `\(defaultTableName)` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `surname` VARCHAR(1) NOT NULL DEFAULT '', `name` VARCHAR(255) NULL, `age` INT NULL, `data` BLOB(20) NULL);")
    
    static let nullTableQuery = DatabaseTable(
    tableName: nullTableName,
    createTableQuery: "CREATE TABLE `\(nullTableName)` (`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, `surname` VARCHAR(1) NOT NULL DEFAULT '', `name` VARCHAR(255) NULL, `age` INT NULL, `data` BLOB(20) NULL);")
}
