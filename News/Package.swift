// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "News",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "News",
            targets: ["News"]),
    ],
    dependencies: [
        .package(url: "https://github.com/archivable/package.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "News",
            dependencies: [
                .product(name: "Archivable", package: "package")],
            path: "Sources"),
        .testTarget(
            name: "Tests",
            dependencies: ["News"],
            path: "Tests")
    ]
)
