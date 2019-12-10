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
///  Created by Tony Stone on 6/14/18.
///
import Swift
import TraceLog

///
/// System log writer that writes to the platforms system logging service.
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
public class AdaptiveWriter: Writer {

    ///
    /// The default LogLevel conversion matrix for this instance.
    ///
    public static var defaultLogLevelConversion:  [TraceLog.LogLevel: Platform.LogLevel] {
        return PlatformWriter.defaultLogLevelConversion
    }

    ///
    /// Initializes a AdaptiveWriter.
    ///
    /// - Parameters:
    ///     - subsystem: A String override value for the system susbsystem field during logging. If not passsed the journal will set it's default value.
    ///     - logLevelConversion: A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    public init(subsystem: String? = nil, logLevelConversion: [TraceLog.LogLevel: Platform.LogLevel] = defaultLogLevelConversion) {
        self.implementation = PlatformWriter(subsystem: subsystem, logLevelConversion: logLevelConversion)
    }

    ///
    /// Required log function for the `Writer`.
    ///
    public func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {
        return self.implementation.write(entry)
    }

    ///
    /// Internal implementation based on current platform (Darwin, Linux, etc).
    ///
    private let implementation: PlatformWriter
}

@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
extension AdaptiveWriter {

    internal /* @testable */
    var subsystem: String {
        return self.implementation.subsystem
    }

    internal /* @testable */
    func platformLogLevel(for level: LogLevel) -> Platform.LogLevel {
        return self.implementation.platformLogLevel(for: level)
    }
}
