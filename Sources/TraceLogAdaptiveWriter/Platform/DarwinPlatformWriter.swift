///
///  ConsoleWriter.swift
///
///  Copyright 2018 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 5/25/18.
///
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation
import TraceLog

import os.log

///
/// Apple Unified Logging System log writer for TraceLog.
///
/// Implementation of a TraceLog `Writer` to write to Apple's Unified Logging System.
///
/// - SeeAlso: https://developer.apple.com/documentation/os/logging
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
internal class DarwinPlatformWriter: _PlatformWriter {

    ///
    /// The default LogLevel Conversion Table.
    ///
    static let defaultLogLevelConversion: [TraceLog.LogLevel: Platform.LogLevel] = [
        .error:   Platform.LogLevel(OSLogType.error.rawValue),
        .warning: Platform.LogLevel(OSLogType.default.rawValue),
        .info:    Platform.LogLevel(OSLogType.default.rawValue),
        .trace1:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace2:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace3:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace4:  Platform.LogLevel(OSLogType.debug.rawValue)
    ]

    ///
    /// Custom subsystem passed to os_log
    ///
    internal let subsystem: String

    ///
    /// A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    private let logLevelConversion: [LogLevel: Platform.LogLevel]

    ///
    /// Initializes an UnifiedLoggingWriter.
    ///
    /// - Parameters:
    ///     - sybsystem: An identifier string, usually in reverse DNS notation, representing the subsystem that’s performing logging (defaults to current process name).
    ///     - logLevelConversion: A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    required init(subsystem: String?, logLevelConversion: [LogLevel: Platform.LogLevel]) {
        self.subsystem          = subsystem ?? ProcessInfo.processInfo.processName
        self.logLevelConversion = logLevelConversion
    }

    ///
    /// Required log function for the `Writer`.
    ///
    @inline(__always)
    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        let log = OSLog(subsystem: self.subsystem, category: tag)

        os_log("%{public}@", log: log, type: OSLogType(UInt8(platformLogLevel(for: level))), message)
    }

    ///
    /// Converts TraceLog level to os_log.
    ///
    @inline(__always)
    func platformLogLevel(for level: LogLevel) -> Platform.LogLevel {

        guard let level = self.logLevelConversion[level]
            else { return Platform.LogLevel(OSLogType.default.rawValue) }

        return level
    }
}
#endif
