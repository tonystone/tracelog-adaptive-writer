///
///  AdaptiveWriterTests.swift
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

import XCTest

import TraceLog
import TraceLogTestHarness

@testable import TraceLogAdaptiveWriter

@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
let testEqual: (AdaptiveWriter, LogEntry?, LogEntry) -> Void = { writer, result, expected in

    guard let result = result
        else { XCTFail("Failed to locate log entry."); return }

    XCTAssertEqual(result.timestamp,         expected.timestamp)
    XCTAssertEqual(result.level,             expected.level)
    XCTAssertEqual(result.message,           expected.message)
    XCTAssertEqual(result.tag,               expected.tag)

    /// Note: These platforms due to Apple Unified Logging os_log, don't support these attributes.
    #if !os(macOS) && !os(iOS) && !os(tvOS) && !os(watchOS)

        XCTAssertEqual(result.file,              expected.file)
        XCTAssertEqual(result.function,          expected.function)
        XCTAssertEqual(result.line,              expected.line)
    #endif

    XCTAssertEqual(result.customAttributes?["subsystem"] as? String, writer.subsystem)
}

///
/// Direct Logging to the Logger
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
class AdaptiveWriterTests: XCTestCase {

    let testHarness = TestHarness(writer: AdaptiveWriter(), reader: PlatformReader())

    // MARK: - Log Level Conversation with default table

    func testConvertLogLevelForError() {
        XCTAssertEqual(testHarness.writer.platformLogLevel(for: .error), PlatformValidator.error)
    }

    func testConvertLogLevelForWarning() {
        XCTAssertEqual(testHarness.writer.platformLogLevel(for: .warning), PlatformValidator.warning)
    }

    func testConvertLogLevelForInfo() {
        XCTAssertEqual(testHarness.writer.platformLogLevel(for: .info), PlatformValidator.info)
    }

    func testConvertLogLevelForTrace1() {
        XCTAssertEqual(testHarness.writer.platformLogLevel(for: .trace1), PlatformValidator.trace1)
    }

    func testConvertLogLevelForTrace2() {
        XCTAssertEqual(testHarness.writer.platformLogLevel(for: .trace2), PlatformValidator.trace2)
    }

    func testConvertLogLevelForTrace3() {
        XCTAssertEqual(testHarness.writer.platformLogLevel(for: .trace3), PlatformValidator.trace3)
    }

    func testConvertLogLevelForTrace4() {
        XCTAssertEqual(testHarness.writer.platformLogLevel(for: .trace4), PlatformValidator.trace4)
    }

    // MARK: - Log Level Conversation with empty table

    func testConvertLogLvelErrorWithEmptyConversionTable() {
        XCTAssertEqual(AdaptiveWriter(logLevelConversion: [:]).platformLogLevel(for: .error), PlatformValidator.default)
    }

    func testConvertLogLvelWarningWithEmptyConversionTable() {
        XCTAssertEqual(AdaptiveWriter(logLevelConversion: [:]).platformLogLevel(for: .warning), PlatformValidator.default)
    }

    func testConvertLogLvelInfoWithEmptyConversionTable() {
        XCTAssertEqual(AdaptiveWriter(logLevelConversion: [:]).platformLogLevel(for: .info), PlatformValidator.default)
    }

    func testConvertLogLvelTrace1WithEmptyConversionTable() {
        XCTAssertEqual(AdaptiveWriter(logLevelConversion: [:]).platformLogLevel(for: .trace1), PlatformValidator.default)
    }

    func testConvertLogLvelTrace2WithEmptyConversionTable() {
        XCTAssertEqual(AdaptiveWriter(logLevelConversion: [:]).platformLogLevel(for: .trace2), PlatformValidator.default)
    }

    func testConvertLogLvelTrace3WithEmptyConversionTable() {
        XCTAssertEqual(AdaptiveWriter(logLevelConversion: [:]).platformLogLevel(for: .trace3), PlatformValidator.default)
    }

    func testConvertLogLvelTrace4WithEmptyConversionTable() {
        XCTAssertEqual(AdaptiveWriter(logLevelConversion: [:]).platformLogLevel(for: .trace4), PlatformValidator.default)
    }

    // MARK: - Init method tests

    func testSyslogIdentifier() {
        let subsystemIdentifier = "TestSubsystemIdentifier"

        /// Create a custom instance of the TestHarness so the subsystem can be passed.
        TestHarness(writer: AdaptiveWriter(subsystem: subsystemIdentifier), reader: PlatformReader()).testLog(for: .error, validationBlock: testEqual);
    }

    // MARK: - Direct calls to the writer with default conversion table.

    func testLogError() {
        testHarness.testLog(for: .error, validationBlock: testEqual)
    }

    func testLogWarning() {
        testHarness.testLog(for: .warning, validationBlock: testEqual)
    }

    func testLogInfo() {
        testHarness.testLog(for: .info, validationBlock: testEqual)
    }

    func testLogTrace1() {
        testHarness.testLog(for: .trace1, validationBlock: testEqual)
    }

    func testLogTrace2() {
        testHarness.testLog(for: .trace2, validationBlock: testEqual)
    }

    func testLogTrace3() {
        testHarness.testLog(for: .trace3, validationBlock: testEqual)
    }

    func testLogTrace4() {
        testHarness.testLog(for: .trace4, validationBlock: testEqual)
    }
}

///
/// Logging through TraceLog to the Logger
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
class TraceLogWithAdaptiveWriterTests: XCTestCase {

    let testHarness = TestHarness(writer: AdaptiveWriter(), reader: PlatformReader())

    override func setUp() {
        TraceLog.configure(writers: [testHarness.writer], environment: ["LOG_ALL": "TRACE4"])
    }

    func testLogError() {

        testHarness.testLog(for: .error, testBlock: { (tag, message, file, function, line) in

            logError(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogWarning() {

        testHarness.testLog(for: .warning, testBlock: { (tag, message, file, function, line) in

            logWarning(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogInfo() {

        testHarness.testLog(for: .info, testBlock: { (tag, message, file, function, line) in

            logInfo(tag, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace1() {

        testHarness.testLog(for: .trace1, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 1, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace2() {

        testHarness.testLog(for: .trace2, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 2, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace3() {

        testHarness.testLog(for: .trace3, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 3, file, function, line) { message }

        }, validationBlock: testEqual)
    }

    func testLogTrace4() {

        testHarness.testLog(for: .trace4, testBlock: { (tag, message, file, function, line) in

            logTrace(tag, level: 4, file, function, line) { message }

        }, validationBlock: testEqual)
    }
}
