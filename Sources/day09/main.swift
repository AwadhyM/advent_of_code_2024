//
//  main.swift
//  day09
//
//  Created by Awadhy Mohammed on 09/12/2024.
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

let inputFile = try String(contentsOfFile: inputFileRelativePath, encoding:.utf8)
var text = Array(inputFile)
text.removeLast()


struct Puzzle {
	let diskMap : [Character] // given format of File Organisation (puzzle input)
	var blockFormat : [Int] = [] // File format represented using File ID's (and - 1 for empty space)
	var locationOfBlanks : [(Int)] = [] // Location of blanks denoted by (index)
	var fileIdsWithCounts : [(Int, Int)] = []
	var blanksWithCounts: [Int : [Int]] = [:]
	
	init(diskMap: [Character]) {
		self.diskMap = diskMap
		self.blockFormat = representUsingId()
		self.locationOfBlanks = setLocationBlanks()
		self.fileIdsWithCounts = listOfFileIds()
		self.blanksWithCounts = countOfBlanks()
	}
	
	func solvePart1() {
		let fileMap = rearrangeBlockFormat()
		print(calculateCheckSum(fileMap: fileMap))
	}
	
	private mutating func representUsingId() -> [Int] {
		var blockFormat: [Int] = []
		var fileId = 0
		
		for (idx, disk) in self.diskMap.enumerated() {
			let size = Int(String(disk))!
			
			if idx.isMultiple(of: 2) {
				blockFormat.append(contentsOf: Array(repeating: fileId, count: size))
				fileId += 1
			} else {
				blockFormat.append(contentsOf: Array(repeating: -1, count: size))
			}
		}
		return blockFormat
	}
	
	private mutating func setLocationBlanks() -> [(Int)] {
		var locationOfBlanks : [(Int)] = []
		
		for (idx, disk) in self.blockFormat.enumerated() {
			if disk == -1 {
				locationOfBlanks.append(idx)
			}
		}
		return locationOfBlanks
	}
	
	private func rearrangeBlockFormat() -> [Int] {
		var blockFormatCpy = self.blockFormat
		
		for i in self.locationOfBlanks {
			
			while blockFormatCpy.last! == -1 {
				blockFormatCpy.removeLast()
			}
			
			if blockFormatCpy.count <= i {
				break
			}
			
			blockFormatCpy[i] = blockFormatCpy.last!
			blockFormatCpy.removeLast()
			
		}
		return blockFormatCpy
	}
	
	private func calculateCheckSum(fileMap: [Int]) -> Int {
		return fileMap.enumerated().reduce(0) {(sum, pair) in sum + pair.element * pair.offset}
	}
	

	private func listOfFileIds() -> [(Int, Int)] {
		var fileIds: [(Int, Int)] = []

		var i = 0
		while i < self.blockFormat.count {
			let fileId = self.blockFormat[i]
			
			if fileId == -1 {
				i += 1
			} else {
				var count = 0
				while (i + count < self.blockFormat.count && self.blockFormat[i + count] == fileId) {
					count += 1
				}
				fileIds.append((fileId, count))
				i += count
			}
		}
		print(fileIds)
		return fileIds
	}
	
	private func countOfBlanks() -> [Int: [Int]] {
		var countOfBlanks: [Int: [Int]] = [:]
		
		var i = 0
		while i < self.locationOfBlanks.count {
			let blank = self.locationOfBlanks[i]
			var count = 1
			var j = 1
			while (i + j < self.locationOfBlanks.count && self.locationOfBlanks[i + j] - self.locationOfBlanks[i + j - 1] == 1) {
				countOfBlanks[count, default: []].append(blank)
				count += 1
				j += 1
			}
			countOfBlanks[count, default: []].append(blank)
			i += 1
			}
		return countOfBlanks
	}
	
	private func rearrangeBlocks() -> [Int] {
		var blockFormatCpy = self.blockFormat
		
		for i in stride(from: blockFormat.count - 1, to: -1, by: -1) {
			
			while blockFormatCpy[i] == -1 {
				continue
			}
			
			let fileId = blockFormatCpy[i]
			let size = self.fileIdsWithCounts[fileId]
			
			if let blank = self.blanksWithCounts[size.1] {
				
			}
		}
		
		return blockFormatCpy
	}
	
	func solvePart2() {
		print(self.countOfBlanks())
		self.rearrangeBlocks()
	}
}

// Array converts it from ArraySlice to Array
var puzzle = Puzzle(diskMap: Array(text))
puzzle.solvePart1()
puzzle.solvePart2()

/* Pseudocode for part 2:
	1. Dictionary containing size of blank mapped to starting indexes of those blanks
 
	2. Walk through blockFormat from right to left
 
		while blockFormat[i] == -1 {
			blockFormat.removeLast()
		}
 
		let fileId = blockFormat[i]
		var count = 1
		var j = i
		while (blockFormat[i - j] == fileId) {
			count += 1
			j += 1
		}
 
		print(blockFormat[i] shows up count number of times!)
 
 */
