//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@interface OHMySQLUser : NSObject

@property (nonatomic, copy, readonly, nonnull) NSString *userName;
@property (nonatomic, copy, readonly, nonnull) NSString *password;
@property (nonatomic, copy, readonly, nonnull) NSString *serverName;
@property (nonatomic, copy, readonly, nonnull) NSString *dbName;
@property (nonatomic, copy, readonly, nullable) NSString *socket;

@property (nonatomic, assign, readonly) NSUInteger port;

- (nullable instancetype)initWithUserName:(nonnull NSString *)name
                                 password:(nonnull NSString *)password
                               serverName:(nonnull NSString *)serverName
                                   dbName:(nonnull NSString *)dbName
                                     port:(NSUInteger)port
                                   socket:(nullable NSString *)socket;

@end
