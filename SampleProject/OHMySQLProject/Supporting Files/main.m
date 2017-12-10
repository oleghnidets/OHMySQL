//
//  main.m
//  MySQL
//
//  Created by Oleg Hnidets on 8/12/15.
//  Copyright © 2015-2017 Oleg Hnidets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "AppDelegate.h"
#import "OHAppDelegateTest.h"


int main(int argc, char * argv[]) {
    @autoreleasepool {
        Class appDelegateClass = (NSClassFromString(@"XCTestCase") ? [OHAppDelegateTest class] : [AppDelegate class]);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
    }
}
