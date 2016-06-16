//  Created by Oleg on 6/14/16.
//  Copyright © 2016 Oleg Hnidets. All rights reserved.
//

#import "OHMySQLQueryFactory.h"

#import "OHMySQLQuery.h"
#import "NSString+Utility.h"

@implementation OHMySQLQueryFactory

@end

@implementation OHMySQLQueryFactory (SELECT)

+ (OHMySQLQuery *)SELECT:(NSString *)tableName condition:(NSString *)condition {
    NSString *queryString = [NSString SELECTString:tableName condition:condition];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

+ (OHMySQLQuery *)SELECT:(NSString *)tableName
               condition:(NSString *)condition
                 orderBy:(NSArray<NSString *> *)columnNames
               ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString SELECTString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}


+ (OHMySQLQuery *)SELECTFirst:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString SELECTFirstString:tableName condition:condition];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

+ (OHMySQLQuery *)SELECTFirst:(NSString *)tableName
                    condition:(NSString *)condition
                      orderBy:(NSArray<NSString *> *)columnNames
                    ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString SELECTFirstString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryFactory (INSERT)

+ (OHMySQLQuery *)INSERT:(NSString *)tableName set:(NSDictionary<NSString *,id> *)set {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString INSERTString:tableName set:set];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryFactory (UPDATE)

+ (OHMySQLQuery *)UPDATE:(NSString *)tableName set:(NSDictionary<NSString *,id> *)set condition:(NSString *)condition {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString UPDATEString:tableName set:set condition:condition];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryFactory (DELETE)

+ (OHMySQLQuery *)DELETE:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString DELETEString:tableName condition:condition];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

@end

@implementation OHMySQLQueryFactory (JOIN)

+ (OHMySQLQuery *)JOINType:(NSString *)joinType
                 fromTable:(NSString *)tableName
               columnNames:(NSArray<NSString *> *)columnNames
                    joinOn:(NSDictionary<NSString *,NSString *> *)joinOn {
    NSParameterAssert(tableName && joinOn.count && columnNames.count);
    
    NSString *queryString = [NSString JOINString:joinType
                                 fromTable:tableName
                               columnNames:columnNames
                                 joinInner:joinOn];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

@end


@implementation OHMySQLQueryFactory (Other)

+ (OHMySQLQuery *)countAll:(NSString *)tableName {
    NSString *queryString = [NSString countString:tableName];
    return [[OHMySQLQuery alloc] initWithQueryString:queryString];
}

@end
