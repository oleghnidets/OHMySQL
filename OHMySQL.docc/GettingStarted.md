# Getting Started

Set up the classes that manage and persist your data. 

## Overview

* An instance of ``OHMySQLConfiguration`` represents your connection preferences. 
* An instance of ``OHMySQLStoreCoordinator`` manages a connection to the database.
* An instance of ``OHMySQLQueryContext`` saves and fetches data from storage, executes the queries.

### Initialize a Store Coordinator

Typically, you need to keep only one instance of ``OHMySQLStoreCoordinator`` in your code. One instance is a one connection. 

1. Create configuration preference instance:
    ```swift
    let configuration = MySQLConfiguration(userName: "root", password: "root", serverName: "localhost", dbName: "db_name", port: 3306, socket: "/mysql/mysql.sock")
    ```
    If your connection is configured for SSL, you can specify this at creation:
    ```swift
    let sslConfig = MySQLSSLConfig(key: "client-key.pem", certPath: "client-cert.pem", certAuthPath: "ca.pem", certAuthPEMPath: "", cipher: nil)
    let configuration = MySQLConfiguration(userName: "root", password: "root", sslConfig: sslConfig, serverName: "localhost", dbName: "db_name", port: 3306, socket: "/mysql/mysql.sock")
    ```

2. Create a store coordinator.
    ```swift
    let coordinator = MySQLStoreCoordinator(user: configuration)
    ```

    If required, you can set up the encoding and protocol type.
    ```swift
    coordinator.encoding = .UTF8MB4
    coordinator.protocol = .TCP
    ```

3. Connect to the database. The method ``OHMySQLStoreCoordinator/connect`` returns a boolean value indicating if a connection is set up. 
    ```swift
    if coordinator.connect() {
       print("Connected successfully.")
    }
    ```

### Configure Query Context

The instance of ``OHMySQLQueryContext`` is responsible for executing queries, saving/updating/deleting model objects. It is a key object in the application.

1. There must be only one **main** context in the application.
    ```swift
    let context = MySQLQueryContext()
    ```

2. The context must keep a reference to store coordinator. 
    ```swift
    context.storeCoordinator = coordinator
    ```

3. For your convenience, set a context into singleton of ``OHMySQLContainer``. 
    ```swift
    MySQLContainer.shared.mainQueryContext = context
    ```

    You can always access the main context in any place of your code:
    ```swift
    MySQLContainer.shared.mainQueryContext?.lastInsertID()
    ```

### Execute Query

Every query is represented by a string. An instance of ``OHMySQLQueryRequest`` initialized with a string and provides timeline information after execution.

Typically, there are two types of queries.
The first type doesn't return any result. It executes the query and you can catch the error if any appears.

```swift
let queryString = "DROP TABLE `mytable`"
let queryRequest = MySQLQueryRequest(queryString: dropQueryString)

do {
    try MySQLContainer.shared.mainQueryContext?.execute(dropQueryRequest)
} catch {
    print("Cannot execute the query.")
}
```

The second type does return a result. The result is an array of dictionaries.
```swift
let queryString = "SELECT * FROM `mytable`"
let queryRequest = MySQLQueryRequest(queryString: queryString)
do {
    let result = try MySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query) ?? []
    print("\(result)")
} catch {
    print("Cannot execute the query.")
}
```
