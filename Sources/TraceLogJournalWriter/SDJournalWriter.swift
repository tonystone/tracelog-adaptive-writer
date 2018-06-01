///
///  SDJournalWriter.swift
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

import Swift
import TraceLog
import CSDJournal

///
/// Linux systemd journal writer.
///
public class SDJournalWriter: Writer {

    public typealias SDJournalPriority = Int32

    ///
    /// The default LogLevel Conversion Table.
    ///
    public static let defaultLogLevelConversion: [LogLevel: SDJournalPriority] = [
        .error:   LOG_ERR,
        .warning: LOG_WARNING,
        .info:    LOG_INFO,
        .trace1:  LOG_DEBUG,
        .trace2:  LOG_DEBUG,
        .trace3:  LOG_DEBUG,
        .trace4:  LOG_DEBUG
    ]

    ///
    /// Override value for the systemd journal field SYSLOG_IDENTIFIER.
    ///
    private let syslogIdentifier: String?

    ///
    /// A dictionary keyed by TraceLog LogLevels with the value to convert to the sd-journals level.
    ///
    private let logLevelConversion: [LogLevel: SDJournalPriority]

    ///
    /// Initializes an SDJournalWriter.
    ///
    /// - Parameters:
    ///     - syslogIdentifier: A String override value for the systemd journal field SYSLOG_IDENTIFIER. If not passsed the journal will set it's default value.
    ///     - logLevelConversion: A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    public init(syslogIdentifier: String? = nil, logLevelConversion: [LogLevel: SDJournalPriority] = SDJournalWriter.defaultLogLevelConversion) {
        self.syslogIdentifier   = syslogIdentifier
        self.logLevelConversion = logLevelConversion
    }

    ///
    /// Required log function for the `Writer`.
    ///
    public func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        var elements  = ["MESSAGE=\(message)",
                         "CODE_FILE=\(staticContext.file)",
                         "CODE_LINE=\(staticContext.line)",
                         "CODE_FUNC=\(staticContext.function)",
                         "PRIORITY=\(convertLogLevel(for: level))",
                         "TAG=\(tag)"]

        if let identifier = self.syslogIdentifier {
            elements.append("SYSLOG_IDENTIFIER=\(identifier)")
        }

        withIovecArray(elements) { array, count -> Void in
            sd_journal_sendv(array, count)
        }
    }

    ///
    /// Converts TraceLog level to os_log.
    ///
    internal /* @testable */
    func convertLogLevel(for level: LogLevel) -> SDJournalPriority {

        guard let level = logLevelConversion[level]
                else { return LOG_INFO }

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
