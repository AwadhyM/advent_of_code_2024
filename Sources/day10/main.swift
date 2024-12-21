//
//  main.swift
//  day10
//
//  Created by Awadhy Mohammed on 18/12/2024.
//

import Foundation

// Main script logic
let path = FileManager.default.currentDirectoryPath
print(path)
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

var grid: [[Character]] = []
for line in text {
    let row = Array(line)
    grid.append(row)
}

grid.removeLast()

// Convert grid to a hashmap of coordinates and heights
struct Coordinate: Hashable {
    let row: Int
    let col: Int
}

struct Trail: Hashable {
    let trailStart: Coordinate
    let trailEnd: Coordinate
}

struct Puzzle {
    let input: [[Character]]
    var coordinateToHeight: [Coordinate: Int] = [:]
    let directions = [Coordinate(row: -1, col: 0), Coordinate(row: 1, col: 0), Coordinate(row: 0, col: 1), Coordinate(row: 0, col: -1)]
    var trailsFound: Set<Trail> = []
    var numberOfPaths: [Coordinate] = []

    init(input: [[Character]]) {
        self.input = input
        coordinateToHeight = mapCoordinatesToHeight()
    }

    private mutating func mapCoordinatesToHeight() -> [Coordinate: Int] {
        var coordinateToHeight: [Coordinate: Int] = [:]
        for row in 0 ..< input.count {
            for col in 0 ..< input[row].count {
                coordinateToHeight[Coordinate(row: row, col: col)] = Int(String(input[row][col]))
            }
        }
        return coordinateToHeight
    }

    mutating func solvePart1() {
        for (coordinate, height) in coordinateToHeight {
            if height == 0 {
                findPath(trailStart: coordinate, currentPos: coordinate)
            }
        }
        print(trailsFound.count)
        print(numberOfPaths.count)
    }

    mutating func findPath(trailStart: Coordinate, currentPos: Coordinate) -> Int {
        if coordinateToHeight[currentPos] == 9 {
            numberOfPaths.append(currentPos)
            trailsFound.insert(Trail(trailStart: trailStart, trailEnd: currentPos))
        }

        for direction in directions {
            let nextPos = Coordinate(row: currentPos.row + direction.row, col: currentPos.col + direction.col)

            if willBeOutOfBounds(coordinate: nextPos) {
                continue
            }

            let currentHeight = coordinateToHeight[currentPos]!
            let nextHeight = coordinateToHeight[nextPos]!

            if nextHeight - currentHeight != 1 {
                continue
            } else {
                findPath(trailStart: trailStart, currentPos: nextPos)
            }
        }
        return 0
    }

    func willBeOutOfBounds(coordinate: Coordinate) -> Bool {
        return (coordinate.col < 0 || coordinate.col >= input.count - 1) || (coordinate.row < 0 || coordinate.row >= input.count - 1)
    }
}

var puzzle = Puzzle(input: grid)
puzzle.solvePart1()
