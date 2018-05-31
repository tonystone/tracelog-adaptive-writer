///
///  SDJournalWriter.swift
///  TraceLogJournalWriter
///
///  Created by Tony Stone on 5/30/18.
///
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
    /// A dictionary keyed by TraceLog LogLevels with the value to convert to the sd-journals level.
    ///
    private let logLevelConversion: [LogLevel: SDJournalPriority]

    ///
    /// Initializes an SDJournalWriter.
    ///
    /// - Parameters:
    ///     - logLevelConversion: A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    public init(logLevelConversion: [LogLevel: SDJournalPriority] = SDJournalWriter.defaultLogLevelConversion) {
        self.logLevelConversion = logLevelConversion
    }

    ///
    /// Required log function for the `Writer`.
    ///
    public func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        withVaList([]) { vaList -> Void in
            sd_journal_printv_with_location(convertLogLevel(for: level), "CODE_FILE=\(staticContext.file)", "CODE_LINE=\(staticContext.line)", staticContext.function, message, vaList)
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
#endif
