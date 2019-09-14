//  Created by Homero and Juliana

import Foundation

/// Representa o alfabeto.
private let alphabet: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

/// Retorna os tamanhos de chave a partir de um texto cifrado.
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

/// Procura a chave do texto cifrado.
public func findKey(from cipherText: String,
                    using key: KeyLength,
                    alphabetFrequencies: [Character: Double]) -> String {
    let groups = groupCharacters(for: key.length, with: cipherText)
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

/// Decripta o texto usando uma chave
public func decrypt(encryptedText: String, usingKey key: String) -> String {
    let alphabetSize: Int = alphabet.count
    let keySize: Int = key.count
    let keyCharacters = Array(key)
    
    let decryptedText = encryptedText.enumerated()
        .map { (index, character) -> Character in
            let indexInAlphabet = Int(character.asciiValue! - 97)
            let keyToEncryptWith = keyCharacters[index % keySize]
            let keyIndexInAlphabet = Int(keyToEncryptWith.asciiValue! - 97)
            let encryptedLetterIndex = (indexInAlphabet - keyIndexInAlphabet + alphabetSize) % alphabetSize
            return alphabet[encryptedLetterIndex]
    }
    
    return String(decryptedText)
}


// Calcula o tamanho da chave.
private func keyLengths(for length: Int, with cipherText: String) -> KeyLength {
    let lengthsGroup: [[Character]] = groupCharacters(for: length, with: cipherText)
    
    let indicesOfCoincidence = lengthsGroup.map { (characters) -> Double in
        let occurrences = countOccurrence(of: characters)
        let indexOfCoincidence = calculateIndexOfCoincidence(of: occurrences)
        return indexOfCoincidence
    }
    
    return KeyLength(length: length, indicesOfCoincidence: indicesOfCoincidence)
}

/// Conta as ocurencias dos caracteres.
private func countOccurrence(of characters: [Character]) -> [Character: Int] {
    var occurrenceByCharacter: [Character: Int] = [:]
    
    for character in characters {
        occurrenceByCharacter[character, default: 0] += 1
    }
    
    return occurrenceByCharacter
}

/// A groupa os caracteres por array.
private func groupCharacters(for length: Int, with cipherText: String) -> [[Character]] {
    var lengthsGroup: [[Character]] = Array(repeating: [], count: length)
    
    for (index, character) in cipherText.enumerated() {
        lengthsGroup[index % length].append(character)
    }
    
    return lengthsGroup
}

/// Calcula os indice de coincidencia do caracteres passados por parametro.
private func calculateIndexOfCoincidence(of occurrences: [Character: Int]) -> Double {
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

/// Retorna o caractere anterior. Exemplo: Se por passado `a` vai ser retornado `z`.
private func prev(character: Character) -> Character {
    let index = ((Int(character.asciiValue!) - 97) + 25) % alphabet.count
    return alphabet[index]
}

/// Calcula chi square do array de caracteres.
private func chiSquare(for characters: [Character], alphabetFrequencies: [Character: Double]) -> Double {
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
