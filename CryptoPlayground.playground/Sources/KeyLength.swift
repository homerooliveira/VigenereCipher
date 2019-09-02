import Foundation

public func calculateKeyLengths(cipherText: String) -> [[(Int, Double)]] {
    let alphabetLength = 26
    let portugueseIC = 0.072723
    var lengths: [[(length: Int, index: Double)]] = []
    
    
    for length in 0..<alphabetLength {
        lengths.append(keyLengths(for: length + 1, with: cipherText))
    }
    
    lengths.sort(by: { (lhs, rhs) in
        portugueseIC - lhs.first!.index < portugueseIC - rhs.first!.index
    })
    
    return lengths
}

public func keyLengths(for length: Int, with cipherText: String) -> [(Int, Double)] {
    var lengthsGroup: [[Character]] = Array(repeating: [], count: length)
    
    for (index, character) in cipherText.enumerated() {
        lengthsGroup[index % length].append(character)
    }
    
    return lengthsGroup.map { (characters) in
        let occurrences = countOccurrence(of: characters)
        let indexOfOccurrence = calculateIndeOfCoincidence(of: occurrences)
        return (length, indexOfOccurrence)
    }
}

public func countOccurrence(of characters: [Character]) -> [Character: Int] {
    var occurrenceByCharacter: [Character: Int] = [:]
    
    for character in characters {
        occurrenceByCharacter[character, default: 0] += 1
    }
    
    return occurrenceByCharacter
}

public func calculateIndeOfCoincidence(of occurrences: [Character: Int]) -> Double {
    let (k, n) = occurrences.reduce((0.0, 0.0)) { (result, tuple) in
        let occurrenceOfChar = Double(tuple.1)
        let k = result.0 + (occurrenceOfChar * (occurrenceOfChar - 1))
        let n = result.1 + occurrenceOfChar
        return (k: k, n: n)
    }
    
    guard n > 0 else { return 0 }
    
    return k / (n * (n - 1))
}
