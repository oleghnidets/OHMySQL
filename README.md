# OHMySQL
You can connect to your remote MySQL database using OHMySQL API. It allows you doing queries in easy and object-oriented way. Common queries such as SELECT, INSERT, DELETE, JOIN are wrapped by Objective-C code and you don't need to dive into MySQL C API.

## Usage

At the first you need to connect to database.

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
NSDictionary *first = [[OHMySQLManager sharedManager] selectFirst:@"users" condition:@"" orderBy:@[@"id"] ascending:NO].firstObject;
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
    
    
## License 

The MIT License (MIT)
    
