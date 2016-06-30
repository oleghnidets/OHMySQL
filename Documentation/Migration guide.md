# Migration guide 
The problem of the previous release was accumulated logic in one class (God Class) - OHMySQLManager. Although, it was simple to setup and use code however it was difficult to scale project with different databases. The core of code remains the same. The current architecture could remind you Core Data stack. And it's piece of truth, because I tried to be consistent with already implemented solutions.

This guide show you how to make the transition.

## Benefits 
* Possibility to work with many databases.
* Improved stability of code - fixed crashes, improved unit-tests.
* Enhancements for multithreading.
* Code is now flexible for your needs.
* Be up-to-date - changes for multithreading will come soon.

### Connect to database 
Connection is being made by OHMySQLStoreCoordinator.

    OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
    [coordinator connect];
It establishes connection. To check connectivity use property isConnected of the class.

### Query execution
Responsibility of making queries is under OHMySQLQueryContext. Before making a query assign store coordinator for context.

    OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
    queryContext.storeCoordinator = coordinator;

### Query Request
In order to provide convenience interface I made OHMySQLQueryRequest class. Don't afraid I also created the class OHMySQLQueryRequestFactory which creates instances of OHMySQLQueryRequest in easy way.

    OHMySQLQueryRequest *queryRequest = [OHMySQLQueryRequestFactory SELECT:@"tasks" condition:nil];
As you can see query request is ready so it's time to execute it.

### Query Execution
We've created instance of OHMySQLQueryContext. So let's use it:

    NSError *error = nil;
    NSArray *tasks = [queryContext executeQueryRequestAndFetchResult:query error:&error];
Use  -executeQueryRequestAndFetchResult:error: method if you want to get some results. When you want to execute query use -executeQueryRequest:error:

    NSError *error = nil;
    BOOL isSuccessful = [queryContext executeQueryRequest:query error:&error];


### "Horrible" Manager
OHMySQLManager' functionality was cut and now it serves for using one general context and storeCoordinator in application. It's handful to use this singleton when you have and work only with one database.
For using this manager you have to assign main context (coordinator is returned from context):

    [OHMySQLManager sharedManager].mainQueryContext = queryContext;


### Object Mapping
To map objects you have to implement the protocol OHMappingProtocol. If you used it before replace method -indexKey with -primaryKey. 
To insert/update/delete object you have methods in OHMySQLQueryContext class. When you're ready to submit changes just call the method -save:

   [queryContext insertObject:task1];
   [queryContext updateObject:task2];
   [queryContext deleteObject:task3];
   [queryContext save:nil];
I ignored error here but be sensible and handle errors in proper way.
