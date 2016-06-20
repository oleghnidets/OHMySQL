//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLStoreCoordinator.h"

#import "OHMySQLUser.h"
#import "OHSSLConfig.h"
#import "OHMySQLStore.h"

#import <mysql.h>

@interface OHMySQLStoreCoordinator ()

@property (nonatomic, strong, readwrite) OHMySQLStore *store;
@property (nonatomic, strong) OHMySQLUser *user;
@property (assign, readwrite, nonnull) void *mysql;

@end

@implementation OHMySQLStoreCoordinator 

- (instancetype)initWithUser:(OHMySQLUser *)user {
    NSParameterAssert(user);
    if (self = [super init]) {
        _user = user;
    }
    
    return self;
}

- (void)dealloc {
    [self disconnect];
}

- (void)connect {
    static MYSQL local;
    
    mysql_library_init;
    
    mysql_init(&local);
    
    mysql_options(&local, MYSQL_OPT_COMPRESS, 0);
    my_bool reconnect = 1;
    mysql_options(&local, MYSQL_OPT_RECONNECT, &reconnect);
    mysql_options(&local, MYSQL_OPT_PROTOCOL, &_protocol);
    
    OHSSLConfig *SSLconfig = self.user.sslConfig;
    if (SSLconfig) {
        mysql_ssl_set(&local, SSLconfig.key.UTF8String, SSLconfig.certPath.UTF8String,
                      SSLconfig.certAuthPath.UTF8String, SSLconfig.certAuthPEMPath.UTF8String,
                      SSLconfig.cipher.UTF8String);
    }
    
    if (!mysql_real_connect(&local, _user.serverName.UTF8String, _user.userName.UTF8String, _user.password.UTF8String, _user.dbName.UTF8String, (unsigned int)_user.port, _user.socket.UTF8String, 0)) {
        OHLogError(@"Failed to connect to database: Error: %s", mysql_error(&local));
    } else {
        _mysql = &local;
    }
}

- (OHResultErrorType)selectDataBase:(NSString *)database {
    NSParameterAssert(database);
    @synchronized (self) {
        return mysql_select_db(_mysql, database.UTF8String);
    }
}

- (OHResultErrorType)shutdown {
    @synchronized (self) {
        return mysql_shutdown(_mysql, SHUTDOWN_DEFAULT);
    }
}

- (void)disconnect {
    @synchronized (self) {
        if (_mysql != NULL) {
            mysql_close(_mysql);
            _mysql = nil;
            mysql_library_end;
        }
    }
}

- (OHResultErrorType)refresh:(OHRefreshOptions)options {
    @synchronized (self) {
        return mysql_refresh(_mysql, options);
    }
}

- (OHResultErrorType)pingMySQL {
    @synchronized (self) {
        return _mysql != NULL ? mysql_ping(_mysql) : OHResultErrorTypeUnknown;
    }
}

- (BOOL)isConnected {
    return (_mysql != NULL) && ![self pingMySQL];
}

@end
