import UIKit

let url = Bundle.main.url(forResource: "cipher-text", withExtension: "txt")!
let cipherText = try! String(contentsOf: url, encoding: .utf8)

let urlFrequencies = Bundle.main.url(forResource: "portuguese-frequencies", withExtension: "txt")!
let frequenciesString = try! String(contentsOf: urlFrequencies, encoding: .utf8)
let keyValues = frequenciesString.split(separator: "\n")
    .map { line -> (Character, Double) in
        let values = line.split(separator: ";")
        let character = values.first?.first
        let frequencie = Double(values.last!)
        
        return (character!, frequencie!)
}
let alphabetFrequencies = Dictionary(uniqueKeysWithValues: keyValues)

let keyLengths = calculateKeyLengths(cipherText: cipherText)

let keyLength = keyLengths.first!

let groups = groupCharacterByFrequencies(for: keyLength.length, with: cipherText)

let indices = keyIndices(groups: groups, alphabetFrequencies: alphabetFrequencies)

print(indices)
