//
//  main.m
//  bad_queue_app
//
//  Created by staturnz on 6/7/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "exploit/exploit.h"
#import "exploit/patches.h"
//#import "exploit/install.h"

int main(int argc, char * argv[]) {
    if (run_exploit() != 0) {
        print_log("[-] exploit failed\n");
        usleep(100000);
        return -1;
    }

    if (patch_kernel() != 0) {
        print_log("[-] failed to patch kernel\n");
        return -1;
    }

    //install_jailbreak();
    return 0;
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
