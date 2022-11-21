import UIKit

protocol OrdersProvidingProtocol {
    func fetchNewOrders() -> [OrderType]
}

final class OrdersProvider: OrdersProvidingProtocol {
    
    // MARK: - Public
    
    public func fetchNewOrders() -> [OrderType] {
        var orders = [OrderType]()
        
        orders.append(.passenger(model: .init(description: "Доставить детей на экскурсию в Мирский замок",
                                              route: .init(startPoint: 0,
                                                           endPoint: 265),
                                              numberOfPassengers: 12)))
        
        orders.append(.passenger(model: .init(description: "Доставить людей в Гродно",
                                              route: .init(startPoint: 0,
                                                           endPoint: 239),
                                              numberOfPassengers: 10)))
        
        orders.append(.passenger(model: .init(description: "Доставить людей в Пинск",
                                              route: .init(startPoint: 0,
                                                           endPoint: 181),
                                              numberOfPassengers: 12)))
        
        orders.append(.cargo(model: .init(description: "Доставить продукты в Пинск",
                                          route: .init(startPoint: 0,
                                                       endPoint: 181),
                                          cargo: .init(cargoType: .consumerProducts,
                                                       weight: 3000,
                                                       volume: 400))))
        
        orders.append(.cargo(model: .init(description: "Доставить сталь в Гродно",
                                          route: .init(startPoint: 0,
                                                       endPoint: 239),
                                          cargo: .init(cargoType: .manufacturedGoods,
                                                       weight: 5000,
                                                       volume: 1000))))
        
        return orders
    }
}
