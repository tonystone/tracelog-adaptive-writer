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
            .executable(name: "tester", targets: ["TraceLogJournalWriter"])
        ],
        dependencies: [
            .package(url: "https://github.com/felix91gr/Csdjournal.git", .exactItem("0.9.0"))
        ],
        targets: [
            /// Module targets
            .target(name: "TraceLogJournalWriter", dependencies: [], path: "Sources/TraceLogJournalWriter")
        ],
        swiftLanguageVersions: [4]
)
