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

#import "OHMySQLUser.h"
#import "OHSSLConfig.h"
#import "OHMySQLStore.h"
#import "OHCharsetEncoding.h"

@import MySQL;

@interface OHMySQLStoreCoordinator ()

@property (nonatomic, strong, readwrite) OHMySQLStore *store;
@property (nonatomic, strong, readwrite) OHMySQLUser *user;
@property (readwrite, nullable) void *mysql;

@end

@implementation OHMySQLStoreCoordinator

- (void)setEncoding:(CharsetEncoding)encoding {
	_encoding = encoding;
	[self configureConnectionForEncoding:encoding];
}

- (instancetype)initWithUser:(OHMySQLUser *)user {
    NSParameterAssert(user);
    if (self = [super init]) {
        _user = user;
		_encoding = CharsetEncodingUTF8;
    }
    
    return self;
}

- (void)dealloc {
	mysql_library_end;
}

- (BOOL)reconnect {
    [self disconnect];
    
    return [self connect];
}

- (BOOL)connect {
    mysql_library_init;
    
    _mysql = mysql_init(NULL);
    
    mysql_options(_mysql, MYSQL_OPT_COMPRESS, 0);
    bool reconnect = 1;
    mysql_options(_mysql, MYSQL_OPT_RECONNECT, &reconnect);
    mysql_options(_mysql, MYSQL_OPT_PROTOCOL, &_protocol);
    
    OHSSLConfig *SSLconfig = self.user.sslConfig;
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
    
    if (!mysql_real_connect(_mysql, _user.serverName.UTF8String, _user.userName.UTF8String, _user.password.UTF8String, _user.dbName.UTF8String, (unsigned int)_user.port, _user.socket.UTF8String, 0)) {
        OHLogError(@"Failed to connect to database: Error: %s", mysql_error(_mysql));
		return NO;
    }

	OHLog(@"MySQL cipher: %s", mysql_get_ssl_cipher(_mysql));
	
	self.store = [[OHMySQLStore alloc] initWithMySQL:_mysql];
	[self configureConnectionForEncoding:self.encoding];
    
    return YES;
}

- (void)configureConnectionForEncoding:(CharsetEncoding)encoding {
	NSString *charset = MySQLCharsetForEncoding(encoding);
	if (charset != nil && _mysql != nil) {
		if (!mysql_set_character_set(_mysql, charset.UTF8String)) {
			OHLog(@"New character set: %s", mysql_character_set_name(_mysql));
		}
	}
}

- (OHResultErrorType)selectDataBase:(NSString *)database {
    NSParameterAssert(database);
    @synchronized (self) {
        return _mysql != NULL ? mysql_select_db(_mysql, database.UTF8String) : OHResultErrorTypeGone;
    }
}

- (OHResultErrorType)shutdown {
    @synchronized (self) {
        return _mysql != NULL ? mysql_shutdown(_mysql, SHUTDOWN_DEFAULT) : OHResultErrorTypeGone;
    }
}

- (void)disconnect {
    @synchronized (self) {
        if (self.isConnected) {
            mysql_close(_mysql);
            mysql_library_end;
        }
    }
}

- (OHResultErrorType)refresh:(OHRefreshOptions)options {
    @synchronized (self) {
        return _mysql != NULL ? mysql_refresh(_mysql, (uint)options) : OHResultErrorTypeGone;
    }
}

- (OHResultErrorType)pingMySQL {
    @synchronized (self) {
        return _mysql != NULL ? mysql_ping(_mysql) : OHResultErrorTypeGone;
    }
}

- (BOOL)isConnected {
    return (_mysql != NULL) && ![self pingMySQL];
}

@end
