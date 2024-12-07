//
//  main.swift
//  day07
//
//  Created by Awadhy Mohammed on 07/12/2024.
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
text.removeLast()

struct Puzzle {
    let input: [String]

    func solve() {
        var sum = 0
        for line in input {
            let targetNum = getTargetNumber(equation: line)
            let arr = getOperands(equation: line)
            let combinations = generateOperatorCombinations(numOfOperands: arr.count)
            for combination in combinations {
                let eval = evaluateEquation(combination: combination, operands: arr)
                if eval == targetNum {
                    sum += targetNum
                    break
                }
            }
        }
        print(sum)
    }

    func getTargetNumber(equation: String) -> Int {
        if let target = equation.firstIndex(of: ":") {
            let targetNum = equation.prefix(upTo: target)
            return Int(targetNum)!
        }
        return 0
    }

    func getOperands(equation: String) -> [Int] {
        if let start = equation.firstIndex(of: " ") {
            let desiredIndex = equation.index(after: start)
            let arr = equation.suffix(from: desiredIndex).components(separatedBy: " ")
            return arr.map { Int($0)! }
        }
        return []
    }

    func evaluateEquation(combination: [String], operands: [Int]) -> Int {
        var OperandIndex2 = 1
        var res = operands[operands.startIndex]
        for op in combination {
            if op == "+" {
                res += operands[OperandIndex2]
            } else if op == "*" {
                res *= operands[OperandIndex2]
            } else {
                res = Int("\(res)\(operands[OperandIndex2])")! // TODO: - Improve by using more efficient function
            }
            OperandIndex2 += 1 // Can improve by using index and offset
        }
        return res
    }

    func generateOperatorCombinations(numOfOperands: Int) -> [[String]] {
        if numOfOperands < 1 {
            return []
        }
        let operators = ["+", "*", "||"]

        var combinations: [[String]] = []

        func generateCombination(current: [String], size: Int) {
            if size == numOfOperands - 1 {
                combinations.append(current)
                return
            }

            // Add operators recursively
            for op in operators {
                generateCombination(current: current + [op], size: size + 1)
            }
        }

        generateCombination(current: [], size: 0)
        return combinations
    }
}

let puzzle = Puzzle(input: text)
puzzle.solve()
