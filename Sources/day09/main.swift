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

let file = try String(contentsOfFile: inputFileRelativePath)
var text: [String] = file.components(separatedBy: "\n")

// print(text.first!)

func convertToFileMap(diskMap: String) -> [String] {
    var fileMap: [String] = []
    var id = 0
    for i in 0 ..< diskMap.count {
        let element = String(diskMap[diskMap.index(diskMap.startIndex, offsetBy: i)])
        let elementInt = Int(element) ?? 0
        var valStr = "."
        if i.isMultiple(of: 2) {
            valStr = String(id)
            id += 1
        } else {}
        for _ in 0 ..< elementInt {
            fileMap.append(valStr)
        }
    }
    return fileMap
}

// print(convertToFileMap(diskMap:"12345"))
let fileMap = convertToFileMap(diskMap: text.first!)
// print(fileMap)

struct Position {
    var start: Int
    var end: Int
}

func recordNumberOfConsecutiveEmptySpace(fileMap: [String], prev _: Int = 0) -> [Int: [Position]] {
    var emptySpaces: [Int: [Position]] = [:]
    let fileMapEnumerated = fileMap.enumerated().map { ($0, $1) }
    var count = 0
    var start = 0
    var end = 0
    for (idx, el) in fileMapEnumerated {
        // Start of sequence
        if el == ".", count == 0 {
            start = idx
            end = idx
            emptySpaces[count, default: []].append(Position(start: start, end: end))
            count += 1
            continue
        }

        // Continue sequence
        if el == ".", count > 0 {
            count += 1
            end = idx
            emptySpaces[count, default: []].append(Position(start: start, end: end))
            continue
        }

        // End of sequence
        if el != ".", count > 0 {
            end = idx - 1
            emptySpaces[count, default: []].append(Position(start: start, end: end))
            start = 0
            end = 0
            count = 0
        }
    }
    return emptySpaces
}

func recordNumberOfConsecutiveFileID(fileMap: [String]) -> [String: Int] {
    let noDots = fileMap.filter { $0 != "." }
    let countIds = noDots.map { ($0, 1) }
    let counts = Dictionary(countIds, uniquingKeysWith: +)
    return counts
}

let fileIdCounts = recordNumberOfConsecutiveFileID(fileMap: fileMap)
let emptySpace = recordNumberOfConsecutiveEmptySpace(fileMap: fileMap)

func swapFileIDWithEmptySpace(fileMap: [String]) -> [String] {
    var fileMapArr = fileMap
    var firstDot = getFirstOccurenceDot(fileMapArr: fileMapArr, prev: 0)
    var lastNum = getLastOccurenceNumber(fileMapArr: fileMapArr, prev: fileMap.count - 1)
    fileMapArr.swapAt(firstDot, lastNum)
    while firstDot < lastNum {
        fileMapArr.swapAt(firstDot, lastNum)
        firstDot = getFirstOccurenceDot(fileMapArr: fileMapArr, prev: firstDot)
        lastNum = getLastOccurenceNumber(fileMapArr: fileMapArr, prev: lastNum)
        // print(firstDot, lastNum)
    }
    return fileMapArr
}

func reorganiseFilePuzzle2(fileMap: [String], fileIds: [String: Int], prev: Int = 0) -> [String] {
    // Look through fileMap from left to right
    var fileMapArr = fileMap
    var arrangedIds: [String] = []
    var firstDot = getFirstOccurenceDot(fileMapArr: fileMapArr, prev: 0) // Keep track of first dot so we stop
    for i in stride(from: prev, to: -1, by: -1) {
        // If we have a dot
        if fileMapArr[i] == "." {
            continue
        }
        // If we find a number
        let countOfId = fileIds[fileMapArr[i]]
        let start = i - countOfId! + 1
        let end = i

        if arrangedIds.contains(fileMapArr[i]) {
            continue
        }
        firstDot = getFirstOccurenceDot(fileMapArr: fileMapArr, prev: firstDot)
        let emptySpaces = recordNumberOfConsecutiveEmptySpace(fileMap: fileMapArr, prev: firstDot)

        if let space = emptySpaces[countOfId!] {
            let pos = space[0]
            if i < pos.start {
                continue
            }
            for j in pos.start ... pos.end {
                fileMapArr[j] = fileMapArr[i]
            }
            for k in start ... end {
                fileMapArr[k] = "."
            }
            arrangedIds.append(fileMapArr[i])
        }
    }
    return fileMapArr
}

func getFirstOccurenceDot(fileMapArr: [String], prev: Int) -> Int {
    for i in prev ..< fileMapArr.count {
        if fileMapArr[i] == "." {
            return i
        }
    }
    return 0
}

func getLastOccurenceNumber(fileMapArr: [String], prev: Int) -> Int {
    for i in stride(from: prev, to: -1, by: -1) {
        if Int(fileMapArr[i]) != nil {
            return i
        }
    }
    return 0
}

func calculateCheckSum(fileMapArr: [String]) -> Int {
    let intArray = fileMapArr.map { Int($0) ?? 0 }
    let intToIndex = intArray.enumerated().map { ($0, $1) }
    return intToIndex.reduce(0) { accumuate, file in accumuate + (file.0 * file.1) }
}

let fileMapCount = fileMap.count
let part2 = reorganiseFilePuzzle2(fileMap: fileMap, fileIds: fileIdCounts, prev: fileMapCount - 1)
let reorgFiles = swapFileIDWithEmptySpace(fileMap: fileMap)
print(calculateCheckSum(fileMapArr: reorgFiles))
print(calculateCheckSum(fileMapArr: part2))
