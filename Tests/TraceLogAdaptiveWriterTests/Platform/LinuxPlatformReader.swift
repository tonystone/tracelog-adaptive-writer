///
///  LinuxPlatformValidator.swift
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
#if os(Linux)

import XCTest
import TraceLog

@testable import TraceLogAdaptiveWriter

class LinuxPlatformReader: Reader {

    func logEntry(for writer: AdaptiveWriter, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> TestLogEntry? {

        let command = "journalctl -o json --identifier='\(writer.subsystem)' -n 1"

        guard let data = try? shell(command)
            else { XCTFail("Could not run shell command \(command)."); return nil }

        guard data.count > 0
                else { XCTFail("Journal entry not found for subsystem: \"\(writer.subsystem)\"."); return nil }
        ///
        /// The journal entries are returned one JSON object per line with
        /// no comma between lines.  This is invalid JSON on it's own so split the
        /// data into individual data elements.  This way the array elements
        /// can be parse individually.
        ///
        guard let string = String(data: data, encoding: .utf8), string.count > 0
            else { XCTFail("Could not convert result data to String."); return nil }

        let dataArray = string.components(separatedBy: CharacterSet.newlines).compactMap { (string) -> Data? in
            guard let data = string.data(using: .utf8), data.count > 0
                    else { return nil }
            return data
        }

        guard dataArray.count > 0
                else { XCTFail("Journal entry not found for subsystem: \"\(writer.subsystem)\"."); return nil }

        for jsonData in dataArray {

            do {
            let object = try JSONSerialization.jsonObject(with: jsonData)

                guard let journalEntry = object as? [String: Any]
                        else {  XCTFail("Incorrect json object returned from parsing journalctl results, expected [String: Any] but got \(type(of: object))."); return nil }

                /// Find the journal entry by message string (message string should be unique based on the string + timestamp).
                if journalEntry["MESSAGE"] as? String ?? "" == message {

                    var customAttributes: [String:  Any]? = nil

                    if let subsystem = journalEntry["SYSLOG_IDENTIFIER"] as? String {
                        customAttributes = ["subsystem": subsystem]
                    }

                    // var logLevel: LogLevel? = nil
                    // if let tmpLevel = journalEntry["PRIORITY"] as? String {

                    // }

                    var line: Int? = nil
                    if let string = journalEntry["CODE_LINE"] as? String {
                        line = Int(string)
                    }


                    return TestLogEntry(timestamp:  timestamp,
                                    level:      level,
                                    message:    message,
                                    tag:        journalEntry["TAG"] as? String,
                                    file:       journalEntry["CODE_FILE"] as? String,
                                    function:   journalEntry["CODE_FUNC"] as? String,
                                    line:       line,
                                    customAttributes: customAttributes
                                    )
                }
            } catch {
                XCTFail("Could parse JSON \(String(data: jsonData, encoding: .utf8) ?? "nil"), error: \(error)."); /// Fallthrough
            }
        }
        return nil
    }
}

class LinuxPlatformValidator: _PlatformValidator {

    static var `default`: Platform.LogLevel { return Platform.LogLevel(LOG_INFO) }
    static var error:     Platform.LogLevel { return Platform.LogLevel(LOG_ERR) }
    static var warning:   Platform.LogLevel { return Platform.LogLevel(LOG_WARNING) }
    static var info:      Platform.LogLevel { return Platform.LogLevel(LOG_INFO) }
    static var trace1:    Platform.LogLevel { return Platform.LogLevel(LOG_DEBUG) }
    static var trace2:    Platform.LogLevel { return Platform.LogLevel(LOG_DEBUG) }
    static var trace3:    Platform.LogLevel { return Platform.LogLevel(LOG_DEBUG) }
    static var trace4:    Platform.LogLevel { return Platform.LogLevel(LOG_DEBUG) }
}

#endif
