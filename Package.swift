// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "day01",
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "day01"),
		
		.testTarget(name: "day01Tests",
					dependencies: ["day01"],
					path:"Tests",
					sources: ["Day01Tests.swift"])
    ]
)

