//
// Copyright (c) 2015-Present Oleg Hnidets
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "OHMySQLStoreCoordinator.h"

#import "OHMySQLConfiguration.h"
#import "OHSSLConfig.h"
#import "OHMySQLStore.h"
#import "CharsetEncoding.h"

@import MySQL;

@interface OHMySQLStoreCoordinator ()

@property (nonatomic, strong, readwrite) OHMySQLStore *store;
@property (nonatomic, strong, readwrite) OHMySQLConfiguration *configuration;

@end

@implementation OHMySQLStoreCoordinator

- (void *)mysql {
    return self.store.mysql;
}

- (void)setEncoding:(CharsetEncoding)encoding {
	_encoding = encoding;
	[self configureConnectionForEncoding:encoding];
}

- (instancetype)initWithConfiguration:(OHMySQLConfiguration *)configuration {
    NSParameterAssert(configuration);
    if (self = [super init]) {
        _configuration = configuration;
		_encoding = CharsetEncodingUTF8;
    }
    
    return self;
}

- (void)dealloc {
    mysql_library_end;
}

- (BOOL)reconnect {
    @synchronized (self) {
        [self disconnect];
    
        return [self connect];
    }
}

- (BOOL)connect {
    @synchronized (self) {
        mysql_library_init;
        
        void *_mysql = mysql_init(NULL);
        self.store = [[OHMySQLStore alloc] initWithMySQL:_mysql];
        
        mysql_options(_mysql, MYSQL_OPT_COMPRESS, 0);
        bool reconnect = 1;
        mysql_options(_mysql, MYSQL_OPT_RECONNECT, &reconnect);
        mysql_options(_mysql, MYSQL_OPT_PROTOCOL, &_protocol);
        
        OHSSLConfig *SSLconfig = self.configuration.sslConfig;
        if (SSLconfig) {
            // https://dev.mysql.com/doc/refman/5.7/en/mysql-options.html
            // https://bugs.mysql.com/file.php?id=24546&bug_id=83338
            // https://github.com/sequelpro/sequelpro/issues/2499
            uint ssl_mode = SSL_MODE_REQUIRED;
            mysql_options(_mysql, MYSQL_OPT_SSL_MODE, &ssl_mode);
            
            mysql_ssl_set(_mysql, SSLconfig.key.UTF8String, SSLconfig.certPath.UTF8String,
                          SSLconfig.certAuthPath.UTF8String, SSLconfig.certAuthPEMPath.UTF8String,
                          SSLconfig.cipher.UTF8String);
        }
        
        if (!mysql_real_connect(_mysql,
                                _configuration.serverName.UTF8String,
                                _configuration.username.UTF8String,
                                _configuration.password.UTF8String,
                                _configuration.dbName.UTF8String,
                                (uint)_configuration.port,
                                _configuration.socket.UTF8String,
                                0)) {
            OHLogError(@"Failed to connect to database: Error: %s", mysql_error(_mysql));
            return NO;
        }
        
        OHLog(@"MySQL cipher: %s", mysql_get_ssl_cipher(_mysql));
        
        [self configureConnectionForEncoding:self.encoding];
        
        return YES;
    }
}

- (void)configureConnectionForEncoding:(CharsetEncoding)encoding {
    @synchronized (self) {
        NSString *charset = MySQLCharsetForEncoding(encoding);
        if (charset != nil && self.mysql != NULL) {
            if (!mysql_set_character_set(self.mysql, charset.UTF8String)) {
                OHLog(@"New character set: %s", mysql_character_set_name(self.mysql));
            }
        }
    }
}

- (OHResultErrorType)selectDataBase:(NSString *)database {
    NSParameterAssert(database);
    @synchronized (self) {
        return self.mysql != NULL ?
        ResultErrorConvertion(mysql_select_db(self.mysql, database.UTF8String)) :
        OHResultErrorTypeGone;
    }
}

- (OHResultErrorType)shutdown {
    @synchronized (self) {
        return self.mysql != NULL ?
        ResultErrorConvertion(mysql_shutdown(self.mysql, SHUTDOWN_DEFAULT)) :
        OHResultErrorTypeGone;
    }
}

- (void)disconnect {
    @synchronized (self) {
        if (self.isConnected) {
            mysql_close(self.mysql);
            mysql_library_end;
        }
    }
}

- (OHResultErrorType)refresh:(OHRefreshOption)options {
    @synchronized (self) {
        return self.mysql != NULL ?
        ResultErrorConvertion(mysql_refresh(self.mysql, (uint)options)) :
        OHResultErrorTypeGone;
    }
}

- (OHResultErrorType)pingMySQL {
    @synchronized (self) {
        return self.mysql != NULL ?
        ResultErrorConvertion(mysql_ping(self.mysql)) :
        OHResultErrorTypeGone;
    }
}

- (BOOL)isConnected {
    return (self.mysql != NULL) && ([self pingMySQL] == OHResultErrorTypeNone);
}

@end
