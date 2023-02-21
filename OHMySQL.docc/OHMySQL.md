# ``OHMySQL``

The framework allows to establish a connection with MySQL database. The framework supports Objective-C and Swift, iOS, macOS, Catalyst, tvOS, watchOS. 

## Overview

OHMySQL can connect to remote or local MySQL database and execute CRUD operations. The framework is built upon MySQL C API, but you don't need to dive into low-level.
The following diagram represents a general architecture. Logic (saving, editing, removing etc.) is aggregated in the app. The database is just a shared storage.

![Simple Diagram](diagram.png)

## Topics

### Essentials

- <doc:Installation>
- <doc:GettingStarted>

### Setup connection

- ``OHMySQLConfiguration``
- ``OHSSLConfig``
- ``OHMySQLStoreCoordinator``
- ``OHMySQLContainer``
- ``OHMySQLQueryContext``

### Execute Query

- ``OHMySQLQueryRequest``
- ``OHMySQLQueryRequestFactory``

### Object Mapping

- ``OHMySQLMappingProtocol``

