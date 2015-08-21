//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

/**
 *  Error types of executing a query.
 */
typedef NS_ENUM(NSInteger, OHQueryResultErrorType){
    /**
     *  Success.
     */
    OHQueryResultErrorTypeNone = 0,
    /**
     *  Commands were executed in an improper order.
     */
    OHQueryResultErrorTypeSync = 2014,
    /**
     *  The MySQL server has gone away.
     */
    OHQueryResultErrorTypeGone = 2006,
    /**
     *  The connection to the server was lost during the query.
     */
    OHQueryResultErrorTypeLost = 2013,
    /**
     *  An unknown error occurred.
     */
    OHQueryResultErrorTypeUnknown = 2000,
};

#define OHArgName(arg) (@""#arg)
#define OHAsser(arg) NSAssert(arg, @"Invalid parameter. %@ cannot be nil. Please check the input parameters.", OHArgName(arg));
