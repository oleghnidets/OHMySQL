# OHMySQL

[![License][platform-image]][platform-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible][cocoapods-image]][cocoapods-url]
[![Carthage Compatible][carthage-image]][carthage-url]
[![Documentation][docs-image]][docs-url]

OHMySQL can connect to remote or local MySQL database and execute CRUD operations. The framework is built upon MySQL C API, but you don’t need to dive into low-level. The following diagram represents a general architecture. Logic (saving, editing, removing etc.) is aggregated in the app. The database is just a shared storage.

<p align="center" >⭐️ <b>Every star is appreciated!</b> ⭐️</p>


<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Features](#-features)
- [Platforms](#-platforms)
- [Project Support](#-project-support)
- [Installation](#-installation)
- [Usage](#-usage)
- [Query Context](#-query-context)
  - [Execute Query](#-execute-query)
  - [SELECT](#-select-)
  - [INSERT](#-insert)
  - [UPDATE](#-update)
  - [DELETE](#-delete)
  - [JOINs](#-joins)
  - [Object Mapping](#-object-mapping)
- [Communication](#-communication)
- [License](#-license-)

<!-- /code_chunk_output -->

## Features

- [x] Supports Swift and Objective-C 
- [x] Requires minimal knowledge in SQL
- [x] Easy to integrate and use
- [x] Many functionality features
- [x] Up-to-date MySQL library
- [x] [Documentation](https://oleghnidets.github.io/OHMySQL/documentation/ohmysql/) and [support](https://github.com/oleghnidets/OHMySQL/issues?q=is%3Aissue+is%3Aclosed)

## Platforms

| Platform    | Supported  | 
| ----------- | ---------  | 
| iOS         | 14.0+      | 
| macOS       | 11.0+      | 
| Mac Catalyst| 14.0+      | 
| watchOS     | 8.0+       | 
| tvOS        | 15.0+      |

## Project Support

I wish to support the library and extend API and functionality. If you donate me some money 💵, it keeps me motivated and happy 🙂 You may support me via [PayPal](
https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YCAKYM4XCT2DG&source=url ) or let me know any other method convenient for you.

## Installation

Read [documentation](https://oleghnidets.github.io/OHMySQL/documentation/ohmysql/installation) how to install the library as a dependency in your project.

## Usage

Connect to the database.

```swift
let user = MySQLConfiguration(userName: "root", 
                              password: "root", 
                            serverName: "localhost", 
                                dbName: "dbname", 
                                  port: 3306, 
                                socket: "/mysql/mysql.sock")

let coordinator = MySQLStoreCoordinator(user: user!)
coordinator.encoding = .UTF8MB4
coordinator.connect()
```
To end a connection:
```swift
coordinator.disconnect()
```

## Query Context

To execute a query you have to create the context:
```swift
let context = MySQLQueryContext()
context.storeCoordinator = coordinator
```

### Execute Query

```swift
let dropQueryString = "DROP TABLE `MyTable`"
let dropQueryRequest = MySQLQueryRequest(queryString: dropQueryString)
try? context.execute(dropQueryRequest)
```

### SELECT 

The response contains the array of the dictionaries.

```swift
let query = MySQLQueryRequestFactory.select("tasks", condition: nil)
let response = try? context.executeQueryRequestAndFetchResult(query)
```

### INSERT

```swift
let query = MySQLQueryRequestFactory.insert("tasks", set: ["name": "Something", "desctiption": "new task"])
try? context.execute(query)
```

### UPDATE

```swift
let query = MySQLQueryRequestFactory.update("tasks", set: ["name": "Something"], condition: "id=7")
try? context.execute(query)
```

### DELETE

```swift
let query = MySQLQueryRequestFactory.delete("tasks", condition: "id=10")
try? context.execute(query)
```

### JOINs

You can execute 4 types of joins - `INNER`, `RIGHT`, `LEFT`, `FULL`.

```swift
let query = MySQLQueryRequestFactory.joinType(OHJoinInner, fromTable: "tasks", columnNames: ["id", "name", "description"], joinOn: ["subtasks": "tasks.id=subtasks.parentId"])
let result = try? context.executeQueryRequestAndFetchResult(query)
```

### Object Mapping

You have to implement the protocol `OHMappingProtocol` for your models. 
The library has only a primary logic for mapping, so I would recommend you writing a mapping logic by yourself. If you are using Swift you cannot use fundamental number types (`Int`, `Double`), only `NSNumber` (due to run-time). 

```swift
context.insertObject(task)
try? context.save()
```

You can update/delete the objects easily.

```swift
let task = Task()
task.name = "sample"
context.updateObject(task)
context.deleteObject(task)

try? context.save()
```

## Communication

- If you found a bug, have a suggestion or need help, [open the issue](https://github.com/oleghnidets/OHMySQL/issues/new).
- If you want to contribute, [submit a pull request](https://github.com/oleghnidets/OHMySQL/pulls).
- If you need help, [write me](oleg.oleksan@gmail.com).

## License 

See [LICENSE](LICENSE).

[platform-image]: https://img.shields.io/badge/platforms-ios%20|%20macOS%20|%20catalyst%20|%20tvOS%20|%20watchOS-orange.svg
[platform-url]: https://oleghnidets.github.io/OHMySQL/documentation/ohmysql
[license-image]: https://img.shields.io/badge/License-MIT-green.svg
[license-url]: LICENSE
[cocoapods-image]: https://img.shields.io/cocoapods/v/OHMySQL.svg?style=flat-square
[cocoapods-url]: OHMySQL.podspec
[carthage-image]: https://img.shields.io/badge/carthage-compatible-blue.svg
[carthage-url]: https://github.com/Carthage/Carthage
[docs-image]: https://img.shields.io/badge/documentation-DocC-lightgrey.svg
[docs-url]: https://oleghnidets.github.io/OHMySQL/documentation/ohmysql