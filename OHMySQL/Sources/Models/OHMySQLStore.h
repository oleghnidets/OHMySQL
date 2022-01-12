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

NS_SWIFT_NAME(MySQLStore)
/// An object of this class contains details about a store MySQL.  
@interface OHMySQLStore : NSObject

- (nonnull instancetype)initWithMySQL:(void *_Nonnull const)mysql NS_REFINED_FOR_SWIFT;

@property (nonatomic, nullable, readonly) void *mysql NS_REFINED_FOR_SWIFT;

/// Returns a string that represents the MySQL server version; for example, "5.7.14".
@property (nonatomic, copy, readonly, nullable) NSString *serverInfo;

/// Returns a string describing the type of connection in use, including the server host name.
@property (nonatomic, copy, readonly, nullable) NSString *hostInfo;

/// An unsigned integer representing the protocol version used by the current connection.
@property (nonatomic, assign, readonly) NSUInteger protocolInfo;

/// An integer that represents the MySQL server version. For example, "5.7.14" is returned as 50714.
@property (nonatomic, assign, readonly) NSInteger serverVersion;

/// A character string describing the server status. nil if an error occurred.
@property (nonatomic, copy, readonly, nullable) NSString *status;

@end
