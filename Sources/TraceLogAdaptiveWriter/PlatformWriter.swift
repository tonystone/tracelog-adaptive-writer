///
///  PlatformWriter.swift
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
///  Created by Tony Stone on 6/15/18.
///
import TraceLog

///
/// PlatformWriter
///
/// This is the primary type used as the implementation of the Writer.
///
#if os(Linux)

    internal typealias PlatformWriter = LinuxPlatformWriter

#elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    @available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
    internal typealias PlatformWriter = DarwinPlatformWriter
#endif

///
/// Internal protocol defining a platform specific plugin writer to AdaptiveWriter.
///
internal protocol _PlatformWriter: Writer {

    ///
    /// The implementations default conversion matrix.
    ///
    static var defaultLogLevelConversion: [TraceLog.LogLevel: Platform.LogLevel] { get }

    ///
    /// The subsystem defined for this logger.
    ///
    var subsystem: String { get }

    ///
    /// Required constructor for all _PlatformWriter implementations.
    ///
    init(subsystem: String?, logLevelConversion: [TraceLog.LogLevel: Platform.LogLevel])

    ///
    ///  Converts a TraceLog.LogLevel to the platforms level based on the configured logLevelConversion matrix.
    ///
    func platformLogLevel(for level: LogLevel) -> Platform.LogLevel
}

