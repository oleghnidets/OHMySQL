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

final class TaskItemRepository {
    let coordinator: PersistentCoordinator
    
    init(coordinator: PersistentCoordinator) {
        self.coordinator = coordinator
    }
    
    func createTable() throws {
        let createTableString = """
                CREATE TABLE `tasks` (
                  `id` int(11) NOT NULL,
                  `name` varchar(255) DEFAULT NULL,
                  `description` varchar(10000) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
                  `status` bigint(11) DEFAULT NULL,
                  `data` blob NOT NULL,
                  `preciseValue` decimal(65,30) NOT NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
                """
        let primaryKeyString = "ALTER TABLE `tasks` ADD PRIMARY KEY (`id`);"
        let incrementKeyString = "ALTER TABLE `tasks` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;"
        
        for query in [createTableString, primaryKeyString, incrementKeyString] {
            let request = MySQLQueryRequest(query: query)
            try coordinator.mainQueryContext.execute(request)
        }
    }
    
    func fetch() throws -> [TaskItem] {
        let query = MySQLQueryRequestFactory.select("tasks", condition: nil)
        let tasks = try MySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        
        return tasks?
            .compactMap { $0 }
            .map {
                let task = TaskItem()
                task.map(fromResponse: $0)
                return task
            } ?? []
    }
    
    func addTaskItem(_ item: TaskItem, completion: @escaping (Result<Void, Error>) -> ()) {
        coordinator.mainQueryContext.insertObject(item)
        coordinator.mainQueryContext.save { error in
            completion(error != nil ? .failure(error!) : .success(()))
        }
    }
}
