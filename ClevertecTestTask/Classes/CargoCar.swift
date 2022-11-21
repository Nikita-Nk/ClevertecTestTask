import UIKit

final class CargoCar: Car {
    
    // MARK: - Public properties
    
    public let cargoCapacity: CargoCapacity
    
    public var availableCargoWeight: Double {
        cargoCapacity.payloadCapacity - (order?.cargo.weight ?? 0)
    }
    
    public var availableCargoVolume: Double {
        cargoCapacity.maxVolume - (order?.cargo.volume ?? 0)
    }
    
    // MARK: - Private properties
    
    private var isBodySealed: Bool
    private var order: CargoOrder?
    
    // MARK: - Init
    
    init(information: Car.BasicInformation, powertrain: Car.Powertrain, bodyType: Car.BodyType, cargoCapacity: CargoCapacity) {
        self.cargoCapacity = cargoCapacity
        isBodySealed = false
        super.init(information: information, powertrain: powertrain, bodyType: bodyType)
    }
    
    // MARK: - Public
    
    override func startOrderExecution(_ order: OrderRouteProtocol) {
        super.startOrderExecution(order)
        prepareVehicleForTheRide()
        load(newOrder: order)
        move(from: order.route.startPoint,
             to: order.route.endPoint) { arrived in
            if arrived {
                let _ = self.unloadOrder()
                self.returnToTheCarFleet()
            }
        }
    }
    
    override func prepareVehicleForTheRide() {
        sealTheBody()
        super.prepareVehicleForTheRide()
    }
    
    override func load(newOrder: OrderRouteProtocol) {
        super.load(newOrder: newOrder)
        if let order = newOrder as? CargoOrder {
            self.order = order
            self.isBodySealed = true
        }
    }
    
    override func unloadOrder() -> OrderRouteProtocol? {
        isBodySealed = false
        let _ = super.unloadOrder()
        let unloadedOrder = order
        order = nil
        if let unloadedOrder = unloadedOrder {
            return unloadedOrder
        } else {
            return nil
        }
    }
    
    override func showCurrenOrder() -> OrderRouteProtocol? {
        print(order as Any)
        return order
    }
}

// MARK: - Private

private extension CargoCar {
    
    func sealTheBody() {
        isBodySealed = true
    }
}
