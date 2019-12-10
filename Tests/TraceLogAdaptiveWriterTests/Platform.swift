///
///  PlatformTestValidator.swift
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
///  Created by Tony Stone on 6/16/18.
///
import TraceLog
import TraceLogAdaptiveWriter

///
/// PlatformValidator
///
/// This is the primary type used by the test routines.
///
#if os(Linux)

    internal typealias PlatformValidator = LinuxPlatformValidator
    internal typealias PlatformReader    = LinuxPlatformReader

#elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    @available(iOS 10.0, macOS 10.13, watchOS 3.0, tvOS 10.0, *)
    internal typealias PlatformValidator = DarwinPlatformValidator

    @available(iOS 10.0, macOS 10.13, watchOS 3.0, tvOS 10.0, *)
    internal typealias PlatformReader    = DarwinPlatformReader
#endif

///
/// Internal protocol defining the required platform specific validation data and functions.
///
internal protocol _PlatformValidator {

    /// Platform.LogLevel representing default value for logging
    static var `default`: Platform.LogLevel { get }

    /// Platform.LogLevel representing the value returned for each TraceLog.LogLevel
    static var error:     Platform.LogLevel { get }
    static var warning:   Platform.LogLevel { get }
    static var info:      Platform.LogLevel { get }
    static var trace1:    Platform.LogLevel { get }
    static var trace2:    Platform.LogLevel { get }
    static var trace3:    Platform.LogLevel { get }
    static var trace4:    Platform.LogLevel { get }
}
