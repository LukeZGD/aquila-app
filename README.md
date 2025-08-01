# aquila-app

An iOS app version of Aquila, an untethered jailbreak for iOS 6

This app provides an alternative installation method for Aquila, particularly useful for users on platforms where Aquila is not available, like Linux. With this, users can now sideload the app and jailbreak directly from their device.

## Usage

Download and sideload the IPA from the [latest release](https://github.com/LukeZGD/aquila-app/releases/latest) using [Sideloadly](https://sideloadly.io/).

On Linux, use [Legacy iOS Kit](https://github.com/LukeZGD/Legacy-iOS-Kit) to sideload the IPA.

## Jailbreaking

- The jailbreak process starts immediately when the app is launched.
- If successful, the device will reboot and display a splash screen saying "Installing jailbreak".
- Once complete, Cydia should appear on the home screen.

## Notes

- If the app crashes, the exploit may have failed. Simply try launching it again.
- The app is only for unjailbroken devices. On already jailbroken devices, the app will crash immediately.
- To improve success rate:
    - Open the Compass app and confirm it rotates properly, then retry.
    - On iPads/iPod touches, try physically rotating the screen (like portrait to landscape) before retrying.
    - You may also try rebooting the device before retrying.
- **Important:** Your device must have a working gyroscope/accelerometer to jailbreak with Aquila. This requirement applies to the original Aquila project as well. If your device has faulty sensors, the jailbreak will not work.

## Supported Devices

All devices that support iOS 6

## Building

This project is built using Xcode 13.4.1 and macOS Monterey 12.7.6.

## Credits

- staturnz for [Aquila](https://github.com/staturnzz/aquila) and [bad_queue](https://github.com/staturnzz/bad_queue)
- Everyone credited in Aquila
