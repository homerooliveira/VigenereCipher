import Foundation

public func calculateKeyLengths(cipherText: String) -> [KeyLength] {
    let alphabetLength = 26
    let portugueseIC = 0.072723
    var lengths: [KeyLength] = []
    
    
    for length in 0..<alphabetLength {
        lengths.append(keyLengths(for: length + 1, with: cipherText))
    }
    
    lengths.sort(by: { (lhs, rhs) in
        portugueseIC - lhs.indicesOfCoincidence.first!
            < portugueseIC - rhs.indicesOfCoincidence.first!
    })
    
    return lengths
}

public func keyLengths(for length: Int, with cipherText: String) -> KeyLength {
    let lengthsGroup: [[Character]] = groupCharacters(for: length, with: cipherText)
    
    let indicesOfCoincidence = lengthsGroup.map { (characters) -> Double in
        let occurrences = countOccurrence(of: characters)
        let indexOfCoincidence = calculateIndeOfCoincidence(of: occurrences)
        return indexOfCoincidence
    }
    
    return KeyLength(length: length, indicesOfCoincidence: indicesOfCoincidence)
}

public func countOccurrence(of characters: [Character]) -> [Character: Int] {
    var occurrenceByCharacter: [Character: Int] = [:]
    
    for character in characters {
        occurrenceByCharacter[character, default: 0] += 1
    }
    
    return occurrenceByCharacter
}

public func groupCharacters(for length: Int, with cipherText: String) -> [[Character]] {
    var lengthsGroup: [[Character]] = Array(repeating: [], count: length)
    
    for (index, character) in cipherText.enumerated() {
        lengthsGroup[index % length].append(character)
    }
    
    return lengthsGroup
}

public func groupCharacterByFrequencies(for length: Int, with cipherText: String) -> [[(Character, Int)]] {
    return groupCharacters(for: length, with: cipherText)
        .map({ (characters) in
            Array(countOccurrence(of: characters))
        })
}

public func calculateIndeOfCoincidence(of occurrences: [Character: Int]) -> Double {
    var k: Double = 0.0
    var n: Double = 0.0
    
    for (_, occurrence) in occurrences {
        let occurrenceAsDouble = Double(occurrence)
        k += (occurrenceAsDouble * (occurrenceAsDouble - 1))
        n += occurrenceAsDouble
    }
    
    guard n > 0 else { return 0 }
    
    return k / (n * (n - 1))
}

public func next(character: Character, add: Int) -> Character {
    let index = ((Int(character.asciiValue!) - 97) + add) % alphabet.count
    return alphabet[index]
}

public let alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

public func keyIndices(groups: [[(Character, Int)]],
                       alphabetFrequencies: [Character: Double]) -> [Int?] {
    let indicesOfKey = groups.map { (characters) -> Int? in
        let chiSquare = alphabet.indices
            .map { (index) -> Double in
                let characters = characters.map { (next(character: $0.0, add: index), $0.1) }
                let score = characters.reduce(0.0) { (result, args)  in
                    let (character, freq) = args
                    guard let alphabetFrequencie = alphabetFrequencies[character] else {
                        print(character)
                        return 0
                    }
                    let freqExpected = alphabetFrequencie * Double(characters.count)
                    let freqActual = Double(freq)
                    return result + (pow((freqActual - freqExpected), 2) / freqExpected)
                }
                
                return score
        }
        chiSquare.enumerated().forEach({ (index, score) in
            print("index=\(index) score=\(score)")
        })
        print()
        let index = chiSquare.enumerated().min { $0.element < $1.element }?.offset
        return index
    }
    
    return indicesOfKey
}


