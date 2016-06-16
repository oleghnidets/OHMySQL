//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHConstants.h"
#import <mysql.h>

@class OHMySQLUser;

@interface OHMySQLStoreCoordinator : NSObject

//! Nonnull after connection with DB.
@property (assign, readonly, nonnull) MYSQL *mysql;

//! Pings the server and indicates whether the connection to the server is working.
@property (assign, readonly, getter=isConnected) BOOL connected;

- (nonnull instancetype)initWithUser:(nonnull OHMySQLUser *)user;

//! Attempts to establish a connection to a MySQL database engine. Also tries establish SSL connection if it is specified.
- (void)connect;

//! Closes a previously opened connection.
- (void)disconnect;

/**
 *  Flushes tables or caches, or resets replication server information. The connected user must have the RELOAD privilege.
 *
 *  @param Options A bit mask composed from any combination.
 *
 *  @return Zero for success. Nonzero if an error occurred (see enum).
 */
- (OHResultErrorType)refresh:(OHRefreshOptions)options;

/**
 *  Checks whether the connection to the server is working. If the connection has gone down and auto-reconnect is enabled an attempt to reconnect is made.
 *
 *  @return Zero if the connection to the server is active. Nonzero if an error occurred. A nonzero return does not indicate whether the MySQL server itself is down; the connection might be broken for other reasons such as network problems.
 */
- (OHResultErrorType)pingMySQL;

@end
