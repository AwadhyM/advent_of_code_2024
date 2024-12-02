// The Swift Programming Language
// https://docs.swift.org/swift-book

// print("Hello, world!")

import Foundation

// Main script logic
let expectedArgumentCount = 2 // Adjust this to the number of arguments you expect

if CommandLine.argc != expectedArgumentCount {
    print("Usage: \(CommandLine.arguments[0]) <arg1>")
    exit(1)
}

// Get file from command line argument
let inputFileRelativePath = CommandLine.arguments[1]

// Check if file can be opened
let fileManager = FileManager.default
if !fileManager.isReadableFile(atPath: inputFileRelativePath) {
    print("File cannot be opened.")
    exit(0)
}

let file = try String(contentsOfFile: inputFileRelativePath)
let text: [String] = file.components(separatedBy: "\n")

struct Puzzle {
    var leftLocations: [Int]
    var rightLocations: [Int]

    init(locations: [String]) {
        leftLocations = locations.map { string -> Int in
            let components = string.components(separatedBy: " ").compactMap { Int($0) }
            return components.first ?? 0
        }
		rightLocations = locations.map { string -> Int in
            let components = string.components(separatedBy: " ").compactMap { Int($0) }
            return components.last ?? 0
        }
    }

    func solvePart1() {
        let rightSorted = rightLocations.sorted()
        let leftSorted = leftLocations.sorted()
        let sum = zip(rightSorted, leftSorted)
            .map { abs($0 - $1) }
            .reduce(0, +)
        print(sum)
    }

    func solvePart2() {
        // Dictionary mapping location ID (from left) to number of occurences in the right
        var rightFrequencies: [Int: Int] = [:]

        for location in rightLocations {
            if let count = rightFrequencies[location] {
                rightFrequencies[location] = count + 1
            } else {
                rightFrequencies[location] = 1
            }
        }

        var sum = 0
        for location in leftLocations {
            sum += location * (rightFrequencies[location] ?? 0)
        }
        print(sum)
    }
}

var locations = Puzzle(locations: text)
locations.solvePart1()
locations.solvePart2()
