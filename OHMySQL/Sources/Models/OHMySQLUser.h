//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2018 Oleg Hnidets. All rights reserved.
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


/**
 Initializes and returns a newly allocated object.

 @param name The name of connecting user.
 @param password User' password.
 @param serverName A host name or an IP address.
 @param dbName The name of database
 @param port Port number for TCP/IP connection.
 @param socket The socket or named pipe to use
 @return User object with the specified parameters
 */
- (nullable instancetype)initWithUserName:(nonnull NSString *)name
                                 password:(nonnull NSString *)password
                               serverName:(nonnull NSString *)serverName
                                   dbName:(nonnull NSString *)dbName
                                     port:(NSUInteger)port
                                   socket:(nullable NSString *)socket;


/**
 Initializes and returns a newly allocated object.

 @param name The name of connecting user.
 @param password User' password.
 @param sslConfig SSL config object to estable SSL connection.
 @param serverName A host name or an IP address.
 @param dbName The name of database.
 @param port Port number for TCP/IP connection.
 @param socket The socket or named pipe to use
 @return User object with the specified parameters
 */
- (nullable instancetype)initWithUserName:(nonnull NSString *)name
                                 password:(nonnull NSString *)password
                                sslConfig:(nonnull OHSSLConfig *)sslConfig
                               serverName:(nonnull NSString *)serverName
                                   dbName:(nonnull NSString *)dbName
                                     port:(NSUInteger)port
                                   socket:(nullable NSString *)socket;

@end
