import Foundation

struct CargoOrder: OrderRouteProtocol, CargoOrderProtocol {
    var description: String
    var route: Route
    var cargo: Cargo
}
