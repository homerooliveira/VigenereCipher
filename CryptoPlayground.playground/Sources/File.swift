import Foundation

public func readFile(fileName: String, onlyLetters: Bool = false) -> String {
    let url = Bundle.main.url(forResource: fileName, withExtension: "txt")!
    
    if onlyLetters {
        return try! String(contentsOf: url, encoding: .utf8).filter { $0.isLetter }
    } else {
        return try! String(contentsOf: url, encoding: .utf8)
    }
}

public func parseFrequencies(frequenciesString: String) -> (Double, [Character: Double]) {
    let lines = frequenciesString.split(separator: "\n")
    
    let indexOfCoincidence = lines.first.flatMap { Double($0) } ?? 0
    
    let keyValues = lines.dropFirst()
        .map { line -> (Character, Double) in
            let values = line.split(separator: ";")
            let character = values.first?.first
            let frequencie = Double(values.last!)
            
            return (character!, frequencie!)
    }
    
    return (indexOfCoincidence, Dictionary(uniqueKeysWithValues: keyValues))
}
