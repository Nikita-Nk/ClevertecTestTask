import UIKit

final class CarFleet {
    
    // MARK: - Private properties
    
    private var timer: Timer?
    
    private var ordersProvider: OrdersProvidingProtocol
    
    private var cargoCars = [CargoCar]()
    private var passengerCars = [PassengerCar]()
    private var cargoPassengerCars = [CargoPassengerCar]()
    
    private var cargoOrders = [CargoOrder]()
    private var passengerOrders = [PassengerOrder]()
    private var cargoPassengerOrders = [CargoPassengerOrder]()
    
    private let supportedCargo: [Car.BodyType: [Cargo.CargoType]] = [.dryVan: [.manufacturedGoods],
                                                              .refrigeratedTruck: [.consumerProducts, .manufacturedGoods],
                                                              .tankerTruck: [.liquidBulkCargo],
                                                              .cargoPassengerVan: [.manufacturedGoods],
                                                              .bus: [],
                                                              .flatbedTruck: []]
    
    // MARK: - Init
    
    init(ordersProvider: OrdersProvidingProtocol, cargoCars: [CargoCar], passengerCars: [PassengerCar], cargoPassengerCars: [CargoPassengerCar]) {
        self.ordersProvider = ordersProvider
        self.cargoCars = cargoCars
        self.passengerCars = passengerCars
        self.cargoPassengerCars = cargoPassengerCars
    }
    
    // MARK: - Public
    
    public func getStarted() {
        timer = Timer.scheduledTimer(timeInterval: 6,
                                     target: self,
                                     selector: #selector(findVehiclesForTheOrders),
                                     userInfo: nil,
                                     repeats: true)
        
        fetchNewOrders()
        findVehiclesForTheOrders()
    }
    
    public func fetchNewOrders() {
        let newOrders = ordersProvider.fetchNewOrders()
        sortNewOrders(newOrders)
    }
    
    @objc public func findVehiclesForTheOrders() {
        print("Ищем подходящие авто для выполнения заказов")
        findVehiclesForCargoOrders()
        findVehiclesForPassengerOrders()
        findVehiclesForCargoPassengerOrders()
    }
}

// MARK: - Private

private extension CarFleet {
    
    func checkIfBodyTypeSuit(cargoType: Cargo.CargoType, bodyType: Car.BodyType) -> Bool {
        guard let cargoTypesForBody = supportedCargo[bodyType] else { return false }
        return cargoTypesForBody.contains(cargoType)
    }
    
    func sortNewOrders(_ orders: [OrderType]) {
        for order in orders {
            switch order {
            case .cargo(let model):
                cargoOrders.append(model)
            case .cargoPassenger(let model):
                cargoPassengerOrders.append(model)
            case .passenger(let model):
                passengerOrders.append(model)
            }
        }
    }
    
    func findVehiclesForCargoOrders() {
        guard !cargoOrders.isEmpty else { return }
        for (index, order) in cargoOrders.enumerated() {
            for car in cargoCars where car.isAvailable {
                guard checkIfBodyTypeSuit(cargoType: order.cargo.cargoType, bodyType: car.bodyType),
                      order.cargo.volume <= car.cargoCapacity.maxVolume,
                      order.cargo.weight <= car.cargoCapacity.payloadCapacity else { continue }
                car.startOrderExecution(order)
                cargoOrders.remove(at: index)
                return
            }
        }
    }
    
    func findVehiclesForPassengerOrders() {
        guard !passengerOrders.isEmpty else { return }
        for (index, order) in passengerOrders.enumerated() {
            for car in passengerCars where car.isAvailable {
                guard order.numberOfPassengers <= car.availableSeats else { continue }
                car.startOrderExecution(order)
                passengerOrders.remove(at: index)
                return
            }
        }
    }
    
    func findVehiclesForCargoPassengerOrders() {
        guard !cargoPassengerOrders.isEmpty else { return }
        for (index, order) in cargoPassengerOrders.enumerated() {
            for car in cargoPassengerCars where car.isAvailable {
                guard checkIfBodyTypeSuit(cargoType: order.cargo.cargoType, bodyType: car.bodyType),
                      order.cargo.volume <= car.cargoCapacity.maxVolume,
                      order.cargo.weight <= car.cargoCapacity.payloadCapacity,
                      order.numberOfPassengers <= car.availableSeats else { continue }
                car.startOrderExecution(order)
                cargoPassengerOrders.remove(at: index)
                return
            }
        }
    }
}
