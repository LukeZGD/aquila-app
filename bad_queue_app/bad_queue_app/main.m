//
//  main.m
//  bad_queue_app
//
//  Created by staturnz on 6/7/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "exploit/exploit.h"

int main(int argc, char * argv[]) {
    run_exploit();
    return 0;
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
