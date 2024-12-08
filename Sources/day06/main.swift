//
//  main.swift
//  day01
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

/* Breaking part 1 into sub problems
 1. Store the contents of the grid in a matrix [Done]
 2. Find the guard in the grid, and store their coordinates [Done]
 3. Store the state of the guard their direction and coordinates [Done]
 4. TraverseMapFunction() {
 	5. Write a function to see if next move will be out of bounds
 		     Break out of loop if so [Done]
 	6. Write a function to see if their is an obstacle ahead and if so change direction [Done]
 	7. move the guard
 	8. 	mark previous spot with an X
 	9.  mark new spot with guard
 	10. Exit function and return sum
 }
 */

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

let dirToSymbol: [direction: Character] = [
    .east: ">",
    .west: "<",
    .north: "^",
    .south: "v",
]

let SymbolToDir: [Character: direction] = [
    ">": direction.east,
    "<": direction.west,
    "^": direction.north,
    "v": direction.south,
]

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

// Function that determines if next step is out of bounds
func nextMoveOutBounds(map: [[Character]], guardPos: (Int, Int), facing: direction) -> Bool {
    let (dy, dx) = facing.coordinateChange

    let y = guardPos.0 + dy
    let x = guardPos.1 + dx
    return (x < 0 || x > map.count - 1) || (y < 0 || y > map.count - 1)
}

// Function to check for obstacle ahead and change direction if true
func obstacleAhead(map: [[Character]], guardPos: (Int, Int), facing: direction) -> Bool {
    let (dy, dx) = facing.coordinateChange

    let y = guardPos.0 + dy
    let x = guardPos.1 + dx
    return map[y][x] == "#"
}

if let guardPos = findGuardPos(map: grid) {
    let guardDirection = SymbolToDir[grid[guardPos.0][guardPos.1]]!
    print(guardDirection)
    print(obstacleAhead(map: grid, guardPos: guardPos, facing: guardDirection))
}

//	func move(map: [[Character]], guardPos: (Int, Int), facing: direction) {
//		let (dy, dx) = facing.coordinateChange
//
//		let y = guardPos.0 + dy
//		let x = guardPos.1 + dx
//		guardPosition = (y, x)
//	}

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
// print(visited)

func solvePart2(map: [[Character]], visited: Set<Coordinate>) {
    let startPos = visited.first
    var sum = 0
    // For every coordinate in visited
    for coordinate in visited {
        var mapCpy = map
        if mapCpy[coordinate.row][coordinate.col] == "#" || mapCpy[coordinate.row][coordinate.col] == "^" {
            continue
        }
        mapCpy[coordinate.row][coordinate.col] = "#"
        var guardPos = findGuardPos(map: mapCpy)!
        var guardDirection = SymbolToDir[mapCpy[guardPos.0][guardPos.1]]!
        var traversed = false
        var newVisited = Set<Coordinate>()
        while !traversed {
            if nextMoveOutBounds(map: mapCpy, guardPos: guardPos, facing: guardDirection) {
                traversed = true
                continue
            }
            while obstacleAhead(map: mapCpy, guardPos: guardPos, facing: guardDirection) {
                guardDirection = guardDirection.rotate()
            }

            // print(guardDirection)
            let (dy, dx) = guardDirection.coordinateChange
            mapCpy[guardPos.0][guardPos.1] = "X"
            if newVisited.contains(Coordinate(row: guardPos.0, col: guardPos.1)) {
                print("Loop detected")
                sum += 1
                break
            }
            newVisited.insert(Coordinate(row: guardPos.0, col: guardPos.1))
            let y = guardPos.0 + dy
            let x = guardPos.1 + dx
            guardPos = (y, x)
            mapCpy[guardPos.0][guardPos.1] = dirToSymbol[guardDirection]!
        }
    }
    print(sum + 1)
}

solvePart2(map: grid, visited: visited)
