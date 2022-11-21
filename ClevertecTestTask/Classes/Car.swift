import UIKit

class Car {
    
    // MARK: - Public properties
    
    private (set) var isAvailable: Bool
    private (set) var isReadyForTheRide: Bool
    private (set) var currentPosition: Int = 0
    
    // MARK: - Private properties
    
    private var isRepairNeeded: Bool
    private var isVehicleDirty: Bool
    private var remainingFuel: Double
    
    private let information: BasicInformation
    private let powertrain: Powertrain
    public let bodyType: BodyType
    
    // MARK: - Init
    
    init(information: BasicInformation, powertrain: Powertrain, bodyType: BodyType) {
        isAvailable = true
        isReadyForTheRide = true
        isRepairNeeded = false
        isVehicleDirty = false
        remainingFuel = information.fuelTankCapacity
        self.information = information
        self.powertrain = powertrain
        self.bodyType = bodyType
    }
    
    // MARK: - Public
    
    public func startOrderExecution(_ order: OrderRouteProtocol) {
        print("Заказ принят. \(order.description)")
    }
    
    public func prepareVehicleForTheRide() {
        if !isRepairNeeded && !isVehicleDirty && remainingFuel >= information.fuelTankCapacity * 0.9 {
            isReadyForTheRide = true
            print("\(information.make) \(information.model) подготовлен к поездке")
            return
        }
        defer {
            isReadyForTheRide = true
            print("\(information.make) \(information.model) готов к поездке")
        }
        repair()
        refuel()
        washTheVehicle()
    }
    
    public func load(newOrder: OrderRouteProtocol) {
        print("Загружаемся")
    }
    
    public func unloadOrder() -> OrderRouteProtocol? {
        print("Выгружаемся")
        return nil
    }
    
    public func move(from: Int, to: Int, arrived: @escaping (Bool) -> Void) {
        let timeForRoad = abs((TimeInterval(from) - TimeInterval(to))/35)
        print("Выезжаем. Будем на месте через \(timeForRoad) секунд")
        DispatchQueue.main.asyncAfter(deadline: .now() + timeForRoad) {
            self.currentPosition = to
            self.remainingFuel -= self.powertrain.fuelConsumption * abs(Double(from) - Double(to))/100
            if to == 0 {
                print("\(self.information.make) \(self.information.model) прибыл в автопарк и доступен для следующего заказа")
            } else {
                print("\(self.information.make) \(self.information.model) прибыл к месту назначения")
            }
            self.refuel()
            arrived(true)
        }
    }
    
    public func returnToTheCarFleet() {
        move(from: currentPosition, to: 0) { didArriveToCarFleet in
            self.isAvailable = didArriveToCarFleet
        }
    }
    
    public func showCurrenOrder() -> OrderRouteProtocol? {
        return nil
    }
}

// MARK: - Private

private extension Car {
    
    func repair() {
        isRepairNeeded = false
        print("Ремонтируем")
    }
    
    func refuel() {
        print("Остаток топлива: \(remainingFuel)л")
        remainingFuel += information.fuelTankCapacity - remainingFuel
        print("Заправляемся. В баке: \(remainingFuel)л")
    }
    
    func washTheVehicle() {
        isVehicleDirty = false
        print("Моем")
    }
}

// MARK: - Nested Types

extension Car {
    
    enum BodyType {
        case bus, passengerVan, refrigeratedTruck, tankerTruck, flatbedTruck, dryVan, cargoPassengerVan
    }
    
    struct BasicInformation {
        let make: String
        let model: String
        let year: Int
        let fuelTankCapacity: Double
    }
    
    struct Powertrain {
        let engine: String
        let fuelType: FuelType
        let transmission: Transmission
        let drivetrain: Drivetrain
        let fuelConsumption: Double
    }
}

extension Car.Powertrain {
    enum FuelType {
        case diesel, bioDiesel, gasoline
    }
    
    enum Transmission {
        case automatic, manual, automatedManual, continuouslyVariable
    }
    
    enum Drivetrain {
        case rearWheelDrive, frontWheelDrive, allWheelDrive
    }
}
