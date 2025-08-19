# Installation

Learn the ways to integrate the framework in your application.

## Overview

The framework can be installed in different ways.

### SPM

Once you have your Swift package set up, adding `OHMySQL` as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/oleghnidets/OHMySQL.git", .upToNextMajor(from: "3.4.1"))
]
```

### Carthage

Add the following to your `Cartfile`:
```bash
github "oleghnidets/OHMySQL"
```

Run the command for updating Carthage dependencies. 
```
carthage update --use-xcframeworks OHMySQL
```

In addition to manually adding xcframework of OHMySQL from `Carthage/Build` folder you will need to add manually `MySQL.xcframework`. `MySQL.xcframework` is a part of this repo, see `OHMySQL/lib/MySQL.xcframework`.

> Tip: Learn how to use [Carthage](https://github.com/Carthage/Carthage#quick-start).

### Manually

Open up Terminal and clone the repo.
```
git clone https://github.com/oleghnidets/OHMySQL
```

Open cloned repo folder and copy the folder `OHMySQL`. Paste the folder into your project folder.

Open up your project (xcodeproj) and drag the folder `OHMySQL` into the Project Navigator of your application's Xcode project.

Navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar. In the tab bar at the top of that window, open the "General" panel. Make sure there is the framework `MySQL.xcframework` under the "Frameworks & Libraries" section. If not, click on the `+` button and add the framework. Also, you will need to add the library `libc++`. 



