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

/* Breaking Part 1 down into sub problems:
 1. Store the map in an appropriate data structure, and print the map. [DONE]
 2. Locate the current position of the guard [Done]
 2. Track where the guard is facing [Done]
 2. Calculate if the next move will be out of bounds [Done]
 3. Calculate if there is an obstacle ahead [Done]
 4. Move function []
 6. solve p1 function:
 	var set[(Int, Int)]
 	if you are going to go out bounds
 		set.append(coordinates)
 		print(set.size)
 		break function
 	if obstacleinway()
 		rotate
 		continue
 	move()
 5. Keep track of coordinates already stepped on
 */

struct Puzzle {
    enum direction {
        case north, east, west, south, invalid

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
            case .invalid:
                return (-10, -10) // No idea...
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
            case .invalid:
                return .invalid // No idea...
            }
        }
    }

    let map: [[Character]]
    var guardPosition: (Int, Int) = (0, 0)
    var guardFacing: direction = .south
	var pathCoordinates: [(Int, Int)] = []

    init(map: [[Character]]) {
        self.map = map
		guardPosition = findGuardPosition(map: map)
        guardFacing = determineStartDirection()
    }
	
	mutating func traverseMap(map: [[Character]]) -> Int {
		var traversed = false
		var mapCpy = map
		var steps = 0
		while traversed == false {
			steps += 1
			if steps == 8000 {
				break
			}
			if nextMoveOutBounds(map: mapCpy) {
				print("Out of bounds!")
				mapCpy[guardPosition.0][guardPosition.1] = "x"
				self.pathCoordinates.append(guardPosition)
				traversed = true
				continue
			}
			if !nextMoveClear(map: mapCpy) {
				guardFacing = guardFacing.rotate()
			} else {
				self.pathCoordinates.append(guardPosition)
				move()
			}
		}
		
		if traversed {
			return 0
		}
		return 1
	}
	
	mutating func placeObstacles() -> Int {
		var sum = 0
		for coordinate in self.pathCoordinates {
			var mapCpy = self.map
			self.guardPosition = self.findGuardPosition(map: map)
			self.guardFacing = direction.north
			mapCpy[self.guardPosition.0][self.guardPosition.1] = "^"
			mapCpy[coordinate.0][coordinate.1] = "#"
//			sum += traverseMap(map: mapCpy)
			
			var traversed = false
			var steps = 0
			while traversed == false {
				//print(self.guardPosition)
				steps += 1
				if steps == 20000 {
					break
				}
				if nextMoveOutBounds(map: mapCpy) {
					//print("Out of bounds!")
					traversed = true
					continue
				}
				if !nextMoveClear(map: mapCpy) {
					guardFacing = guardFacing.rotate()
				} else {
					move()
				}
			}
			if traversed {
				sum += 0
			} else {
				sum += 1
			}
		}
		return sum
	}
	
	mutating func solvePart2() {
		print(placeObstacles())
	}

    mutating func solvePart1() {
		let res = traverseMap(map: self.map)
		print(res)
    }
	

    func determineStartDirection() -> direction {
        let guardSymbol = map[guardPosition.0][guardPosition.1]
        switch guardSymbol {
        case "^":
            return direction.north
        case "<":
            return direction.west
        case ">":
            return direction.east
        case "v":
            return direction.south
        default:
            return direction.invalid
        }
    }

    func futureCoordinates() -> (Int, Int) {
        let (dy, dx) = guardFacing.coordinateChange

        let nextY = guardPosition.0 + dy
        let nextX = guardPosition.1 + dx
        return (nextY, nextX)
    }

    mutating func move() {
        let (y, x) = futureCoordinates()
        guardPosition = (y, x)
    }

	func nextMoveOutBounds(map: [[Character]]) -> Bool {
        let (y, x) = futureCoordinates()
        return (x < 0 || x > map.count - 1) || (y < 0 || y > map.count - 1)
    }

    func nextMoveClear(map: [[Character]]) -> Bool {
        let (y, x) = futureCoordinates()
        return !(map[y][x] == "#")
    }

    func findGuardPosition(map: [[Character]]) -> (Int, Int) {
        let guardSymbol: [Character] = ["v", "<", "^", ">"]
        for i in 0 ..< map.count {
            for j in 0 ..< map[i].count {
                if guardSymbol.contains(map[i][j]) {
                    return (i, j)
                }
            }
        }
        return (0, 0)
    }
}

var puzzle = Puzzle(map: grid)
puzzle.solvePart1()
puzzle.solvePart2()
