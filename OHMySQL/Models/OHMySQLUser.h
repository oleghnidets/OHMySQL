//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHSSLConfig.h"

/// The entity that has authority to use a store MySQL. 
@interface OHMySQLUser : NSObject

/// Can be up to 16 characters long. Operating system user names may be of a different maximum length.
@property (nonatomic, copy, nonnull) NSString *userName;

/// User' password for authentication. https://dev.mysql.com/doc/refman/5.5/en/password-security-user.html
@property (nonatomic, copy, nonnull) NSString *password;

/// A host name or an IP address.
/// @note Note that the host parameter determines the type of the connection.
@property (nonatomic, copy, nonnull) NSString *serverName;

/// The string specifies the name of database.
@property (nonatomic, copy, nonnull) NSString *dbName;

/// If it is not NULL, the string specifies the socket or named pipe to use.
@property (nonatomic, copy, nullable) NSString *socket;

/// If it is not 0, the value is used as the port number for the TCP/IP connection.
@property (nonatomic, assign) NSUInteger port;

/// Used for establishing secure connections using SSL.
@property (nonatomic, copy, nullable) OHSSLConfig *sslConfig;

- (nullable instancetype)initWithUserName:(nonnull NSString *)name
                                 password:(nonnull NSString *)password
                               serverName:(nonnull NSString *)serverName
                                   dbName:(nonnull NSString *)dbName
                                     port:(NSUInteger)port
                                   socket:(nullable NSString *)socket;

- (nullable instancetype)initWithUserName:(nonnull NSString *)name
                                 password:(nonnull NSString *)password
                                sslConfig:(nonnull OHSSLConfig *)sslConfig
                               serverName:(nonnull NSString *)serverName
                                   dbName:(nonnull NSString *)dbName
                                     port:(NSUInteger)port
                                   socket:(nullable NSString *)socket;

@end
