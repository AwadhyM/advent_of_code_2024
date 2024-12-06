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
					sources: ["Day03Tests.swift"]),
		// Targets for day 4
			.executableTarget(
				name: "day04"),
			
			.testTarget(name: "day04Tests",
						dependencies: ["day04"],
						path:"Tests",
						sources: ["Day04Tests.swift"]),
		// Targets for day 5
			.executableTarget(
				name: "day05"),
			
			.testTarget(name: "day05Tests",
						dependencies: ["day05"],
						path:"Tests",
						sources: ["Day05Tests.swift"]),
		// Targets for day 6
			.executableTarget(
				name: "day06"),
    ]
)

