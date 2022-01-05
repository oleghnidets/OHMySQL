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

#import "OHMySQLQueryRequestFactory.h"

#import "OHMySQLQueryRequest.h"
#import "NSString+Utility.h"

@implementation OHMySQLQueryRequestFactory

@end

@implementation OHMySQLQueryRequestFactory (SELECT)

+ (OHMySQLQueryRequest *)SELECT:(NSString *)tableName condition:(NSString *)condition {
    NSString *queryString = [NSString SELECTString:tableName condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}

+ (OHMySQLQueryRequest *)SELECT:(NSString *)tableName
                      condition:(NSString *)condition
                        orderBy:(NSArray<NSString *> *)columnNames
                      ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString SELECTString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}


+ (OHMySQLQueryRequest *)SELECTFirst:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString SELECTFirstString:tableName condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}

+ (OHMySQLQueryRequest *)SELECTFirst:(NSString *)tableName
                           condition:(NSString *)condition
                             orderBy:(NSArray<NSString *> *)columnNames
                           ascending:(BOOL)isAscending {
    NSParameterAssert(tableName && columnNames.count);
    
    NSString *queryString = [NSString SELECTFirstString:tableName condition:condition orderBy:columnNames ascending:isAscending];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}

@end

@implementation OHMySQLQueryRequestFactory (INSERT)

+ (OHMySQLQueryRequest *)INSERT:(NSString *)tableName set:(NSDictionary<NSString *,id> *)set {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString INSERTString:tableName set:set];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}

@end

@implementation OHMySQLQueryRequestFactory (UPDATE)

+ (OHMySQLQueryRequest *)UPDATE:(NSString *)tableName set:(NSDictionary<NSString *,id> *)set condition:(NSString *)condition {
    NSParameterAssert(tableName && set);
    
    NSString *queryString = [NSString UPDATEString:tableName set:set condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}

@end

@implementation OHMySQLQueryRequestFactory (DELETE)

+ (OHMySQLQueryRequest *)DELETE:(NSString *)tableName condition:(NSString *)condition {
    NSParameterAssert(tableName);
    
    NSString *queryString = [NSString DELETEString:tableName condition:condition];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
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
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}

@end


@implementation OHMySQLQueryRequestFactory (Other)

+ (OHMySQLQueryRequest *)countAll:(NSString *)tableName {
    NSString *queryString = [NSString countString:tableName];
    return [[OHMySQLQueryRequest alloc] initWithQuery:queryString];
}

@end
