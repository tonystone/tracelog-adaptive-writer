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
            .package(url: "https://github.com/tonystone/Csdjournal.git", .branchItem("master"))
        ],
        targets: [
            .target(name: "TraceLogJournalWriter", dependencies: ["CSDJournal"], path: "Sources/TraceLogJournalWriter"),
        ],
        swiftLanguageVersions: [4]
)
