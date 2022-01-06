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

@import Foundation;

/**
 *  Refresh options.
 */
typedef NS_ENUM(NSUInteger, OHRefreshOption) {
    OHRefreshOptionNone = 0,
    
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
} NS_SWIFT_NAME(RefreshOption);
