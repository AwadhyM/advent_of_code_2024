//
//  main.swift
//  day06
//
//  Created by Awadhy Mohammed on 06/12/2024.
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

enum direction {
    case north,
         east,
         south,
         west

    var coordinateChange: (row: Int, col: Int) {
        switch self {
        case .north:
            return (-1, 0)
        case .south:
            return (1, 0)
        case .east:
            return (0, 1)
        case .west:
            return (0, -1)
        }
    }

    func rotate() -> direction {
        switch self {
        case .north:
            return .east
        case .south:
            return .west
        case .east:
            return .south
        case .west:
            return .north
        }
    }
}

let directions: [(direction, Character)] = [
    (.east, ">"),
    (.west, "<"),
    (.north, "^"),
    (.south, "v"),
]

let dirToSymbol = Dictionary(uniqueKeysWithValues: directions)
let SymbolToDir = Dictionary(uniqueKeysWithValues: directions.map { ($1, $0) })

// Function finds the location of the guard on the map
func findGuardPos(map: [[Character]]) -> (Int, Int)? {
    for row in 0 ..< map.count {
        for col in 0 ..< map[row].count {
            let pos = map[row][col]
            if pos == "^" || pos == "<" || pos == "v" || pos == ">" {
                return (row, col)
            }
        }
    }
    return nil
}

// Function that returns set of coordinates of next move
func getNextCoordinates(map _: [[Character]], guardPos: (Int, Int), facing: direction) -> (Int, Int) {
    let (dy, dx) = facing.coordinateChange

    let y = guardPos.0 + dy
    let x = guardPos.1 + dx
    return (y, x)
}

// Function that determines if next step is out of bounds
func nextMoveOutBounds(map: [[Character]], guardPos: (Int, Int), facing: direction) -> Bool {
    let (y, x) = getNextCoordinates(map: map, guardPos: guardPos, facing: facing)

    return (x < 0 || x > map.count - 1) || (y < 0 || y > map.count - 1)
}

// Function to check for obstacle ahead and change direction if true
func obstacleAhead(map: [[Character]], guardPos: (Int, Int), facing: direction) -> Bool {
    let (y, x) = getNextCoordinates(map: map, guardPos: guardPos, facing: facing)

    return map[y][x] == "#"
}

struct Coordinate: Hashable {
    let row: Int
    let col: Int
}

func traverseMap(map: [[Character]]) -> Set<Coordinate> {
    // Find the guard
    var guardPos = findGuardPos(map: map)!
    var mapCpy = map
    // Set their direction
    var guardDirection = SymbolToDir[map[guardPos.0][guardPos.1]]!
    var visited = Set<Coordinate>()
    while !nextMoveOutBounds(map: map, guardPos: guardPos, facing: guardDirection) {
        while obstacleAhead(map: map, guardPos: guardPos, facing: guardDirection) {
            guardDirection = guardDirection.rotate()
        }

        // print(guardDirection)
        let (dy, dx) = guardDirection.coordinateChange
        mapCpy[guardPos.0][guardPos.1] = "X"
        visited.insert(Coordinate(row: guardPos.0, col: guardPos.1))
        let y = guardPos.0 + dy
        let x = guardPos.1 + dx
        guardPos = (y, x)
        mapCpy[guardPos.0][guardPos.1] = dirToSymbol[guardDirection]!
    }
    print(visited.count + 1)
    return visited
}

var visited = traverseMap(map: grid)
visited.dropFirst()

func solvePart2(map: [[Character]], visited: Set<Coordinate>) {
    let startPos = visited.first

    var sum = 0
    // For every coordinate in visited
    for coordinate in visited {
        var mapCpy = map

        // Don't place obstacle in start positino
        if mapCpy[coordinate.row][coordinate.col] == "^" {
            continue
        }
        // Place obstacle
        mapCpy[coordinate.row][coordinate.col] = "#"

        // Set the guards position and direction
        var guardPos = findGuardPos(map: mapCpy)!
        var guardDirection = SymbolToDir[mapCpy[guardPos.0][guardPos.1]]!

        var traversed = false
        var newVisited = Set<Coordinate>()
        var countVisited: [Coordinate: Int] = [:]

        while !traversed {
            if nextMoveOutBounds(map: mapCpy, guardPos: guardPos, facing: guardDirection) {
                traversed = true
                continue
            }
            while obstacleAhead(map: mapCpy, guardPos: guardPos, facing: guardDirection) {
                guardDirection = guardDirection.rotate()
            }

            let (dy, dx) = guardDirection.coordinateChange
            let guardCoordinates = Coordinate(row: guardPos.0, col: guardPos.1)

            countVisited[guardCoordinates, default: 0] += 1
            if countVisited[guardCoordinates]! > 5 {
                sum += 1
                break
            }

            let y = guardPos.0 + dy
            let x = guardPos.1 + dx
            guardPos = (y, x)
            mapCpy[guardPos.0][guardPos.1] = dirToSymbol[guardDirection]!
        }
    }
    print(sum + 1) // TODO: figure out off by one
    // TODO: clean up solution
}

solvePart2(map: grid, visited: visited)
