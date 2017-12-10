//  Created by Oleg Hnidets on 6/14/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLQueryRequestFactory.h"

#import "OHMySQLQueryRequest.h"
#import "NSString+Utility.h"

@implementation OHMySQLQueryRequestFactory

@end

@implementation OHMySQLQueryRequestFactory (SELECT)

+ (OHMySQLQueryRequest *)SELECT:(NSString *)tableName condition:(NSString *)condition {
    NSString *queryString = [NSString SELECTString:tableName condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

+ (OHMySQLQueryRequest *)SELECT:(NSString *)tableName
                      condition:(NSString *)condition
                        orderBy:(NSArray<NSString *> *)columnNames
                      ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString SELECTString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}


+ (OHMySQLQueryRequest *)SELECTFirst:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString SELECTFirstString:tableName condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

+ (OHMySQLQueryRequest *)SELECTFirst:(NSString *)tableName
                           condition:(NSString *)condition
                             orderBy:(NSArray<NSString *> *)columnNames
                           ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString SELECTFirstString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryRequestFactory (INSERT)

+ (OHMySQLQueryRequest *)INSERT:(NSString *)tableName set:(NSDictionary<NSString *,id> *)set {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString INSERTString:tableName set:set];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryRequestFactory (UPDATE)

+ (OHMySQLQueryRequest *)UPDATE:(NSString *)tableName set:(NSDictionary<NSString *,id> *)set condition:(NSString *)condition {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString UPDATEString:tableName set:set condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryRequestFactory (DELETE)

+ (OHMySQLQueryRequest *)DELETE:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString DELETEString:tableName condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryRequestFactory (JOIN)

+ (OHMySQLQueryRequest *)JOINType:(NSString *)joinType
                        fromTable:(NSString *)tableName
                      columnNames:(NSArray<NSString *> *)columnNames
                           joinOn:(NSDictionary<NSString *,NSString *> *)joinOn {
    NSParameterAssert(tableName && joinOn.count && columnNames.count);
    
    NSString *queryString = [NSString JOINString:joinType
                                       fromTable:tableName
                                     columnNames:columnNames
                                       joinInner:joinOn];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

@end


@implementation OHMySQLQueryRequestFactory (Other)

+ (OHMySQLQueryRequest *)countAll:(NSString *)tableName {
    NSString *queryString = [NSString countString:tableName];
    return [[OHMySQLQueryRequest alloc] initWithQueryString:queryString];
}

@end
