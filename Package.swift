// swift-tools-version:5.3
///
/// Package.swift
///
/// Created by Tony Stone on 5/27/18.
///
import PackageDescription

let package = Package(
        name: "TraceLogAdaptiveWriter",
        platforms: [.iOS(.v9), .macOS(.v10_13), .tvOS(.v9), .watchOS(.v2)],
        products: [
            .library(name: "TraceLogAdaptiveWriter", targets: ["TraceLogAdaptiveWriter"])
        ],
        dependencies: [
            .package(url: "https://github.com/tonystone/tracelog.git", from: "5.0.1")
        ],
        targets: [
            /// Module targets
            .target(name: "TraceLogAdaptiveWriter",
                    dependencies: [.product(name: "TraceLog", package: "TraceLog")],
                    path: "Sources/TraceLogAdaptiveWriter"
                   ),

            /// Tests
            .testTarget(name: "TraceLogAdaptiveWriterTests",
                        dependencies: [.product(name: "TraceLog", package: "TraceLog"), "TraceLogAdaptiveWriter"],
                        path: "Tests/TraceLogAdaptiveWriterTests")
        ],
        swiftLanguageVersions: [.version("5")]
)
