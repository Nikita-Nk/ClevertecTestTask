import Foundation

enum OrderType {
    case cargo(model: CargoOrder)
    case passenger(model: PassengerOrder)
    case cargoPassenger(model: CargoPassengerOrder)
}
