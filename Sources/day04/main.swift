//
//  main.swift
//  day01
//
//  Created by Awadhy Mohammed on 03/12/2024.
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

print(grid)

struct Puzzle {
    let grid: [[Character]]
    var directions: [String: (Int, Int)] = [
        // left: (row, column)
        "left": (0, -1),
        "right": (0, 1),
        "down": (1, 0),
        "up": (-1, 0),
        "Northwest": (-1, -1),
        "Northeast": (-1, 1),
        "Southwest": (1, -1),
        "Southeast": (1, 1),
    ]
    var targetWord = "XMAS"

    func findWord(startPos: (Int, Int), direction: (Int, Int), targetWord: String) -> Bool {
        var row = startPos.0
        var col = startPos.1
        var constructedWord = ""

        while (col >= 0 && col < grid[row].count) && (row > 0 && row < grid.count) && constructedWord.count < targetWord.count {
            constructedWord += String(grid[row][col])
            row += direction.0
            col += direction.1
        }
        return constructedWord == targetWord
    }

    func solvePart1() {
        var sum = 0
        for row in 0 ..< grid.count {
            for col in 0 ..< grid[row].count {
                for direction in directions.values {
                    if findWord(startPos: (row, col), direction: direction, targetWord: "XMAS") {
                        sum += 1
                    }
                }
            }
        }
        print("\(sum)")
    }

    func checkMiddle(startPos: (Int, Int)) -> Bool {
        let row = startPos.0
        let col = startPos.1

        while (col > 0 && col <= grid[row].count - 2) && (row > 0 && row < grid.count - 2) {
            let northWest = String(grid[row - 1][col - 1])
            let southEast = String(grid[row + 1][col + 1])
            let northEast = String(grid[row - 1][col + 1])
            let southWest = String(grid[row + 1][col - 1])
            let current = String(grid[row][col])

            let left = northWest + current + southEast
            let right = northEast + current + southWest

            return (left == "MAS" || left == "SAM") && (right == "MAS" || right == "SAM")
        }
        return false
    }

    func solvePart2() {
        var sum = 0
        for row in 0 ..< grid.count {
            for col in 0 ..< grid[row].count {
                if grid[row][col] == "A" {
                    if checkMiddle(startPos: (row, col)) {
                        sum += 1
                    }
                }
            }
            print("\(sum)")
        }
    }
}

var puzzle = Puzzle(grid: grid)
puzzle.solvePart1()
puzzle.solvePart2()
