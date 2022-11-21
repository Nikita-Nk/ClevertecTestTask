import Foundation

struct PassengerOrder: OrderRouteProtocol, PassengerOrderProtocol {
    var description: String
    var route: Route
    var numberOfPassengers: Int
}
