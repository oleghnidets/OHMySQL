//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@protocol OHMappingProtocol <NSObject>

- (NSDictionary *)mappingDictionary;

- (NSString *)mySQLTable;

- (NSString *)indexKey;

@end

#define mysql_key(name) NSStringFromSelector(@selector(name))
