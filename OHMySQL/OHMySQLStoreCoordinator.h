//  Created by Oleg Hnidets on 6/14/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHConstants.h"

@class OHMySQLUser, OHMySQLStore;

@interface OHMySQLStoreCoordinator : NSObject

/// Nonnull after connection with DB. 
@property (nonatomic, strong, readonly, nullable) OHMySQLStore *store;

/// Nonnull after connection with DB.
@property (nonatomic, strong, readonly, nullable) OHMySQLUser *user;

/// Nonnull after connection with DB. You don't need to use this property at all.
@property (readonly, nullable) void *mysql;

/// Pings the server and indicates whether the connection to the server is working.
@property (assign, readonly, getter=isConnected) BOOL connected;

/// One of the protocols. Needs to be set before calling -connect.
@property (nonatomic, assign) OHProtocolType protocol;

/// The default character set for the current connection. By default UTF-8.
@property (nonatomic, assign) CharsetEncoding encoding;

- (nonnull instancetype)initWithUser:(nonnull OHMySQLUser *)user;

/// Attempts to establish a connection to a MySQL database engine. Also tries establish SSL connection if it is specified.
- (void)connect;

/**
 *  @param database Name of the target db.
 *
 *  @return Zero for success. Nonzero if an error occurred (see enum).
 */
- (OHResultErrorType)selectDataBase:(nonnull NSString *)database;

/// Closes a previously opened connection.
- (void)disconnect;

/**
 *  Asks the database server to shut down. The connected user must have the SHUTDOWN privilege.
 *
 *  @return Zero for success. Nonzero if an error occurred.
 */
- (OHResultErrorType)shutdown;

/**
 *  Flushes tables or caches, or resets replication server information. The connected user must have the RELOAD privilege.
 *
 *  @param options A bit mask composed from any combination.
 *
 *  @return Zero for success. Nonzero if an error occurred (see enum).
 */
- (OHResultErrorType)refresh:(OHRefreshOptions)options;

/**
 *  Checks whether the connection to the server is working. If the connection has gone down and auto-reconnect is enabled an attempt to reconnect is made.
 *
 *  @return Zero if the connection to the server is active. Nonzero if an error occurred. A nonzero return does not indicate whether the MySQL server itself is down; the connection might be broken for other reasons such as network problems.
 */
- (OHResultErrorType)pingMySQL __attribute__((warn_unused_result));

@end
