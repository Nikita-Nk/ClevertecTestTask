import Foundation

struct Cargo {
    let cargoType: CargoType
    let weight: Double
    let volume: Double
}

// MARK: - Nested Types

extension Cargo {
    enum CargoType {
        case manufacturedGoods
        case consumerProducts
        case liquidBulkCargo
        case dryBulkCargo
    }
}
