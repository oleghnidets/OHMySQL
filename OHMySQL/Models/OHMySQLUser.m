//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLUser.h"

@interface OHMySQLUser ()
@end

@implementation OHMySQLUser

- (instancetype)initWithUserName:(NSString *)name
                        password:(NSString *)password
                      serverName:(NSString *)serverName
                          dbName:(NSString *)dbName
                            port:(NSUInteger)port
                          socket:(NSString *)socket {
    if (self = [super init]) {
        _userName   = name;
        _password   = password;
        _serverName = serverName;
        _dbName     = dbName;
        _port       = port;
        _socket     = socket;
    }
    
    return self;
}

- (instancetype)initWithUserName:(NSString *)name
                        password:(NSString *)password
                       sslConfig:(OHSSLConfig *)sslConfig
                      serverName:(NSString *)serverName
                          dbName:(NSString *)dbName
                            port:(NSUInteger)port
                          socket:(NSString *)socket {
    self = [self initWithUserName:name password:password serverName:serverName dbName:dbName port:port socket:socket];
    if (self) {
        _sslConfig = sslConfig;
    }
    
    return self;
}

@end
