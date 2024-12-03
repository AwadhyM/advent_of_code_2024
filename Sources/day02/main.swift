//
//  main.swift
//  2024_advent_of_code
//
//  Created by Awadhy Mohammed on 02/12/2024.
//

// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// Main script logic
print("Current directory: \(FileManager.default.currentDirectoryPath)")

let expectedArgumentCount = 2 // Adjust this to the number of arguments you expect

if CommandLine.argc != expectedArgumentCount {
    print("Usage: \(CommandLine.arguments[0]) <arg1>")
    exit(1)
}

// Get file from command line argument
let inputFileRelativePath = CommandLine.arguments[1]
print(inputFileRelativePath)

// Check if file can be opened
let fileManager = FileManager.default
if !fileManager.isReadableFile(atPath: inputFileRelativePath) {
    print("File cannot be opened.")
    exit(0)
}

let file = try String(contentsOfFile: inputFileRelativePath)
var text: [String] = file.components(separatedBy: "\n")

func graduallyDecrease(levels: [Int]) -> Bool {
    var previousElement: Int?
    for level in levels {
        if let previous = previousElement {
            if previous <= level {
                return false
            }
            if abs(previous - level) > 3 {
                return false
            }
        }
        previousElement = level
    }
    return true
}

func solvePart1(_ array: [String]) {
    var sum = 0
    for level in array {
        if level.isEmpty {
            continue
        }

        let levels = level.components(separatedBy: " ")
        let intLevels = levels.map { Int($0) ?? 0 }
        if graduallyDecrease(levels: intLevels.reversed()) || graduallyDecrease(levels: intLevels) {
            sum += 1
        }
    }
    print(sum)
}

func removeElement(at index: Int, from array: [Int]) -> [Int] {
    return array.enumerated().filter { $0.offset != index }.map { $0.element }
}

func useDampener(line: [Int]) -> Bool {
    var previousElement: Int?
    var pos = 0
    var safe = true
    for level in line {
        if let previous = previousElement {
            safe = (abs(previous - level) > 3) && (level - previous > 3 || level - previous <= 0)
            if !safe {
                let copyLevel = removeElement(at: pos, from: line)
                let safeWithDampener = graduallyDecrease(levels: copyLevel) || graduallyDecrease(levels: copyLevel.reversed())
                if safeWithDampener {
                    return true
                }
            }
        }
        previousElement = level
        pos += 1
    }
    return false
}

func bruteForce(line: [Int]) -> Bool {
    var pos = 0
    for level in line {
        let copyLevel = removeElement(at: pos, from: line)
        if graduallyDecrease(levels: copyLevel.reversed()) || graduallyDecrease(levels: copyLevel) {
            return true
        }
        pos += 1
    }
    return false
}

func solvePart2(_ array: [String]) {
    var sum = 0
    for level in array {
        if level.isEmpty {
            continue
        }
        let levels = level.components(separatedBy: " ")
        let intLevels = levels.map { Int($0) ?? 0 }
        if graduallyDecrease(levels: intLevels.reversed()) || graduallyDecrease(levels: intLevels) {
            sum += 1
            continue
        }
        if bruteForce(line: intLevels) {
            sum += 1
            continue
        }
    }
    print(sum)
}

solvePart1(text)
solvePart2(text)
