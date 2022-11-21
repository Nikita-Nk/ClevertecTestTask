import UIKit

final class CargoPassengerCar: Car {
    
    // MARK: - Public properties
    
    public let cargoCapacity: CargoCapacity
    public let passengerCapacity: Int
    
    public var availableSeats: Int {
        passengerCapacity - (order?.numberOfPassengers ?? 0)
    }
    
    public var availableCargoWeight: Double {
        cargoCapacity.payloadCapacity - (order?.cargo.weight ?? 0)
    }
    
    public var availableCargoVolume: Double {
        cargoCapacity.maxVolume - (order?.cargo.volume ?? 0)
    }
    
    // MARK: - Private properties
    
    private var isInteriorCleaned: Bool
    private var isInteriorDisinfected: Bool
    private var order: CargoPassengerOrder?
    
    // MARK: - Init
    
    init(information: Car.BasicInformation, powertrain: Car.Powertrain, bodyType: Car.BodyType, cargoCapacity: CargoCapacity, passengerCapacity: Int) {
        self.passengerCapacity = passengerCapacity
        self.cargoCapacity = cargoCapacity
        isInteriorCleaned = true
        isInteriorDisinfected = true
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
        cleanAndDisinfectTheInterior()
        super.prepareVehicleForTheRide()
    }
    
    override func load(newOrder: OrderRouteProtocol) {
        super.load(newOrder: newOrder)
        if let order = newOrder as? CargoPassengerOrder {
            self.order = order
            self.isInteriorCleaned = false
            self.isInteriorDisinfected = false
        }
    }
    
    override func unloadOrder() -> OrderRouteProtocol? {
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

private extension CargoPassengerCar {
    
    func cleanAndDisinfectTheInterior() {
        isInteriorCleaned = true
        isInteriorDisinfected = true
    }
}
