///
/// main.swift
///
/// Created by Tony Stone on 5/27/18.
///

import Foundation
import CSDJournal

var utf8Text  = ["MESSAGE=Test Message".utf8CString,
                 "CODE_FILE=\(#file)".utf8CString,
                 "CODE_LINE=\(#line)".utf8CString,
                 "CODE_FUNC=\(#function)".utf8CString,
                 "PRIORITY=\(LOG_INFO)".utf8CString
]

var array: [iovec] = []

for i in 0..<utf8Text.count {
    let count = utf8Text[i].count - 1
    utf8Text[i].withUnsafeMutableBytes { (bytes) -> Void in
        if let address = bytes.baseAddress {
            array.append(iovec(iov_base: address, iov_len: count))
        }
    }
}

print("Call result: \(sd_journal_sendv(&array, Int32(array.count)))")


/// Another possibly cleaner implementation without a shim.
withVaList([]) { vaList -> Void in
    print("Call result: \(sd_journal_printv_with_location(LOG_INFO, "CODE_FILE=\(#file)", "CODE_LINE=\(#line)", "\(#function)", "Test Message", vaList))")
}
