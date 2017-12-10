//  Created by Oleg Hnidets on 6/16/16.
//  Copyright © 2016-2017 Oleg Hnidets. All rights reserved.
//

/**
 *  Represents protocol types that can be used during session.
 */
typedef NS_ENUM(NSUInteger, OHProtocolType) {
    /**
     *  Default connection.
     */
    OHProtocolTypeDefault,
    /**
     *  TCP/IP connection to local or remote server.
     */
    OHProtocolTypeTCP,
};
