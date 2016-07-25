# OHMySQL
You can connect to your remote MySQL database using OHMySQL API. It allows you doing queries in easy and object-oriented way. Common queries such as SELECT, INSERT, DELETE, JOIN are wrapped by Objective-C code and you don't need to dive into MySQL C API.

## How To Get Started
- To test locally you can install [MySQL](https://dev.mysql.com/downloads/mysql/) or [MAMP local server](https://www.mamp.info/en/).
- Try to use OHMySQL API ([set up demo project](https://github.com/oleghnidets/OHMySQL/blob/master/Documentation/Demo.md)). 
- When it'll be ready then transfer your local Data Base(s) to remote MySQL server.

## Installation
You can use CocoaPods. Add the following line to your Podfile:
```objective-c
pod 'OHMySQL', '~> 0.1.0'
```

Or you can copy files into your project. But be aware you need to copy [mysql-connector-c](https://github.com/ketzusaka/mysql-connector-c) library.

## Migration Guide
- [OHMySQL 0.2.0 Migration Guide](https://github.com/oleghnidets/OHMySQL/blob/master/Documentation/Migration%20guide.md)

## Usage

At the first you need to connect to the database.

```objective-c
OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root"
                                                 password:@"root"
                                               serverName:@"localhost"
                                                   dbName:@"sample"
                                                     port:3306
                                                   socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
[coordinator connect];
```

To end a connection:
```objective-c
[coordinator disconnect];
```

## Query Context

To execute a query you have to create the context:
```objective-c
OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
queryContext.storeCoordinator = coordinator;
```

You will use this context to execute queries or manipulate the objects.

### SELECT 

The response contains array of dictionaries (like JSON).

```objective-c
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"tasks" condition:nil];
NSError *error = nil;
NSArray *tasks = [queryContext executeQueryRequestAndFetchResult:query error:&error];
```
You will get a response like this:
```objective-c
[{ @"id": @1, @"name": @"Task name", @"description": @"Task description", @"status": [NSNull null] }]
```

### INSERT

```objective-c
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory INSERT:@"tasks" set:@{ @"name": @"Something", @"desctiption": @"new task" }];
NSError error;
[queryContext executeQueryRequest:query error:&error];
```

### UPDATE

```objective-c
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory UPDATE:@"tasks" set:@{ @"name": @"Something", @"desctiption": @"new task update" } condition:@"id=5"];
NSError error;
[queryContext executeQueryRequest:query error:&error];
```

### DELETE

```objective-c
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory DELETE:@"tasks" condition:@"id=10"];
```
    
### JOINs

The response contains array of dictionaries (like JSON). You can do 4 types of joins (INNER, RIGHT, LEFT, FULL) using string constants.
```objective-c
OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory JOINType:OHJoinInner
                                                        fromTable:@"tasks"
                                                      columnNames:@[@"id", @"name", @"description"]
                                                           joinOn:@{ @"subtasks":@"tasks.id=subtasks.parentId" }];
NSArray *results = [queryContext executeQueryRequestAndFetchResult:query error:nil];
```

### Object Mapping

You have to implement the protocol OHMappingProtocol for your models. Insertion looks like the following (in this example the NSManagedObject instance).
```objective-c
[queryContext insertObject:task];
BOOL result = [queryContext save:nil];
```

You can update/delete the objects easily.
```objective-c
// You don't need to specify primary index here.  It'll be update for you.
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
- If you need help, write email://oleg.oleksan@gmail.com
- If you found a bug, please provide steps to reproduce it, open an issue.
- If you want to contribute, submit a pull request.
- If you want to donate I would be thankful ;]

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CVFAEEZJ9DJ3L)

## License 

The MIT License (MIT)
    
