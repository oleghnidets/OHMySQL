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

final class TaskListViewModel: ObservableObject {
    enum State {
        case idle
        case fetching
        case fetched
        case emptyList
        case error(message: String)
    }
    
    private let storeCoordinator = PersistentCoordinator()
    private lazy var taskRepository = TaskItemRepository(coordinator: self.storeCoordinator)
    
    private(set) var tasks: [TaskPresentationItem] = [] {
        didSet {
            state = tasks.isEmpty ? .emptyList : .fetched
        }
    }
    
    @Published var state: State = .idle
    
    func configureData() {
        self.state = .fetching
        
        guard self.storeCoordinator.connect() else {
            self.state = .error(message: "Cannot connect to database")
            return
        }
        
        do {
            self.tasks = try self.fetchTasks()
        } catch {
            do {
                try self.handleDatabaseSelection()
                self.handleTableCreation()
                
                self.tasks = (try? self.fetchTasks()) ?? []
            } catch {
                self.state = .error(message: "Cannot fetch tasks")
            }
        }
    }
    
    func addRandomTask() {
        self.state = .fetching
        
        let task = TaskItem()
        task.taskDescription = "description"
        task.status = 1
        task.name = "Hello"
        task.decimalValue = 3.14
        task.taskData = UIDevice.current.identifierForVendor?.uuidString.data(using: .utf8) as? NSData
        
        taskRepository.addTaskItem(task) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.tasks = (try? self.fetchTasks()) ?? []
                case .failure:
                    self.state = .error(message: "Cannot create a task")
                }
            }
        }
    }
    
    func deleteAll() throws {
        guard let tasks = try? taskRepository.fetch() else {
            return
        }
        
        try delete(at: IndexSet(integersIn: tasks.startIndex...tasks.endIndex - 1))
    }
    
    func delete(at indexSet: IndexSet) throws {
        guard let tasks = try? taskRepository.fetch() else {
            return
        }
        
        let items = indexSet.map { tasks[$0] }
        var counter = 0
        
        items.forEach { item in
            taskRepository.deleteTaskItem(item) { _ in 
                DispatchQueue.main.async {
                    counter += 1
                    
                    if counter == items.count {
                        self.tasks = (try? self.fetchTasks()) ?? []
                    }
                }
            }
        }
    }
    
    private func handleDatabaseSelection() throws {
        if storeCoordinator.selectDatabase("tasks") {
            return
        }
        
        try storeCoordinator.createDatabase("tasks")
        
        if !storeCoordinator.selectDatabase("tasks") {
            throw URLError(.badServerResponse)
        }
    }
    
    private func handleTableCreation() {
        try? taskRepository.createTable()
    }
    
    private func fetchTasks() throws -> [TaskPresentationItem] {
        let tasks = try taskRepository.fetch()
        
        return tasks.map {
            TaskPresentationItem(id: $0.taskId?.stringValue ?? UUID().uuidString,
                                 name: $0.name as? String,
                                 status: $0.status as? Int,
                                 taskDescription: $0.taskDescription as? String)
            
        }
    }
}
