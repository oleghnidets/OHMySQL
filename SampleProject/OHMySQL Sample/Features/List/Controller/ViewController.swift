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

import UIKit

final class PersistentCoordinator {
    static let coordinator: MySQLStoreCoordinator = {
        let configuration = MySQLConfiguration(user: "root",
                                               password: "root",
                                               serverName: "localhost",
                                               dbName: "ohmysql",
                                               port: 3306,
                                               socket: "/tmp/mysql.sock")
        return MySQLStoreCoordinator(configuration: configuration)
    }()
    
    static func connect() -> Bool {
        coordinator.encoding = .UTF8MB4
        
        let context = MySQLQueryContext()
        context.storeCoordinator = coordinator
        MySQLContainer.shared.mainQueryContext = context
        
        return coordinator.connect()
    }
}

class TaskItemRepository {
    func fetch() -> [TaskItem] {
        let query = MySQLQueryRequestFactory.select("tasks", condition: nil)
        let tasks = try? MySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
        
        return tasks?
            .compactMap { $0 }
            .map { response -> TaskItem in
                let task = TaskItem()
                task.map(fromResponse: response)
                return task
            } ?? []
    }
}

final class ViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }
    
    private lazy var dataSource = makeDataSource()
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "\(TaskCell.self)", bundle: .main), forCellReuseIdentifier: "\(TaskCell.self)")
        }
    }
    
    private let storeCoordinator = PersistentCoordinator()
    private let taskRepository = TaskItemRepository()
    
    lazy var coordinator: MySQLStoreCoordinator = {
        let configuration = MySQLConfiguration(user: "root",
                                               password: "root",
                                               serverName: "localhost",
                                               dbName: "ohmysql",
                                               port: 3306,
                                               socket: "/tmp/mysql.sock")
        return MySQLStoreCoordinator(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !PersistentCoordinator.connect() {
            print("Cannot connect to DB")
            return
        }
        
        tableView.dataSource = dataSource
        
        update(with: taskRepository.fetch())
    }
    
    func update(with list: [TaskItem], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TaskItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, TaskItem> {
        UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, task in
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(TaskCell.self)", for: indexPath) as! TaskCell
                cell.label.text = task.name as? String
                
                return cell
            }
        )
    }
}

