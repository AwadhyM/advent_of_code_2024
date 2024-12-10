//
//  main.swift
//  day08
//
//  Created by Awadhy Mohammed on 09/12/2024.
//

import Algorithms
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
var text: [String] = file.components(separatedBy: "\n")

var grid: [[Character]] = []
for line in text {
    let row = Array(line)
    grid.append(row)
}

grid.removeLast()

struct Coordinate: Hashable {
    let row: Int
    let col: Int
}

struct Puzzle {
    var inputGrid: [[Character]]
    var antennaLocations: [Character: Set<Coordinate>] = [:]

    init(inputGrid: [[Character]]) {
        self.inputGrid = inputGrid
        retrieveAntennaLocations()
    }

    mutating func retrieveAntennaLocations() {
        for row in 0 ..< inputGrid.count {
            for col in 0 ..< inputGrid[row].count {
                let gridVal = inputGrid[row][col]

                if gridVal == "." {
                    continue
                }

                if antennaLocations[gridVal] == nil {
                    antennaLocations[gridVal] = Set<Coordinate>()
                }
                antennaLocations[gridVal]?.insert(Coordinate(row: row, col: col))
            }
        }
    }

    func calculateDyDx(coordinate1: Coordinate, coordinate2: Coordinate) -> (Int, Int) {
        let (dy, dx) = (coordinate2.row - coordinate1.row, coordinate2.col - coordinate1.col)

        return (dy, dx)
    }

    func isOutOfBounds(coordinate: Coordinate) -> Bool {
        if coordinate.row > inputGrid.count - 1 || coordinate.row < 0 {
            return true
        }

        if coordinate.col > inputGrid.count - 1 || coordinate.col < 0 {
            return true
        }

        return false
    }

    mutating func solvePart1() {
        var antinodes: Set<Coordinate> = []
        for antenaFreq in antennaLocations.values {
            let coordinatePairs = antenaFreq.combinations(ofCount: 2)
            for coordinatePair in coordinatePairs {
                let coordinateOne = coordinatePair[0]
                let coordinateTwo = coordinatePair[1]

                let (dy, dx) = calculateDyDx(coordinate1: coordinateOne, coordinate2: coordinateTwo)

                let antinodeOne = Coordinate(row: coordinateOne.row + 2 * dy, col: coordinateOne.col + 2 * dx)

                let antinodeTwo = Coordinate(row: coordinateTwo.row - 2 * dy, col: coordinateTwo.col - 2 * dx)

                if !isOutOfBounds(coordinate: antinodeOne) {
                    antinodes.insert(antinodeOne)
                }

                if !isOutOfBounds(coordinate: antinodeTwo) {
                    antinodes.insert(antinodeTwo)
                }
            }
            print(antinodes.count)
        }
    }

    mutating func solvePart2() {
        var antinodes: Set<Coordinate> = []
        for antenaFreq in antennaLocations.values {
            let coordinatePairs = antenaFreq.combinations(ofCount: 2)
            for coordinatePair in coordinatePairs {
                print(coordinatePair)
                let coordinateOne = coordinatePair[0]
                let coordinateTwo = coordinatePair[1]
                let (dy, dx) = calculateDyDx(coordinate1: coordinateOne, coordinate2: coordinateTwo)

                let antinodeOne = Coordinate(row: coordinateOne.row + 2 * dy, col: coordinateOne.col + 2 * dx)

                let antinodeTwo = Coordinate(row: coordinateTwo.row - 2 * dy, col: coordinateTwo.col - 2 * dx)

                if !isOutOfBounds(coordinate: antinodeOne) {
                    antinodes.insert(antinodeOne)
                }

                if !isOutOfBounds(coordinate: antinodeTwo) {
                    antinodes.insert(antinodeTwo)
                }
            }
        }
        print(antinodes.count)
    }
}

var puzzle = Puzzle(inputGrid: grid)
puzzle.solvePart1()
