//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import Foundation
import OHMySQL

class Task: NSObject, MySQLMappingProtocol {
	
	@objc var taskId: NSNumber?
	@objc var name: String?
	@objc var taskDescription: String?
	@objc var status: NSNumber?
	
	func mappingDictionary() -> [AnyHashable : Any]! {
		return ["taskId": "id",
		        "name": "name",
		        "taskDescription": "description",
		        "status": "status"]
	}

	func mySQLTable() -> String! {
		return "tasks"
	}
	
	func primaryKey() -> String! {
		return "taskId"
	}
}
