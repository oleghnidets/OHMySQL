//  Created by Oleg Hnidets on 6/16/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

/**
 *  Client error codes and messages.
 */
typedef NS_ENUM(NSUInteger, OHResultErrorType){
    /**
     *  Success.
     */
    OHResultErrorTypeNone = 0,
    /**
     *  Commands were executed in an improper order.
     */
    OHResultErrorTypeSync = 2014,
    /**
     *  The MySQL server has gone away.
     */
    OHResultErrorTypeGone = 2006,
    /**
     *  The connection to the server was lost during the query.
     */
    OHResultErrorTypeLost = 2013,
    /**
     *  An unknown error occurred.
     */
    OHResultErrorTypeUnknown = 2000,
};
