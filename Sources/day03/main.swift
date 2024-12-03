//
//  main.swift
//  day01
//
//  Created by Awadhy Mohammed on 03/12/2024.
//

/* Understanding the problem
 Each line may have insutrctions that signal multiplication. These will be in the format 'mul(a,b)'. There may be similar looking instructions but these are broken and should be discounted.

 Example - xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))

 Has 4 valid instructions

 Breaking problem down into smaller steps:
 1. Read each line and store in memory
 2. Capture first occurence of valid pattern for mul(a,b)
 3. Execute the instruction
 4. Add to sum
 5. Repeat 2,3,4 until done
 */

import Foundation
import RegexBuilder

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

struct Puzzle {
	var input: [String]
	let regPattern = "don't|do|mul\\((\\d+),\\s*(\\d+)\\)"
	
	func executeMulInstruction(mul: String) -> Int {
		let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
		let matches = regex.matches(in: mul, options: [], range: NSRange(location: 0, length: mul.utf16.count))
		
		let numbers = matches.map {
			Int(mul[Range($0.range, in: mul)!])
		}
		
		return numbers[0]! * numbers[1]!
	}
	
	func getMatchingPattern(line: String) -> [NSTextCheckingResult]? {
		if let regex = try? NSRegularExpression(pattern: regPattern, options: []) {
			let range = NSRange(location: 0, length: line.utf16.count)
			let matches = regex.matches(in: line, range: range)
			return matches
		}
		return nil
	}
	
	func solvePart1() {
		var sum = 0
		for line in input {
			let matches = getMatchingPattern(line: line)!
			for match in matches {
				let matchFound = (line as NSString).substring(with: match.range)
				if matchFound != "do", matchFound != "don't" {
					sum += executeMulInstruction(mul: matchFound)
				}
			}
		}
		print(sum)
	}
	
	func solvePart2() {
		var sum = 0
		var enable = true
		for line in input {
			let matches = getMatchingPattern(line: line)!
			for match in matches {
				let matchFound = (line as NSString).substring(with: match.range)
				switch matchFound {
				case "don't":
					enable = false
				case "do":
					enable = true
				default:
					if enable {
						sum += executeMulInstruction(mul: matchFound)
					}
				}
			}
		}
		print(sum)
	}
}

var puzzle = Puzzle(input: text)
puzzle.solvePart1()
puzzle.solvePart2()
