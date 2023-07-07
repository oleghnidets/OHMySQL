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

final class PersistentCoordinator {
    var mainQueryContext: MySQLQueryContext {
        MySQLContainer.shared.mainQueryContext!
    }
    
    private var coordinator: MySQLStoreCoordinator
    
    private static func makeCoordinator(databaseName: String) -> MySQLStoreCoordinator {
        let configuration = MySQLConfiguration(user: "root",
                                               password: "",
                                               serverName: "localhost",
                                               dbName: databaseName,
                                               port: 3306,
                                               socket: "/tmp/mysql.sock")
        configuration.writeTimeout = 15
        configuration.readTimeout = 5
        
        return MySQLStoreCoordinator(configuration: configuration)
    }
    
    init() {
        self.coordinator = Self.makeCoordinator(databaseName: "mysql")
    }
    
    func reconnect() -> Bool {
        coordinator.disconnect()
        
        return coordinator.connect()
    }
    
    func connect() -> Bool {
        coordinator.encoding = .UTF8MB4
        
        let context = MySQLQueryContext()
        context.storeCoordinator = coordinator
        MySQLContainer.shared.mainQueryContext = context
        
        return coordinator.connect()
    }
    
    func createDatabase(_ databaseName: String) throws {
        let request = MySQLQueryRequest(query: "CREATE DATABASE \(databaseName);")
        
        try mainQueryContext.execute(request)
    }
    
    func selectDatabase(_ databaseName: String) -> Bool {
        // TODO: For some reason `coordinator.selectDataBase()` doesn't work. Investigate
        self.coordinator = Self.makeCoordinator(databaseName: databaseName)
        return connect()
    }
}
