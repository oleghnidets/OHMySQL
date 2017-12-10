//  Created by Oleg Hnidets on 10/1/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

@import Foundation;

/// This class is used for establishing secure connections using SSL.
/// @note Please, see http://dev.mysql.com/doc/refman/5.7/en/mysql-ssl-set.html for more details.
@interface OHSSLConfig : NSObject

/// The path name to the key file.
@property (nonatomic, copy, nullable) NSString *key;

/// The path name to the certificate file.
@property (nonatomic, copy, nullable) NSString *certPath;

/// The path name to the certificate authority file.
@property (nonatomic, copy, nullable) NSString *certAuthPath;

/// The path name to a directory that contains trusted SSL CA certificates in PEM format.
@property (nonatomic, copy, nullable) NSString *certAuthPEMPath;

/// A list of permissible ciphers to use for SSL encryption.
@property (nonatomic, copy, nullable) NSString *cipher;

- (nullable instancetype)initWithKey:(nullable NSString *)key
                            certPath:(nullable NSString *)certPath
                        certAuthPath:(nullable NSString *)certAuthPath
                     certAuthPEMPath:(nullable NSString *)certAuthPEMPath
                              cipher:(nullable NSString *)cipher;

@end
