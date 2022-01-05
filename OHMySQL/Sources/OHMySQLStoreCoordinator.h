//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

@import Foundation;
#import "OHConstants.h"

@class OHMySQLConfiguration, OHMySQLStore;

NS_SWIFT_NAME(MySQLStoreCoordinator)
@interface OHMySQLStoreCoordinator : NSObject

/// Nonnull after connection with DB. 
@property (nonatomic, strong, readonly, nullable) OHMySQLStore *store;

/// Nonnull after connection with DB.
@property (nonatomic, strong, readonly, nullable) OHMySQLConfiguration *configuration;

/// Nonnull after connection with DB. You don't need to use this property at all.
@property (readonly, nullable) void *mysql NS_REFINED_FOR_SWIFT;

/// Pings the server and indicates whether the connection to the server is working.
@property (assign, readonly, getter=isConnected) BOOL connected;

/// One of the protocols. Needs to be set before calling -connect.
@property (nonatomic, assign) OHProtocolType protocol;

/// The default character set for the current connection. By default UTF-8.
@property (nonatomic, assign) CharsetEncoding encoding;

- (nonnull instancetype)initWithConfiguration:(nonnull OHMySQLConfiguration *)configuration;

/// Attempts to disconnect and then establish a connection to a MySQL database engine. Also tries establish SSL connection if it is specified.
- (BOOL)reconnect;

/// Attempts to establish a connection to a MySQL database engine. Also tries establish SSL connection if it is specified.
- (BOOL)connect;

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
- (OHResultErrorType)refresh:(OHRefreshOption)options;

/**
 *  Checks whether the connection to the server is working. If the connection has gone down and auto-reconnect is enabled an attempt to reconnect is made.
 *
 *  @return Zero if the connection to the server is active. Nonzero if an error occurred. A nonzero return does not indicate whether the MySQL server itself is down; the connection might be broken for other reasons such as network problems.
 */
- (OHResultErrorType)pingMySQL __attribute__((warn_unused_result));

@end
