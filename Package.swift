// swift-tools-version:5.0
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
            .package(url: "https://github.com/tonystone/tracelog.git", "5.0.0"...)
        ],
        targets: [
            /// Module targets
            .systemLibrary(name: "systemd", pkgConfig: "libsystemd"),
            .target(name: "TraceLogAdaptiveWriter", dependencies: ["TraceLog", "systemd"], path: "Sources/TraceLogAdaptiveWriter"),

            /// Tests
            .testTarget(name: "TraceLogAdaptiveWriterTests", dependencies: ["TraceLogAdaptiveWriter", "TraceLog"], path: "Tests/TraceLogAdaptiveWriterTests")
        ],
        swiftLanguageVersions: [.version("5")]
)
