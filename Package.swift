// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Stratus",
    products: [
        .executable(name: "Stratus", targets: ["Stratus"])
    ],
    dependencies: [
        .package(url: "https://github.com/socketio/socket.io-client-swift", .upToNextMinor(from: "13.1.0"))
    ],
    targets: [
        .target(name: "Stratus", dependencies: ["SocketIO"], path: "./Stratus")
    ]
)
