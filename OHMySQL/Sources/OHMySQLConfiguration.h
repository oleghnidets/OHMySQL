//
//  Copyright (c) 2015-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

@import Foundation;
#import "OHSSLConfig.h"

NS_SWIFT_NAME(MySQLConfiguration)
/// The entity that has authority to use a store MySQL. 
@interface OHMySQLConfiguration : NSObject

/// Can be up to 16 characters long. Operating system user names may be of a different maximum length.
@property (nonatomic, copy, nonnull, readonly) NSString *username;

/// User' password for authentication. https://dev.mysql.com/doc/refman/5.5/en/password-security-user.html
@property (nonatomic, copy, nonnull, readonly) NSString *password;

/// A host name or an IP address.
/// @note Note that the host parameter determines the type of the connection.
@property (nonatomic, copy, nonnull, readonly) NSString *serverName;

/// The string specifies the name of database.
@property (nonatomic, copy, nonnull, readonly) NSString *dbName;

/// If it is not NULL, the string specifies the socket or named pipe to use.
@property (nonatomic, copy, nullable, readonly) NSString *socket;

/// If it is not 0, the value is used as the port number for the TCP/IP connection.
@property (nonatomic, assign) NSUInteger port;

/// Used for establishing secure connections using SSL.
@property (nonatomic, copy, nullable, readonly) OHSSLConfig *sslConfig;

/// The timeout in seconds for each attempt to write to the server. There is a retry if necessary, so the total effective timeout value is two times the option value.
@property (nonatomic, copy, nullable) NSNumber *writeTimeout;

/// The timeout in seconds for each attempt to read from the server. There are retries if necessary, so the total effective timeout value is three times the option value. You can set the value so that a lost connection can be detected earlier than the TCP/IP Close Wait Timeout value of 10 minutes.
@property (nonatomic, copy, nullable) NSNumber *readTimeout;


/// Initializes and returns a newly allocated object.
/// - Parameters:
///   - user: The name of connecting user.
///   - password: The name of connecting user.
///   - serverName: User' password.
///   - dbName: The name of database
///   - port: Port number for TCP/IP connection.
///   - socket: The socket or named pipe to use.
- (nonnull instancetype)initWithUser:(nonnull NSString *)user
                            password:(nonnull NSString *)password
                          serverName:(nonnull NSString *)serverName
                              dbName:(nonnull NSString *)dbName
                                port:(NSUInteger)port
                              socket:(nullable NSString *)socket;

/// Initializes and returns a newly allocated object.
/// - Parameters:
///   - user: The name of connecting user.
///   - password: The name of connecting user.
///   - sslConfig: SSL config object to estable SSL connection.
///   - serverName: User' password.
///   - dbName: The name of database
///   - port: Port number for TCP/IP connection.
///   - socket: The socket or named pipe to use.
- (nonnull instancetype)initWithUser:(nonnull NSString *)user
                            password:(nonnull NSString *)password
                           sslConfig:(nonnull OHSSLConfig *)sslConfig
                          serverName:(nonnull NSString *)serverName
                              dbName:(nonnull NSString *)dbName
                                port:(NSUInteger)port
                              socket:(nullable NSString *)socket;

@end
