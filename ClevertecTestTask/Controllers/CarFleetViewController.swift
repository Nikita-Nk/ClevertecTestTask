import UIKit

class CarFleetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startCarFleet()
    }
}

// MARK: - Private

private extension CarFleetViewController {
    
    func startCarFleet() {
        let ordersProvider: OrdersProvidingProtocol = OrdersProvider()

        let mbSprinter = PassengerCar(information: .init(make: "Mercedes-Benz",
                                                         model: "Sprinter Passenger Van 2500",
                                                         year: 2021,
                                                         fuelTankCapacity: 75),
                                      powertrain: .init(engine: "4-Cylinder Diesel Standard Output",
                                                        fuelType: .diesel,
                                                        transmission: .automatic,
                                                        drivetrain: .rearWheelDrive,
                                                        fuelConsumption: 11),
                                      bodyType: .passengerVan,
                                      passengerCapacity: 12)

        let mbSprinterRefrigerated = CargoCar(information: .init(make: "Mercedes-Benz",
                                                     model: "Cargo Van 3500XD",
                                                     year: 2023,
                                                     fuelTankCapacity: 75),
                                  powertrain: .init(engine: "4-Cylinder Diesel High Output AWD",
                                                    fuelType: .diesel,
                                                    transmission: .automatic,
                                                    drivetrain: .rearWheelDrive,
                                                    fuelConsumption: 11),
                                bodyType: .refrigeratedTruck,
                                  cargoCapacity: .init(payloadCapacity: 4800,
                                                       maxHeight: 79,
                                                       maxLength: 189,
                                                       maxWidth: 70,
                                                       maxVolume: 469))

        let carFleet = CarFleet(ordersProvider: ordersProvider,
                                cargoCars: [mbSprinterRefrigerated],
                                passengerCars: [mbSprinter],
                                cargoPassengerCars: [])

        carFleet.getStarted()
    }
}
