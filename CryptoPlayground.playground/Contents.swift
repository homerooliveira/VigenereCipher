import UIKit

let cipherText = readFile(fileName: "20192-teste1", onlyLetters: true)

let frequenciesString = readFile(fileName: "english-frequencies")
let (indexOfCoindence, alphabetFrequencies) = parseFrequencies(frequenciesString: frequenciesString)

let keyLengths = calculateKeyLengths(cipherText: cipherText, indexOfCoincidence: indexOfCoindence)

let keyLength = keyLengths.first!
print("*****Achado a chave com tamanho \(keyLength.length)*****")

let groups = groupCharacters(for: keyLength.length, with: cipherText)
let key = findKey(groups: groups, alphabetFrequencies: alphabetFrequencies)

print("*****Chave \(key)*****")

print(decrypt(encryptedText: cipherText, usingKey: key))
