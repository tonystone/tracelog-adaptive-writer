# TraceLog AdaptiveWriter ![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-lightgray.svg?style=flat)

<a href="https://github.com/tonystone/tracelog-adaptive-writer" target="_blank">
    <img src="https://img.shields.io/badge/platforms-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20-lightgray.svg?style=flat" alt="Platforms: Linux | iOS | macOS | watchOS | tvOS" />
</a>
<a href="https://github.com/tonystone/tracelog-adaptive-writer" target="_blank">
   <img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift 5.0">
</a>
<a href="http://cocoadocs.org/docsets/TraceLogAdaptiveWriter" target="_blank">
   <img src="https://img.shields.io/cocoapods/v/TraceLogAdaptiveWriter.svg?style=flat" alt="Version"/>
</a>
<a href="https://travis-ci.org/tonystone/tracelog-adaptive-writer" target="_blank">
  <img src="https://travis-ci.org/tonystone/tracelog-adaptive-writer.svg?branch=master" alt="travis-ci.org" />
</a>
<a href="https://codecov.io/gh/tonystone/tracelog-adaptive-writer">
  <img src="https://codecov.io/gh/tonystone/tracelog-adaptive-writer/branch/master/graph/badge.svg" />
</a>

---

## Overview

A `Writer` implementation for the [**TraceLog**](https://github.com/tonystone/tracelog) logging system that logs to the system logging facility on the platform that it is running on.

- **Apple Unified Logging (Darwin)** - On Apple platforms the AdaptiveWriter writes to the Unified Logging System.
- **Linux systemd Journal (Linux)** - On Linux platforms the AdaptiveWriter writes to the systemd journal.


See TraceLog ([https://github.com/tonystone/tracelog](https://github.com/tonystone/tracelog)) for more details.

## Usage

TraceLog can be configured with multiple custom log writers who do the job of outputting the log statements to the desired location.  By default, it configures itself with a `ConsoleWriter`
which outputs to `stdout`.  To install the `AdaptiveWriter` replacing the `ConsoleWriter`, simply create an instance and pass it along to the configure method of TraceLog.


```swift
    TraceLog.configure(writers: [AdaptiveWriter()])
```

AdaptiveWriter uses the default value (the process name) for the subsystem (`subsystem` in Unified Logging and `SYSLOG_IDENTIFIER` in systemd journal) to log messages on each platform.  That value can be overridden at `init` time by passing the subsystem parameter.  For example:

```swift
    TraceLog.configure(writers: [AdaptiveWriter(subsystem: "CustomSubsystemName")])
```

Since TraceLog's and the underlying logging systems' LogLevels may differ, the AdaptiveWriter uses a conversion table to convert from a TraceLog defined level such as `TraceLog.LogLevel.info` to a platform level such as `OSLogType.default` in Darwin's Unified Logging System.

AdaptiveWriter contains a default conversion table for each platform.

#### Apple Unified Logging System - Conversion Table

| TraceLog.LogLevel | | OSLogType |
|:-----------------:|:-:|:--------:|
|    `.error`       | -> |   `.error`  |
|    `.warning`     | -> |   `.default`|
|    `.info`        | -> |   `.default`|
|    `.trace1`      | -> |   `.debug`  |
|    `.trace2`      | -> |   `.debug`  |
|    `.trace3`      | -> |   `.debug`  |
|    `.trace4`      | -> |   `.debug`  |

#### Linux Systemd Journal - Conversion Table

| TraceLog.LogLevel | | PRIORITY |
|:-----------------:|:-:|:--------:|
|    `.error`       | -> |   `LOG_ERR`  |
|    `.warning`     | -> |   `LOG_WARNING`|
|    `.info`        | -> |   `LOG_INFO`|
|    `.trace1`      | -> |   `LOG_DEBUG`  |
|    `.trace2`      | -> |   `LOG_DEBUG`  |
|    `.trace3`      | -> |   `LOG_DEBUG`  |
|    `.trace4`      | -> |   `LOG_DEBUG`  |

If the default table does not work for your particular use-case, AdaptiveWriter allows you to override the default conversion table at creation time.  Here are some examples:

Setting an empty table will convert all TraceLog levels to the default level of the platform in use.  On Darwin that is `OSLogType.default` and on Linux the value is `LOG_INFO`.

```swift
    ///
    /// Linux/Darwin
    ///
    let adaptiveWriter = AdaptiveWriter(logLevelConversion: [:])
```

Setting one or more levels will set the levels specified and all non-specified levels will be converted to the platform default. To set a value you must wrap the system defined value in AdaptiveWriter's `Platform.LogLevel` type.  This will translate to the proper type on each platform.

```swift
    ///
    /// Darwin Example
    ///
    let adaptiveWriter = AdaptiveWriter(logLevelConversion: [.error: Platform.LogLevel(OSLogType.error.rawValue)])
```

You may also specify a full conversion table to change all values.

```swift
    ///
    /// Darwin Example
    ///
    let darwinLogConversionTable: [TraceLog.LogLevel: Platform.LogLevel] = [
        .error:   Platform.LogLevel(OSLogType.default.rawValue),
        .warning: Platform.LogLevel(OSLogType.default.rawValue),
        .info:    Platform.LogLevel(OSLogType.default.rawValue),
        .trace1:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace2:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace3:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace4:  Platform.LogLevel(OSLogType.debug.rawValue)
    ]

    let adaptiveWriter = AdaptiveWriter(logLevelConversion: darwinLogConversionTable)
```

```swift
    ///
    /// Linux Example
    ///
    let linuxLogConversionTable: [TraceLog.LogLevel: Platform.LogLevel] = [
        .error:   Platform.LogLevel(LOG_INFO),
        .warning: Platform.LogLevel(LOG_INFO),
        .info:    Platform.LogLevel(LOG_INFO),
        .trace1:  Platform.LogLevel(LOG_DEBUG),
        .trace2:  Platform.LogLevel(LOG_DEBUG),
        .trace3:  Platform.LogLevel(LOG_DEBUG),
        .trace4:  Platform.LogLevel(LOG_DEBUG)
    ]

    let adaptiveWriter = AdaptiveWriter(logLevelConversion: linuxLogConversionTable)
```

## Minimum Requirements

Build Environment

| Platform | Swift | Swift Build | Xcode |
|:--------:|:-----:|:----------:|:------:|
| Linux    | 5.0 | &#x2714; | &#x2718; |
| OSX      | 5.0| &#x2714; | Xcode 10.x |

> Note: Compiling on Linux requires **libsystemd-dev** be installed on the build system.  Use `apt-get install libsystemd-dev` to install it.

Minimum Runtime Version

| iOS |  OS X | tvOS | watchOS | Linux |
|:---:|:-----:|:----:|:-------:|:------------:|
| 10.0 | 10.12 | 10.0  |   3.0   | Ubuntu 14.04, 16.04, 16.10 |

## Installation (Swift Package Manager)

**TraceLogAdaptiveWriter** supports dependency management via Swift Package Manager on All Apple OS variants as well as Linux.

Please see [Swift Package Manager](https://swift.org/package-manager/#conceptual-overview) for further information.

## Installation (CocoaPods)

TraceLog is available through [CocoaPods](http://cocoapods.org). Simply add the following lines to your Podfile:

```ruby
pod "TraceLog", "~> 5.0.0"
pod "TraceLogAdaptiveWriter"
```

## Credits

* **Tony Stone** ([https://github.com/tonystone](https://github.com/tonystone)) - Author
* **Félix Fischer** ([https://github.com/felix91gr](https://github.com/felix91gr)) - Ideas, Planning, Code & Testing
* **Ryan Lovelett** ([https://github.com/RLovelett](https://github.com/RLovelett)) - Ideas & Planning


## License

TraceLogAdaptiveWriter is released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)
