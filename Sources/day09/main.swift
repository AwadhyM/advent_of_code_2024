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

let reorgFiles = swapFileIDWithEmptySpace(fileMap: fileMap)
print(calculateCheckSum(fileMapArr: reorgFiles))
