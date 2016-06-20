//  Created by Oleg on 10/31/15.
//  Copyright © 2015 Oleg Hnidets. All rights reserved.
//

@import Foundation;

@protocol OHMappingProtocol <NSObject>

//! Dictionary that represents class' properties with table' column names.
- (NSDictionary *)mappingDictionary;

//! Returns name of table.
- (NSString *)mySQLTable;

//! Returns name of index property.
- (NSString *)indexKey;

@end

#define mysql_key(name) NSStringFromSelector(@selector(name))
