///
///  LinuxMain.swift
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

@testable import TraceLogJournalWriterTests

XCTMain([
    testCase(SDJournalWriterTests.allTests),
    testCase(TraceLogWithSDJournalWriterTests.allTests)
])

extension SDJournalWriterTests {
    static var allTests: [(String, (SDJournalWriterTests) -> () throws -> Void)] {
        return [
            ("testLogError", testLogError),
            ("testLogWarning", testLogWarning),
            ("testLogInfo", testLogInfo),
            ("testLogTrace1", testLogTrace1),
            ("testLogTrace2", testLogTrace2),
            ("testLogTrace3", testLogTrace3),
            ("testLogTrace4", testLogTrace4),
            ("testConvertLogLevelForError",   testConvertLogLevelForError),
            ("testConvertLogLevelForWarning", testConvertLogLevelForWarning),
            ("testConvertLogLevelForInfo",    testConvertLogLevelForInfo),
            ("testConvertLogLevelForTrace1",  testConvertLogLevelForTrace1),
            ("testConvertLogLevelForTrace2",  testConvertLogLevelForTrace2),
            ("testConvertLogLevelForTrace3",  testConvertLogLevelForTrace3),
            ("testConvertLogLevelForTrace4",  testConvertLogLevelForTrace4),
            ("testConvertLogLvelErrorWithEmptyConversionTable", testConvertLogLvelErrorWithEmptyConversionTable),
            ("testConvertLogLvelWarningWithEmptyConversionTable", testConvertLogLvelWarningWithEmptyConversionTable),
            ("testConvertLogLvelInfoWithEmptyConversionTable", testConvertLogLvelInfoWithEmptyConversionTable),
            ("testConvertLogLvelTrace1WithEmptyConversionTable", testConvertLogLvelTrace1WithEmptyConversionTable),
            ("testConvertLogLvelTrace2WithEmptyConversionTable", testConvertLogLvelTrace2WithEmptyConversionTable),
            ("testConvertLogLvelTrace3WithEmptyConversionTable", testConvertLogLvelTrace3WithEmptyConversionTable),
            ("testConvertLogLvelTrace4WithEmptyConversionTable", testConvertLogLvelTrace4WithEmptyConversionTable),

        ]
    }
}

extension TraceLogWithSDJournalWriterTests {
    static var allTests: [(String, (TraceLogWithSDJournalWriterTests) -> () throws -> Void)] {
        return [
            ("testLogError", testLogError),
            ("testLogWarning", testLogWarning),
            ("testLogInfo", testLogInfo),
            ("testLogTrace1", testLogTrace1),
            ("testLogTrace2", testLogTrace2),
            ("testLogTrace3", testLogTrace3),
            ("testLogTrace4", testLogTrace4),
        ]
    }
}

#endif
