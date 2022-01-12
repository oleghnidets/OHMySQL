# OHMySQL

[![License][license-image]][license-url]
[![License][platform-image]][platform-url]
[![Documentation][docs-image]][docs-url]

The library supports Objective-C and Swift, iOS and macOS. You can connect to your remote MySQL database using OHMySQL API. It allows you doing queries in easy and object-oriented way. Common queries such as SELECT, INSERT, DELETE, JOIN are wrapped by Objective-C code and you don't need to dive into MySQL C API.
<p align="center" >★★ <b>Every star is appreciated!</b> ★★</p>

- [Goal](https://github.com/oleghnidets/OHMySQL/wiki/Goal)
- [Support](#support)
- [Features](#features)
- [Requirements](#requirements)
- [How To Get Started](#how-to-get-started)
- [Installation](#installation)
- [Usage](#usage)
    - [Query Context](#query-context)
    - [Execute Query](#execute-query)
    - [SELECT](#select)
    - [INSERT](#insert)
    - [UPDATE](#update)
    - [DELETE](#delete)
    - [JOINs](#joins)
    - [Object Mapping](#object-mapping)
    - [Set up SSL](https://github.com/oleghnidets/OHMySQL/wiki/Set-up-SSL)
- [Communication](#communication)
- [License](#license)

## Goal

If you are interested in and want to know [how it can be applied](https://github.com/oleghnidets/OHMySQL/wiki/Goal) in your project too. 

## Support

I wish to support the library and extend API and functionality. If you donate me some money 💵, it keeps me motivated and happy 🙂 You may support me via [PayPal](
https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YCAKYM4XCT2DG&source=url ) or let me know any other method convenient for you.

## Features

- [x] Easy to integrate and use
- [x] Many functionality features
- [x] Requires minimal knowledge in SQL
- [x] Supports iOS and macOS
- [x] Clean code with unit tests
- [x] [Complete documentation](http://oleghnidets.github.io/OHMySQL/) and [support](https://github.com/oleghnidets/OHMySQL/issues?q=is%3Aissue+is%3Aclosed)

## Requirements

- iOS 14.0+ / macOS 11.0+ (for more previous versions use [2.1.3](https://github.com/oleghnidets/OHMySQL/releases/tag/2.1.3))
- Xcode 12.0+

## How To Get Started

- To test locally you can install [MySQL](https://dev.mysql.com/downloads/mysql/) or [MAMP local server](https://www.mamp.info/en/).
- Try to use OHMySQL API ([set up demo project](https://github.com/oleghnidets/OHMySQL/wiki/Set-up-demo-project), [read documentation](http://oleghnidets.github.io/OHMySQL/)). 
- When it'll be ready then transfer your local Data Base(s) to remote MySQL server.

## Installation

You can use CocoaPods. Add the following line to your Podfile:
```ruby
pod 'OHMySQL' --repo-update
```

If you are using Swift do not forget to add `use_frameworks!` at the top of Podfile. Add platform, example `platform :osx, '11.0'`.

## Usage

Connect to the database.

```swift
let user = MySQLConfiguration(userName: "root", password: "root", serverName: "localhost", dbName: "dbname", port: 3306, socket: "/mysql/mysql.sock")
let coordinator = MySQLStoreCoordinator(user: user!)
coordinator.encoding = .UTF8MB4
coordinator.connect()
```
```objc
OHMySQLConfiguration *config = [[OHMySQLConfiguration alloc] initWithUserName:@"root"
                                                                     password:@"root"
                                                                   serverName:@"localhost"
                                                                       dbName:@"dbname"
                                                                         port:3306
                                                                       socket:@"/mysql/mysql.sock"];
OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:config];
[coordinator connect];
```
To end a connection:
```swift
coordinator.disconnect()
```
```objc
[coordinator disconnect];
```
## Query Context

To execute a query you have to create the context:
```swift
let context = MySQLQueryContext()
context.storeCoordinator = coordinator
```
```objc
OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
queryContext.storeCoordinator = coordinator;
```

You will use this context to execute queries or manipulate the objects.

### Execute Query

```swift
let dropQueryString = "DROP TABLE `MyTable`"
let dropQueryRequest = MySQLQueryRequest(queryString: dropQueryString)
try? self.mainQueryContext.execute(dropQueryRequest)
```

```objc
NSString *dropQueryString = @"DROP TABLE `MyTable`";
OHMySQLQueryRequest *dropQueryRequest = [[OHMySQLQueryRequest alloc] initWithQueryString:dropQueryString];
    
NSError *error;
[self.mainQueryContext executeQueryRequest:dropQueryRequest error:&error];
```

### SELECT 

The response contains array of dictionaries (like JSON).

```swift
let query = MySQLQueryRequestFactory.select("tasks", condition: nil)
let response = try? MySQLContainer.shared.mainQueryContext?.executeQueryRequestAndFetchResult(query)
```
```objc
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tasks" condition:nil];
NSError *error = nil;
NSArray *tasks = [queryContext executeQueryRequestAndFetchResult:query error:&error];
```
You will get a response like this:
```objc
[{ @"id": @1, @"name": @"Task name", @"description": @"Task description", @"status": [NSNull null] }]
```

### INSERT

```swift
let query = MySQLQueryRequestFactory.insert("tasks", set: ["name": "Something", "desctiption": "new task"])
try? mainQueryContext?.execute(query)
```
```objc
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory INSERT:@"tasks" set:@{ @"name": @"Something", @"desctiption": @"new task" }];
NSError error;
[queryContext executeQueryRequest:query error:&error];
```

### UPDATE

```swift
let query = MySQLQueryRequestFactory.update("tasks", set: ["name": "Something"], condition: "id=7")
try? mainQueryContext?.execute(query)
```
```objc
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory UPDATE:@"tasks" set:@{ @"name": @"Something", @"description": @"new task update" } condition:@"id=5"];
NSError error;
[queryContext executeQueryRequest:query error:&error];
```

### DELETE

```swift
let query = MySQLQueryRequestFactory.delete("tasks", condition: "id=10")
try? mainQueryContext?.execute(query)
```
```objc
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory DELETE:@"tasks" condition:@"id=10"];
NSError error;
[queryContext executeQueryRequest:query error:&error];
```

### JOINs

The response contains array of dictionaries (like JSON). You can do 4 types of joins (INNER, RIGHT, LEFT, FULL) using string constants.

```swift
let query = MySQLQueryRequestFactory.joinType(OHJoinInner, fromTable: "tasks", columnNames: ["id", "name", "description"], joinOn: ["subtasks": "tasks.id=subtasks.parentId"])
let result = try? mainQueryContext?.executeQueryRequestAndFetchResult(query)
```
```objc
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory JOINType:OHJoinInner					
                                                        fromTable:@"tasks" 
                                                      columnNames:@[@"id", @"name", @"description"] 
                                                           joinOn:@{ @"subtasks":@"tasks.id=subtasks.parentId" }];
NSArray *results = [queryContext executeQueryRequestAndFetchResult:query error:nil];
```

### Object Mapping

You have to implement the protocol OHMappingProtocol for your models. Insertion looks like the following (in this example the NSManagedObject instance). 
The library has only a primary logic for mapping, so I would recommend you writing a mapping logic by yourself. If you are using Swift you cannot use fundamental number types (Int, Double), only NSNumber (due to run-time). 
```swift
mainQueryContext?.insertObject(task)
try? mainQueryContext?.save()
```
```objc
[queryContext insertObject:task];
BOOL result = [queryContext save:nil];
```

You can update/delete the objects easily.

```swift
let task = Task()
task.name = "sample"
mainQueryContext?.updateObject(task)
mainQueryContext?.deleteObject(task)

try? mainQueryContext?.save()
```
```objc
// You don't need to specify primary index here.  It'll be updated automatically.
OHTask *task = [OHTask new];
task.name = @"Code cleanup";
task.taskDescription = @"Delete unused classes and files";
task.status = 0;
[queryContext updateObject:task];
...
task.name = @"Something";
task.status = 1;
[task update];
...
[queryContext deleteObject:task];
BOOL result = [queryContext save:nil];
```

## Communication

- If you found a bug, have suggestions or need help, please, [open an issue](https://github.com/oleghnidets/OHMySQL/issues/new).
- If you want to contribute, [submit a pull request](https://github.com/oleghnidets/OHMySQL/pulls).
- If you need help, write me oleg.oleksan@gmail.com.
- Make me feel happier ;]

  [![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CVFAEEZJ9DJ3L)

## License 

OHMySQL is released under the MIT license. See [LICENSE](LICENSE) for details.

[platform-image]: https://img.shields.io/badge/platform-ios%20%7C%20macOS-lightgrey.svg
[platform-url]: https://github.com/oleghnidets/OHMySQL
[docs-image]: https://github.com/oleghnidets/OHMySQL/blob/master/docs/badge.svg
[docs-url]: http://oleghnidets.github.io/OHMySQL/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
