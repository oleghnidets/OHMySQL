//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Cocoa
import OHMySQL

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	private var tasks = [Task]()
	@IBOutlet private weak var tableView: NSTableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureMySQL()
		
		TasksProvider().loadTasks { tasks in
			self.tasks = tasks
			print(tasks.count)
			self.tableView.reloadData()
		}
	}
	
	private func configureMySQL() {
		let user = OHMySQLUser(userName: "root", password: "root", serverName: "localhost", dbName: "ohmysql", port: 3306, socket: "/Applications/MAMP/tmp/mysql/mysql.sock")
		let coordinator = OHMySQLStoreCoordinator(user: user!)
		coordinator.encoding = .UTF8MB4
		coordinator.connect()
		
		let context = OHMySQLQueryContext()
		context.storeCoordinator = coordinator
		OHMySQLContainer.shared.mainQueryContext = context
	}
	
	// MARK: - NSTableViewDataSource -
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return tasks.count
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CellIdentifier"), owner: nil) as? NSTableCellView
		let task = tasks[row]
		cell?.textField?.stringValue = task.name ?? ""
		
		return cell
	}
}

