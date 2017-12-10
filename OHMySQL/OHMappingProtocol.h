//  Created by Oleg Hnidets on 10/31/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@protocol OHMappingProtocol <NSObject>

/// Dictionary that represents class' properties with table' column names.
- (NSDictionary *)mappingDictionary;

/// Table where current entity can be found.
- (NSString *)mySQLTable;

/// Returns name of primary property (row).
- (NSString *)primaryKey;

@end

#define mysql_key(name) NSStringFromSelector(@selector(name))
