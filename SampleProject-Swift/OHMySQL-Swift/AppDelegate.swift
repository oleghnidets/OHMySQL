//  Created by Oleg Hnidets on 4/2/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import UIKit
import OHMySQL

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		configureMySQL()
		
		return true
	}
	
	private func configureMySQL() {
		let user = OHMySQLUser(userName: "root", password: "root", serverName: "localhost", dbName: "ohmysql", port: 3306, socket: "/Applications/MAMP/tmp/mysql/mysql.sock")
		let coordinator = OHMySQLStoreCoordinator(user: user!)
		coordinator.encoding = .UTF8MB4
		coordinator.connect()
		
		let context = OHMySQLQueryContext()
		context.storeCoordinator = coordinator
		OHMySQLContainer.shared().mainQueryContext = context
	}

}

