// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogseqTodo",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "LogseqTodo",
            targets: ["LogseqTodo"]
        )
    ],
    targets: [
        .executableTarget(
            name: "LogseqTodo",
            dependencies: [],
            path: "Sources/LogseqTodo",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "LogseqTodoTests",
            dependencies: ["LogseqTodo"],
            path: "Tests/LogseqTodoTests"
        )
    ]
)