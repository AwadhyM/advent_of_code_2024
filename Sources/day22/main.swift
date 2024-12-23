//
//  main.swift
//  day22
//
//  Created by Awadhy Mohammed on 23/12/2024.
//

import Foundation

/*
 	Understanding part 2:
  The prices that the buyers offer are not the actual secret numbers but rather are
  the final digits of a secret number.

  We tell a monkey to negotiate prices for us. But that monkey only looks for a specific sequence of 4
  consecutive changes in price before offering to buy.

  123: 3
 15887950: 0 (-3)
 16495136: 6 (6)
 527345: 5 (-1)
 704524: 4 (-1)

 Monkey here will offer to buy 4
  */

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
var text: [Int] = file.components(separatedBy: "\n").map { Int($0) ?? 0 }
text.removeLast()

struct Puzzle {
    // Todo consider if this is necessary
    static func mixNumbers(n1: Int, n2: Int) -> Int {
        return n1 ^ n2
    }

    static func pruneSecretNumber(secretNum: Int) -> Int {
        return secretNum % 16_777_216
    }

    static func generateSecretNumber(secretNum: Int) -> Int {
        var secretNumCpy = secretNum

        // multiply the secret number by 64
        let numToMixFirst = secretNum * 64

        // Mix this number to form the new temp secretNum
        secretNumCpy = mixNumbers(n1: numToMixFirst, n2: secretNumCpy)

        // Prune the secretNum
        secretNumCpy = pruneSecretNumber(secretNum: secretNumCpy)

        // Divide secret Num by 32
        let numToMixSecond = secretNumCpy / 32

        // Mix
        secretNumCpy = mixNumbers(n1: numToMixSecond, n2: secretNumCpy)

        // Prune
        secretNumCpy = pruneSecretNumber(secretNum: secretNumCpy)

        // Multply by 2048
        let numToMixThird = secretNumCpy * 2048

        // Mix
        secretNumCpy = mixNumbers(n1: numToMixThird, n2: secretNumCpy)

        // Prune
        return pruneSecretNumber(secretNum: secretNumCpy)
    }

    let initialSecretNumbers: [Int]
    var finalSecretNumbers: [Int] = []

    init(_ initialSecretNums: [Int]) {
        initialSecretNumbers = initialSecretNums
    }

    mutating func solvePart1() -> Int {
        // Get ten secret number
        for secretNum in initialSecretNumbers {
            var initial = secretNum
            for _ in 0 ..< 2000 {
                initial = Puzzle.generateSecretNumber(secretNum: initial)
            }
            finalSecretNumbers.append(initial)
        }
        return finalSecretNumbers.reduce(0, +)
    }
}

var puzzle = Puzzle(text)
print(puzzle.solvePart1())
