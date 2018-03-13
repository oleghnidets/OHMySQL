//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Foundation
import OHMySQL

class TasksProvider {
	
	func loadTasks(_ completion: @escaping ([Task]) -> ()) {
		let query = OHMySQLQueryRequestFactory.select("tasks", condition: nil)
		let response = try? OHMySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
		
		guard let responseObject = response as? [[String : Any]] else {
			completion([])
			return
		}
		
		var tasks = [Task]()
		for taskResponse in responseObject {
			let task = Task()
			task.map(fromResponse: taskResponse)
			tasks.append(task)
		}
		
		completion(tasks)
	}
}
