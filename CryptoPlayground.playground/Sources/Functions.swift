import Foundation

public func calculateKeyLengths(cipherText: String, indexOfCoincidence: Double) -> [KeyLength] {
    let alphabetLength = 13
    var lengths: [KeyLength] = []
    
    for length in 0..<alphabetLength {
        lengths.append(keyLengths(for: length + 1, with: cipherText))
    }
    
    lengths.sort(by: { (lhs, rhs) in
        indexOfCoincidence - lhs.indicesOfCoincidence.average
            < indexOfCoincidence - rhs.indicesOfCoincidence.average
    })
    
    return lengths
}

public func keyLengths(for length: Int, with cipherText: String) -> KeyLength {
    let lengthsGroup: [[Character]] = groupCharacters(for: length, with: cipherText)
    
    let indicesOfCoincidence = lengthsGroup.map { (characters) -> Double in
        let occurrences = countOccurrence(of: characters)
        let indexOfCoincidence = calculateIndexOfCoincidence(of: occurrences)
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

public func calculateIndexOfCoincidence(of occurrences: [Character: Int]) -> Double {
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

public func prev(character: Character) -> Character {
    let index = ((Int(character.asciiValue!) - 97) + 25) % alphabet.count
    return alphabet[index]
}

public let alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

func chiSquare(for characters: [Character], alphabetFrequencies: [Character: Double]) -> Double {
    let charactersFreq = countOccurrence(of: characters)
    let count = charactersFreq.values.reduce(0, +)
    
    let score = alphabet.reduce(0.0) { (result, character)  in
        let alphabetFrequencie = alphabetFrequencies[character]!
        let freqExpected = alphabetFrequencie * Double(count)
        let freqActual = Double(charactersFreq[character, default: 0])
        return result + (pow((freqActual - freqExpected), 2) / freqExpected)
    }
    
    return score
}

public func findKey(groups: [[Character]], alphabetFrequencies: [Character: Double]) -> String {
    let indicesOfKey = groups.map { (characters) -> Int? in
        var characters = characters
        let chiSquareScore = alphabet.indices
            .map { (index) -> Double in
                let score = chiSquare(for: characters, alphabetFrequencies: alphabetFrequencies)
                characters = characters.map { prev(character: $0) }
                return score
        }
        let index = chiSquareScore.enumerated().min { $0.element < $1.element }
        return index?.offset
    }
    
    let characters = indicesOfKey.compactMap { index in index.map { alphabet[$0] } }
    return String(characters)
}

public func decrypt(encryptedText: String, usingKey key: String) -> String {
    var decryptedText = ""
    var index = 0
    let alphabetSize: Int = alphabet.count
    let keySize: Int = key.count

    
    for character in encryptedText {
        let indexInAlphabet = indexOfAlphabet(forCharacter: character)
        
        if indexInAlphabet == -1 {
            decryptedText.append(character)
            continue
        }
        
        let keyToEncryptWith = key[index % keySize]
        let keyIndexInAlphabet = indexOfAlphabet(forCharacter: keyToEncryptWith)
        let encryptedLetterIndex = (indexInAlphabet - keyIndexInAlphabet + alphabetSize) % alphabetSize
        decryptedText.append(alphabet[encryptedLetterIndex])
        index += 1
    }
    
    return decryptedText
}

private func indexOfAlphabet(forCharacter character: Character) -> Int {
    var index = 0
    
    for chr in alphabet {
        if chr == character {
            return index
        }
        index += 1
    }
    
    return -1
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
