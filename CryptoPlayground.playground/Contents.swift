/**
 * Nesta aplicação foi implementado o algoritmo que decifra um texto criptografado utilizando a Cifra de Vigenère.
 * Utilizando o Índice de Coincidência e o Chi-squared Statistic para encontrar o tamanho da chave e para encontrar a chave utilizada.
 * Data: 2019/2
 * Autores: Homero e Juliana
 */

import UIKit

let cipherText = readFile(fileName: "20192-teste1", onlyLetters: true)

let frequenciesString = readFile(fileName: "english-frequencies")
let (indexOfCoindence, alphabetFrequencies) = parseFrequencies(frequenciesString: frequenciesString)

let keyLengths = calculateKeyLengths(cipherText: cipherText, indexOfCoincidence: indexOfCoindence)
let keyLength = keyLengths.first!
print("*****Achado a chave com tamanho \(keyLength.length)*****")

let key = findKey(from: cipherText, using: keyLength, alphabetFrequencies: alphabetFrequencies)
print("*****Chave \(key)*****")

print(decrypt(encryptedText: cipherText, usingKey: key))

