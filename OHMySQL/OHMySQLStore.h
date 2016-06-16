//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import <mysql.h>

@interface OHMySQLStore : NSObject

- (nonnull instancetype)initWithMySQL:(nonnull MYSQL *const)mysql;

//! Returns a string that represents the MySQL server version; for example, "5.7.14".
@property (nonatomic, copy, nonnull) NSString *serverInfo;
//! Returns a string describing the type of connection in use, including the server host name.
@property (nonatomic, copy, nonnull) NSString *hostInfo;
//! An unsigned integer representing the protocol version used by the current connection.
@property (nonatomic, assign) NSUInteger protocolInfo;
//! An integer that represents the MySQL server version. For example, "5.7.14" is returned as 50714.
@property (nonatomic, assign) NSInteger serverVersion;
//! A character string describing the server status. nil if an error occurred.
@property (nonatomic, copy, nullable) NSString *status;

@end
