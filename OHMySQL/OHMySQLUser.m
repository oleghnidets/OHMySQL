//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLUser.h"

@interface OHMySQLUser ()

@property (nonatomic, copy, readwrite) NSString *userName;
@property (nonatomic, copy, readwrite) NSString *password;
@property (nonatomic, copy, readwrite) NSString *serverName;
@property (nonatomic, copy, readwrite) NSString *dbName;
@property (nonatomic, copy, readwrite) NSString *socket;

@property (nonatomic, assign, readwrite) NSUInteger port;

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

@end
