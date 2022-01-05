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

NS_SWIFT_NAME(MySQLSSLConfig)
/// This class is used for establishing secure connections using SSL.
/// @note Please, see http://dev.mysql.com/doc/refman/5.7/en/mysql-ssl-set.html for more details.
@interface OHSSLConfig : NSObject

/// The path name to the key file.
@property (nonatomic, copy, nullable, readonly) NSString *key;

/// The path name to the certificate file.
@property (nonatomic, copy, nullable, readonly) NSString *certPath;

/// The path name to the certificate authority file.
@property (nonatomic, copy, nullable, readonly) NSString *certAuthPath;

/// The path name to a directory that contains trusted SSL CA certificates in PEM format.
@property (nonatomic, copy, nullable, readonly) NSString *certAuthPEMPath;

/// A list of permissible ciphers to use for SSL encryption.
@property (nonatomic, copy, nullable, readonly) NSString *cipher;

/// Initializes and returns a newly allocated SSL config object with the specified parameters.
- (nonnull instancetype)initWithKey:(nullable NSString *)key
                           certPath:(nullable NSString *)certPath
                       certAuthPath:(nullable NSString *)certAuthPath
                    certAuthPEMPath:(nullable NSString *)certAuthPEMPath
                             cipher:(nullable NSString *)cipher;

@end
