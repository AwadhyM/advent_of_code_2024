// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "day01",
    targets: [
        // Targets for day 1
        .executableTarget(
            name: "day01"),
		
		.testTarget(name: "day01Tests",
					dependencies: ["day01"],
					path:"Tests",
					sources: ["Day01Tests.swift"]),
		// Targets for day 2
		.executableTarget(
			name: "day02"),
		// Targets for day 3
		.executableTarget(
			name: "day03"),
		
		.testTarget(name: "day03Tests",
					dependencies: ["day03"],
					path:"Tests",
					sources: ["Day03Tests.swift"])
    ]
)

