//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	private var tasks = [Task]()
	@IBOutlet private weak var tableView: UITableView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		TasksProvider().loadTasks { tasks in
			self.tasks = tasks
		}
	}

	// MARK: - UITableViewDelegate -
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - UITableViewDataSource -

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
		let task = tasks[indexPath.row]
		cell.textLabel?.text = task.name
		cell.detailTextLabel?.text = task.taskDescription
		
		return cell
	}
}

