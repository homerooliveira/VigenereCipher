//  Created by Homero and Juliana

import Foundation

public extension Collection where Element: Numeric {
    /// Retorna total da soma dos elementos
    var total: Element { return reduce(0, +) }
}

public extension Collection where Element: BinaryFloatingPoint {
    /// Retorna o média dos elementos
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
