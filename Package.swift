// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FirstSwiftLambda",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .executable(name: "FirstSwiftLambda", targets: ["FirstSwiftLambda"]),
  ],
  dependencies: [
    .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", .upToNextMajor(from:"0.5.2")),
  ],
  targets: [
    .executableTarget(
      name: "FirstSwiftLambda",
      dependencies: [
        .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
        .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
      ],
      resources: [
        //.process("Config.plist")
      ]
    ),
  ]
)
