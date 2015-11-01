//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

/**
 *  Client error codes and messages.
 */

@import Foundation;

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


/**
 *  Refresh options.
 */
typedef NS_OPTIONS(NSUInteger, OHRefreshOptions){
    /**
     *  Refresh the grant tables, like FLUSH PRIVILEGES.
     */
    OHRefreshOptionGrant = 1,
    /**
     *  Flush the logs, like FLUSH LOGS.
     */
    OHRefreshOptionLog = 2,
    /**
     *  Flush the table cache, like FLUSH TABLES.
     */
    OHRefreshOptionTables = 4,
    /**
     *  Flush the host cache, like FLUSH HOSTS.
     */
    OHRefreshOptionHosts = 8,
    /**
     *  Reset status variables, like FLUSH STATUS.
     */
    OHRefreshOptionStatus = 16,
    /**
     *  Flush the thread cache.
     */
    OHRefreshOptionThreads = 32,
    /**
     *  On a slave replication server, reset the master server information and restart the slave, like RESET SLAVE.
     */
    OHRefreshOptionSlave = 64,
    /**
     *  On a master replication server, remove the binary log files listed in the binary log index and truncate the index file, like RESET MASTER.
     */
    OHRefreshOptionMaster = 128,
};

#define OHArgName(arg) (@""#arg)
#define OHAsser(arg) NSAssert(arg, @"Invalid parameter. %@ cannot be nil. Please check the input parameters.", OHArgName(arg));

#ifdef DEBUG
    #define OHLog(frmt, ...) NSLog(@"%s -[INFO] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
    #define OHLog(frmt, ...) ;
#endif

#ifdef DEBUG
    #define OHLogError(frmt, ...) NSLog(@"%s -[ERROR] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
    #define OHLogError(frmt, ...) ;
#endif

#ifdef DEBUG
    #define OHLogWarn(frmt, ...) NSLog(@"%s -[WARNING] %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__]);
#else
    #define OHLogWarn(frmt, ...) ;
#endif

