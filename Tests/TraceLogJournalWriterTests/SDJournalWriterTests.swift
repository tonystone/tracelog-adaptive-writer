///
///  SDJournalWriterTests.swift
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

import XCTest
import TraceLog
@testable import TraceLogJournalWriter

///
/// Direct Logging to the Logger
///
class SDJournalWriterTests: XCTestCase {

    let writer = SDJournalWriter()

    // MARK: - Log Level Conversation with default table

    func testConvertLogLevelForError() {
        XCTAssertEqual(writer.convertLogLevel(for: .error), LOG_ERR)
    }

    func testConvertLogLevelForWarning() {
        XCTAssertEqual(writer.convertLogLevel(for: .warning), LOG_WARNING)
    }

    func testConvertLogLevelForInfo() {
        XCTAssertEqual(writer.convertLogLevel(for: .info), LOG_INFO)
    }

    func testConvertLogLevelForTrace1() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace1), LOG_DEBUG)
    }

    func testConvertLogLevelForTrace2() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace2), LOG_DEBUG)
    }

    func testConvertLogLevelForTrace3() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace3), LOG_DEBUG)
    }

    func testConvertLogLevelForTrace4() {
        XCTAssertEqual(writer.convertLogLevel(for: .trace4), LOG_DEBUG)
    }

    // MARK: - Log Level Conversation with empty table

    func testConvertLogLvelErrorWithEmptyConversionTable() {
        XCTAssertEqual(SDJournalWriter(logLevelConversion: [:]).convertLogLevel(for: .error), LOG_INFO)
    }

    func testConvertLogLvelWarningWithEmptyConversionTable() {
        XCTAssertEqual(SDJournalWriter(logLevelConversion: [:]).convertLogLevel(for: .warning), LOG_INFO)
    }

    func testConvertLogLvelInfoWithEmptyConversionTable() {
        XCTAssertEqual(SDJournalWriter(logLevelConversion: [:]).convertLogLevel(for: .info), LOG_INFO)
    }

    func testConvertLogLvelTrace1WithEmptyConversionTable() {
        XCTAssertEqual(SDJournalWriter(logLevelConversion: [:]).convertLogLevel(for: .trace1), LOG_INFO)
    }

    func testConvertLogLvelTrace2WithEmptyConversionTable() {
        XCTAssertEqual(SDJournalWriter(logLevelConversion: [:]).convertLogLevel(for: .trace2), LOG_INFO)
    }

    func testConvertLogLvelTrace3WithEmptyConversionTable() {
        XCTAssertEqual(SDJournalWriter(logLevelConversion: [:]).convertLogLevel(for: .trace3), LOG_INFO)
    }

    func testConvertLogLvelTrace4WithEmptyConversionTable() {
        XCTAssertEqual(SDJournalWriter(logLevelConversion: [:]).convertLogLevel(for: .trace4), LOG_INFO)
    }

    // MARK: - Init method tests

    func testSyslogIdentifier() {
        let syslogIdentifier = "TestSyslogIdentifier"

        _testLog(for: .error, TestStaticContext(), SDJournalWriter(syslogIdentifier: syslogIdentifier), syslogIdentifier) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    // MARK: - Direct calls to the writer with default conversion table.

    func testLogError() {
        _testLog(for: .error, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogWarning() {
        _testLog(for: .warning, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogInfo() {
        _testLog(for: .info, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace1() {
        _testLog(for: .trace1, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace2() {
        _testLog(for: .trace2, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace3() {
        _testLog(for: .trace3, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

    func testLogTrace4() {
        _testLog(for: .trace4, TestStaticContext(), writer) { input, writer in

            writer.log(input.timestamp, level: input.level, tag: input.tag, message: input.message, runtimeContext: input.runtimeContext, staticContext: input.staticContext)
        }
    }

}

///
/// Logging through TraceLog to the Logger
///
class TraceLogWithSDJournalWriterTests: XCTestCase {

    let writer = SDJournalWriter()

    override func setUp() {
        TraceLog.configure(writers: [writer], environment: ["LOG_ALL": "TRACE4"])
    }

    func testLogError() {
        _testLog(for: .error, TestStaticContext(), writer) { input, _ in

            logError(input.tag, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogWarning() {
        _testLog(for: .warning, TestStaticContext(), writer) { input, _ in

            logWarning(input.tag, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogInfo() {
        _testLog(for: .info, TestStaticContext(), writer) { input, _ in

            logInfo(input.tag, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace1() {
        _testLog(for: .trace1, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 1, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace2() {
        _testLog(for: .trace2, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 2, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace3() {
        _testLog(for: .trace3, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 3, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }

    func testLogTrace4() {
        _testLog(for: .trace4, TestStaticContext(), writer) { input, _ in

            logTrace(input.tag, level: 4, input.staticContext.file, input.staticContext.function, input.staticContext.line) { input.message }
        }
    }
}

///
///
///
private func _testLog(for level: LogLevel, _ staticContext: TestStaticContext, _ writer: SDJournalWriter, _ syslogIdentifier: String = "TraceLogJournalWriterPackageTests.xctest", logBlock: ((timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: TestRuntimeContext, staticContext: TestStaticContext), SDJournalWriter) -> Void) {

    /// This is the time in microseconds since the epoch UTC to match the journals time stamps.
    let timestamp = Date().timeIntervalSince1970 * 1000.0

    let input = (timestamp: timestamp, level: level, tag:  "TestTag", message: "SDJournalWriter test .\(level) message at timestamp \(timestamp)", runtimeContext: TestRuntimeContext("TestProcess", 10, 100), staticContext: staticContext)

    /// Write to the test writer
    logBlock(input, writer)

     validateJournalEntry(for: input, writer: writer, syslogIdentifier: syslogIdentifier)
}

///
/// Validate that the log record is in the journal
///
private func validateJournalEntry(for input: (timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: TestRuntimeContext, staticContext: TestStaticContext), writer: SDJournalWriter, syslogIdentifier: String) {
    let messageDate = Date(timeIntervalSince1970: input.timestamp / 1000.0)

    let data = shell("journalctl -o json --identifier=\(syslogIdentifier) --since='\(dateFormatter.string(from: messageDate))'")

    guard data.count > 0
            else { XCTFail("Journal entry not found for identifier \"\(syslogIdentifier)\"."); return }
    ///
    /// The journal entries are returned one JSON object per line with
    /// no comma between lines.  This is invalid JSON on it's own so split the
    /// data into individual data elements.  This way the array elements
    /// can be parse individually.
    ///
    guard let string = String(data: data, encoding: .utf8), string.count > 0
        else { XCTFail("Could not convert result data to String."); return }

    let dataArray = string.components(separatedBy: CharacterSet.newlines).compactMap { (string) -> Data? in
        guard let data = string.data(using: .utf8), data.count > 0
                else { return nil }
        return data
    }

    guard dataArray.count > 0
            else { XCTFail("Journal entry not found."); return }

    for jsonData in dataArray {

        do {
           let object = try JSONSerialization.jsonObject(with: jsonData)

            guard let journalEntry = object as? [String: Any]
                    else {  XCTFail("Incorrect json object returned from parsing journalctl results, expected [String: Any] but got \(type(of: object))."); return }

            /// Find the journal entry by message string (message string should be unique based on the string + timestamp).
            if journalEntry["MESSAGE"] as? String ?? "" == input.message {

                ///
                /// These should be all the fields we pass to systemd journal.
                ///
                assertValue(for: journalEntry, key: "SYSLOG_IDENTIFIER", eqauls: syslogIdentifier)
                assertValue(for: journalEntry, key: "PRIORITY",          eqauls: String(writer.convertLogLevel(for: input.level)))
                assertValue(for: journalEntry, key: "CODE_FILE",         eqauls: input.staticContext.file)
                assertValue(for: journalEntry, key: "CODE_LINE",         eqauls: String(input.staticContext.line))
                assertValue(for: journalEntry, key: "CODE_FUNC",         eqauls: input.staticContext.function)
                assertValue(for: journalEntry, key: "TAG",               eqauls: input.tag)

                return  /// If we found a match and compared it, we're done!
            }
        } catch {
            XCTFail("Could parse JSON \(String(data: jsonData, encoding: .utf8) ?? "nil"), error: \(error)."); return
        }
    }
}

private func assertValue(for jsonObject: [String: Any], key: String, eqauls expected: String) {
    let result = jsonObject[key] as? String ?? ""

    XCTAssertEqual(result, expected, "\(key) should be \"\(expected)\" but is equal to \"\(result)\".")
}

///
/// Helper to run the shell and return the output
///
private func shell(_ command: String) -> Data {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    return pipe.fileHandleForReading.readDataToEndOfFile()
}

///
/// StaticContext structure for tests which captures the context for each test func.
///
struct TestStaticContext: StaticContext {
    public let dso: UnsafeRawPointer
    public let file: String
    public let function: String
    public let line: Int

    ///
    /// Init `self` capturing the static environement of the caller.
    ///
    init(_ dso: UnsafeRawPointer = #dsohandle, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        self.dso        = dso
        self.file       = file
        self.function   = function
        self.line       = line
    }
}

///
/// RuntimeContext structure for tests.
///
struct TestRuntimeContext: RuntimeContext {
    public let processName: String
    public let processIdentifier: Int
    public let threadIdentifier: UInt64

    init(_ processName: String, _ processIdentifier: Int, _ threadIdentifier: UInt64) {
        self.processName = processName
        self.processIdentifier = processIdentifier
        self.threadIdentifier = threadIdentifier
    }
}

///
/// Date formater for sending to journalctl
///
let dateFormatter: DateFormatter = {

    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()

#endif
