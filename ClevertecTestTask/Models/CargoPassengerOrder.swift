import Foundation

protocol OrderRouteProtocol {
    var description: String { get }
    var route: Route { get }
}

protocol CargoOrderProtocol {
    var cargo: Cargo { get }
}

protocol PassengerOrderProtocol {
    var numberOfPassengers: Int { get }
}

struct CargoPassengerOrder: OrderRouteProtocol, CargoOrderProtocol, PassengerOrderProtocol {
    var description: String
    var route: Route
    var numberOfPassengers: Int
    var cargo: Cargo
}
