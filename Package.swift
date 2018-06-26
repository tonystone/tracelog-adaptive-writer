// swift-tools-version:4.1
///
/// Package.swift
///
/// Created by Tony Stone on 5/27/18.
///
import PackageDescription

let package = Package(
        name: "TraceLogAdaptiveWriter",
        products: [
            .library(name: "TraceLogAdaptiveWriter", type: .dynamic, targets: ["TraceLogAdaptiveWriter"])
        ],
        dependencies: [
            .package(url: "https://github.com/tonystone/tracelog.git", from: "4.0.0-beta.2"),
            .package(url: "https://github.com/tonystone/csdjournal.git", .branchItem("master"))
        ],
        targets: [
            /// Module targets
            .target(name: "TraceLogAdaptiveWriter", dependencies: ["TraceLog", "CSDJournal"], path: "Sources/TraceLogAdaptiveWriter"),

            /// Tests
            .testTarget(name: "TraceLogAdaptiveWriterTests", dependencies: ["TraceLogAdaptiveWriter", "TraceLog"], path: "Tests/TraceLogAdaptiveWriterTests")
        ],
        swiftLanguageVersions: [4]
)
