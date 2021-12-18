//  Created by Oleg Hnidets on 2015.
//  Copyright © 2015-2018 Oleg Hnidets. All rights reserved.
//

@import Foundation;
#import "OHMySQLTimeline.h"

/// An instance of OHMySQLQueryRequest describes SQL query used to retrieve data from a MySQL store.
@interface OHMySQLQueryRequest : NSObject

/// The timeline of lifecycle of query.
@property (strong, nonnull) OHMySQLTimeline *timeline;

/// SQL query string.
@property (nonatomic, copy, nonnull) NSString *queryString;


/**
 Initialize request object with SQL string.

 @param query SQL query string.
 @return Instance of the class with set SQL query.
 */
- (nonnull instancetype)initWithQueryString:(nonnull NSString *)query;

@end
