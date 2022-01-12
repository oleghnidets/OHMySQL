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

#import "OHMySQLStore.h"
@import MySQL;

@interface OHMySQLStore ()

@property (nonatomic, nullable) void *mysql;

@end

@implementation OHMySQLStore

- (instancetype)initWithMySQL:(void *)mysql {
    NSParameterAssert(mysql);
    if (self = [super init]) {
        _mysql = mysql;
    }
    
    return self;
}

- (NSString *)serverInfo {
    return _mysql != NULL ?
    [NSString stringWithUTF8String:mysql_get_server_info(_mysql)] :
    nil;
}

- (NSString *)hostInfo {
    return _mysql != NULL ?
    [NSString stringWithUTF8String:mysql_get_host_info(_mysql)] :
    nil;
}

- (NSUInteger)protocolInfo {
    return _mysql != NULL ?
    mysql_get_proto_info(_mysql) :
    0;
}

- (NSInteger)serverVersion {
    return _mysql != NULL ?
    mysql_get_server_version(_mysql) :
    -1;
}

- (NSString *)status {
    return _mysql != NULL ?
    [NSString stringWithUTF8String:mysql_stat(_mysql)] :
    nil;
}

@end
