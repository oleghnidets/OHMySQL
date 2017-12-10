//  Created by Oleg Hnidets on 10/1/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import "OHSSLConfig.h"

@implementation OHSSLConfig

- (instancetype)initWithKey:(NSString *)key
                   certPath:(NSString *)certPath
               certAuthPath:(NSString *)certAuthPath
            certAuthPEMPath:(NSString *)certAuthPEMPath
                     cipher:(NSString *)cipher {
    if (self = [super init]) {
        _key             = key;
        _certPath        = certPath;
        _certAuthPath    = certAuthPath;
        _certAuthPEMPath = certAuthPEMPath;
        _cipher          = cipher;
    }
    
    return self;
}

@end
