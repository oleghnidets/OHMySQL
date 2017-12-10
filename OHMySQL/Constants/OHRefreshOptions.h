//  Created by Oleg Hnidets on 6/16/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

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
