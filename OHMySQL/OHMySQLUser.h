//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHSSLConfig.h"

@interface OHMySQLUser : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *userName;
@property (nonatomic, copy, readonly, nonnull) NSString *password;
@property (nonatomic, copy, readonly, nonnull) NSString *serverName;
@property (nonatomic, copy, readonly, nonnull) NSString *dbName;
@property (nonatomic, copy, readonly, nullable) NSString *socket;

@property (nonatomic, assign, readonly) NSUInteger port;
@property (nonatomic, copy, readonly, nullable) OHSSLConfig *sslConfig;

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
