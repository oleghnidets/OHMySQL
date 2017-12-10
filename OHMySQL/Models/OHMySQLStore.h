//  Created by Oleg Hnidets on 6/14/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;

/// An object of this class contains details about a store MySQL.  
@interface OHMySQLStore : NSObject

- (nonnull instancetype)initWithMySQL:(nonnull void *const)mysql;

/// Returns a string that represents the MySQL server version; for example, "5.7.14".
@property (nonatomic, copy, readonly, nonnull) NSString *serverInfo;

/// Returns a string describing the type of connection in use, including the server host name.
@property (nonatomic, copy, readonly, nonnull) NSString *hostInfo;

/// An unsigned integer representing the protocol version used by the current connection.
@property (nonatomic, assign, readonly) NSUInteger protocolInfo;

/// An integer that represents the MySQL server version. For example, "5.7.14" is returned as 50714.
@property (nonatomic, assign, readonly) NSInteger serverVersion;

/// A character string describing the server status. nil if an error occurred.
@property (nonatomic, copy, readonly, nullable) NSString *status;

@end
