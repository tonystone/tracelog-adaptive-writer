///
///  AdaptiveWriter.swift
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
///  Created by Tony Stone on 5/30/18.
///
#if os(Linux)

import Foundation
import TraceLog
import systemd

///
/// Linux systemd journal writer.
///
internal class LinuxPlatformWriter: _PlatformWriter {

    ///
    /// The default LogLevel Conversion Table.
    ///
    static let defaultLogLevelConversion: [LogLevel: Platform.LogLevel] = [
        .error:   Platform.LogLevel(LOG_ERR),
        .warning: Platform.LogLevel(LOG_WARNING),
        .info:    Platform.LogLevel(LOG_INFO),
        .trace1:  Platform.LogLevel(LOG_DEBUG),
        .trace2:  Platform.LogLevel(LOG_DEBUG),
        .trace3:  Platform.LogLevel(LOG_DEBUG),
        .trace4:  Platform.LogLevel(LOG_DEBUG)
    ]

    ///
    /// Override value for the systemd journal field SYSLOG_IDENTIFIER.
    ///
    internal /* @testable */
    let subsystem: String

    ///
    /// A dictionary keyed by TraceLog LogLevels with the value to convert to the sd-journals level.
    ///
    private let logLevelConversion: [LogLevel: Platform.LogLevel]

    ///
    /// Initializes an AdaptiveWriter.
    ///
    /// - Parameters:
    ///     - syslogIdentifier: A String override value for the systemd journal field SYSLOG_IDENTIFIER. If not passsed the journal will set it's default value.
    ///     - logLevelConversion: A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    required init(subsystem: String? = nil, logLevelConversion: [LogLevel: Platform.LogLevel]) {
        self.subsystem          = subsystem ?? ProcessInfo.processInfo.processName
        self.logLevelConversion = logLevelConversion
    }

    ///
    /// Required log function for the `Writer`.
    ///
    @inline(__always)
    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        let elements  = ["MESSAGE=\(message)",
                         "CODE_FILE=\(staticContext.file)",
                         "CODE_LINE=\(staticContext.line)",
                         "CODE_FUNC=\(staticContext.function)",
                         "PRIORITY=\(Int32(platformLogLevel(for: level)))",
                         "TAG=\(tag)",
                         "SYSLOG_IDENTIFIER=\(self.subsystem)"]

        withIovecArray(elements) { array, count -> Void in
            sd_journal_sendv(array, count)
        }
    }

    ///
    ///  Converts a TraceLog.LogLevel to the platforms level based on the configured logLevelConversion matrix.
    ///
    @inline(__always)
    func platformLogLevel(for level: LogLevel) -> Platform.LogLevel {

        guard let level = self.logLevelConversion[level]
                else { return Platform.LogLevel(LOG_INFO) }

        return level
    }
}

///
/// Helper function to convert an Array of strings into an array of iovec structs suitable for passing
/// to C level functions.
///
private func withIovecArray<R>(_ elements: [String], _ body: (UnsafePointer<iovec>, Int32) -> R) -> R {

    var cStrings = elements.map { $0.utf8CString }

    var iovecArray: [iovec] = []

    for i in 0..<cStrings.count {
        let len = cStrings[i].count - 1
        cStrings[i].withUnsafeMutableBytes { (bytes) -> Void in
            if let address = bytes.baseAddress {
                iovecArray.append(iovec(iov_base: address, iov_len: len))
            }
        }
    }
    return body(&iovecArray, Int32(iovecArray.count))
}

#endif
