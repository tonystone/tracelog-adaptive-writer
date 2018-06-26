# TraceLog AdaptiveWriter ![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-lightgray.svg?style=flat)

<a href="https://github.com/tonystone/tracelog-adaptive-writer" target="_blank">
    <img src="https://img.shields.io/badge/platforms-Linux%20%7C%20iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20-lightgray.svg?style=flat" alt="Platforms: Linux | iOS | macOS | watchOS | tvOS" />
</a>
<a href="https://github.com/tonystone/tracelog-adaptive-writer" target="_blank">
   <img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat" alt="Swift 4.1">
</a>
<a href="https://travis-ci.org/tonystone/tracelog-adaptive-writer" target="_blank">
  <img src="https://travis-ci.org/tonystone/tracelog-adaptive-writer.svg?branch=master" alt="travis-ci.org" />
</a>

---

## Overview

A `Writer` implementation for the TraceLog logging system that logs to the system logging facility on the platform that its running on.

- **Linux**: On Linux it will writer to the systemd journal.
- **Darwin**: On Darwin platforms (macOS, iOS, tvOS, watchOS) it will write to the Unified Logging System.

See [TraceLog](https://github.com/tonystone/tracelog) for more details.

## Installation

**TraceLogAdaptiveWriter** supports dependency management via Swift Package Manager on All Apple OS variants as well as Linux.

Please see [Swift Package Manager](https://swift.org/package-manager/#conceptual-overview) for further information.

## Author

Tony Stone ([https://github.com/tonystone](https://github.com/tonystone))

## License

TraceLogAdaptiveWriter is released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)
