# OHMySQL
You can connect to your remote MySQL database using OHMySQL API. It allows you doing queries in easy and object-oriented way. Common queries such as SELECT, INSERT, DELETE, JOIN are wrapped by Objective-C code and you don't need to dive into MySQL C API.

## How To Get Started
- To test locally you can install [MySQL](https://dev.mysql.com/downloads/mysql/) or [MAMP local server](https://www.mamp.info/en/).
- Try to use OHMySQL API. 
- When it'll be ready then transfer your local Data Base(s) to remote MySQL server.

## Installation
You can use CocoaPods. Add the following line to your Podfile:
```objective-c
pod 'OHMySQL', '~> 0.1.0'
```

Or you can copy files into your project. But be aware you need to copy [mysql-connector-c](https://github.com/ketzusaka/mysql-connector-c) library.

## Usage

At the first you need to connect to the database.

```objective-c
OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root"
                                                 password:@"root"
                                               serverName:@"localhost"
                                                   dbName:@"RateIt"
                                                     port:3306
                                                   socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
[[OHMySQLManager sharedManager] connectWithUser:user];
```

To end a connection:
```objective-c
[[OHMySQLManager sharedManager] disconnect];
```
### SELECT 

The response contains array of dictionaries (like JSON).

```objective-c
NSArray *all = [[OHMySQLManager sharedManager] selectAll:@"users" condition:nil]);
NSArray *orderedAll = [[OHMySQLManager sharedManager] selectAll:@"users" condition:@"" orderBy:@[@"name", @"id"] ascending:YES]);
NSDictionary *first = [[OHMySQLManager sharedManager] selectFirst:@"users" condition:@"" orderBy:@[@"id"] ascending:NO];
```

### JOINs

The response contains array of dictionaries (like JSON). You can do 4 types of joins (INNER, RIGHT, LEFT, FULL) using string constants.
```objective-c
NSArray *response = [[OHMySQLManager sharedManager] selectJoinType:OHJoinRight
                                                              from:@"users"
                                                              join:@"students"
                                                       columnNames:@[@"students.groupID", @"users.name", @"users.lastname"]
                                                       onCondition:@"users.id=students.userId"];
                                   
```

### INSERT, DELETE

The response returns zero for success or nonzero if an error occurred. 
```objective-c
NSLog(@"%li", [[OHMySQLManager sharedManager] insertInto:@"students" set:@{ @"groupId" : @"1", @"userId" : first[@"id"] }]);
```

```objective-c
NSLog(@"%li", [[OHMySQLManager sharedManager] deleteAllFrom:@"users" condition:@"id>3"]);
```
    
### Mapping

Mapping response looks like the following:
```objective-c
OHTask *task = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
[task mapFromResponse:taskDict];
```

Also you can send your local changes to DB easily.
```objective-c
// Use autoincremented id in your DB. So you don't need to specify id here. 
OHTask *task = [OHTask new];
task.name = @"Code cleanup";
task.taskDescription = @"Delete unused classes and files";
task.status = 0;
[task insert]; // Also update local taskId
...
task.name = @"Something";
task.status = 1;
[task update];
...
[task deleteObject];
```

## Communication
- If you need help, write (me)[oleg.oleksan@gmail.com]
- If you found a bug, please provide steps to reproduce it, open an issue.
- If you want to contribute, submit a pull request.

## License 

The MIT License (MIT)
    
