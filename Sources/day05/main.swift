//
//  main.swift
//  day05
//
//  Created by Awadhy Mohammed on 05/12/2024.
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

struct Puzzle {
    var input: [String]
    var orderingRules: [Int: [Int]] = [:]
    var pageUpdates: [String] = []

    init(input: [String]) {
        self.input = input
        generateOrderRules()
        generatePageUpdates()
    }

    private mutating func generateOrderRules() {
        var orderingRules: [Int: [Int]] = [:]
        for line in input {
            if line.isEmpty {
                break
            }
            let components = line.split(separator: "|")
            if let firstNumber = Int(components[0]), let secondNumber = Int(components[1]) {
                orderingRules[firstNumber, default: []].append(secondNumber)
            } else {
                print("Invalid input")
            }
        }
        self.orderingRules = orderingRules
    }

    private mutating func generatePageUpdates() {
        if let index = input.firstIndex(of: "") {
            let slicedArray = input.suffix(from: input.index(after: index))
            pageUpdates = Array(slicedArray)
        } else {
            print("Empty string not found")
        }
    }

    private func validatePageOrder(update: [String]) -> Bool {
        if update == [""] {
            return false
        }
        for (index, number) in update.enumerated() {
            if let pageInspect = orderingRules[Int(number)!] {
                let slicedArray = Array(update[0 ..< index])
                if !slicedArray.isEmpty {
                    for val in pageInspect {
                        if slicedArray.contains(String(val)) {
                            return false
                        }
                    }
                }
            }
        }
        return true
    }

    private func fixPageOrder(update: [String]) -> [String] {
        var numCpy = update
        for (index, number) in numCpy.enumerated() {
            if let pageInspect = orderingRules[Int(number)!] {
                let slicedArray = Array(numCpy[0 ..< index])
                if !slicedArray.isEmpty {
                    var indexes: [Int] = []
                    for (_, val) in pageInspect.enumerated() {
                        if slicedArray.contains(String(val)) {
                            let desIndex = slicedArray.firstIndex(of: String(val))
                            indexes.append(desIndex!)
                        }
                    }
                    if let first = indexes.min() {
                        numCpy.swapAt(first, index)
                    }
                }
            }
        }
        return numCpy
    }

    private func findMiddle(update: [String]) -> String {
        let midIndex = update.count / 2
        return update[midIndex]
    }

    func solvePart1() {
        var sum = 0
        for update in pageUpdates {
            if update.isEmpty {
                continue
            }
            let numbers = update.components(separatedBy: ",")
            if validatePageOrder(update: numbers) {
                sum += Int(findMiddle(update: numbers))!
            }
        }
        print(sum)
    }

    func solvePart2() {
        var sum = 0
        for update in pageUpdates {
            if update.isEmpty {
                continue
            }
            var numbers = update.components(separatedBy: ",")
            if !validatePageOrder(update: numbers) {
                numbers = fixPageOrder(update: numbers)
                while validatePageOrder(update: numbers) == false {
                    numbers = fixPageOrder(update: numbers)
                }
                let midIndex = numbers.count / 2
                if let midNum = Int(numbers[midIndex]) {
                    sum += midNum
                }
            }
        }
        print(sum)
    }
}

var puzzle = Puzzle(input: text)
puzzle.solvePart1()
puzzle.solvePart2()
