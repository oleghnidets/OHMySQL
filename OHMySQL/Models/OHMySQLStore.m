//  Created by Oleg Hnidets on 6/14/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLStore.h"
#import "../lib/include/mysql.h"

@interface OHMySQLStore ()

@property (nonatomic, assign) MYSQL *mysql;

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
    return [NSString stringWithUTF8String:mysql_get_server_info(_mysql)];
}

- (NSString *)hostInfo {
    return [NSString stringWithUTF8String:mysql_get_host_info(_mysql)];
}

- (NSUInteger)protocolInfo {
    return mysql_get_proto_info(_mysql);
}

- (NSInteger)serverVersion {
    return mysql_get_server_version(_mysql);
}

- (NSString *)status {
    return [NSString stringWithUTF8String:mysql_stat(_mysql)];
}

@end
