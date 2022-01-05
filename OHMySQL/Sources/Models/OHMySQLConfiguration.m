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

#import "OHMySQLConfiguration.h"

@interface OHMySQLConfiguration ()
@end

@implementation OHMySQLConfiguration

- (instancetype)initWithUser:(NSString *)user
                    password:(NSString *)password
                  serverName:(NSString *)serverName
                      dbName:(NSString *)dbName
                        port:(NSUInteger)port
                      socket:(NSString *)socket {
    if (self = [super init]) {
        _username   = user;
        _password   = password;
        _serverName = serverName;
        _dbName     = dbName;
        _port       = port;
        _socket     = socket;
    }
    
    return self;
}

- (instancetype)initWithUser:(NSString *)user
                    password:(NSString *)password
                   sslConfig:(OHSSLConfig *)sslConfig
                  serverName:(NSString *)serverName
                      dbName:(NSString *)dbName
                        port:(NSUInteger)port
                      socket:(NSString *)socket {
    self = [self initWithUser:user password:password serverName:serverName dbName:dbName port:port socket:socket];
    if (self) {
        _sslConfig = sslConfig;
    }
    
    return self;
}

@end
