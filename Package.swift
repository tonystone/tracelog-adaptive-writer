// swift-tools-version:4.0
///
/// Package.swift
///
/// Created by Tony Stone on 5/27/18.
///
import PackageDescription

let package = Package(
        name: "TraceLogJournalWriter",
        products: [
            .library(name: "TraceLogJournalWriter", type: .dynamic, targets: ["TraceLogJournalWriter"])
        ],
        dependencies: [
            .package(url: "https://github.com/tonystone/tracelog.git", from: "2.0.0"),
            .package(url: "https://github.com/tonystone/csdjournal.git", .branchItem("master"))
        ],
        targets: [
            /// Module targets
            .target(name: "TraceLogJournalWriter", dependencies: ["TraceLog", "CSDJournal"], path: "Sources/TraceLogJournalWriter"),

            /// Tests
            .testTarget(name: "TraceLogJournalWriterTests", dependencies: ["TraceLogJournalWriter"], path: "Tests/TraceLogJournalWriterTests")
        ],
        swiftLanguageVersions: [4]
)
