//
//  BookAppointmentVM.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/7/21.
//

import Foundation

struct Designer {
    var name: String
    var hexColorStr: String
}

final class BookAppointmentVM {
    typealias DesignDataTuple = (design: Designer, isSelected: Bool)

    // MARK: - Properties
    private(set) var cartDetail: CartOrderResult?
    private(set) var serviceSelectedInfoList: [Service] = []
    private(set) var designerList: [DesignDataTuple] = [(design: Designer(name: "Design 1", hexColorStr: "#C9C9C9"), isSelected: false),
                                                        (design: Designer(name: "Design 2", hexColorStr: "#C8C8C8"), isSelected: false),
                                                        (design: Designer(name: "Design 3", hexColorStr: "#C7C7C7"), isSelected: false),
                                                        (design: Designer(name: "Design 4", hexColorStr: "#C6C6C6"), isSelected: false),
                                                        (design: Designer(name: "Design 5", hexColorStr: "#C5C5C5"), isSelected: false)]
    private(set) var technicianList: [TechnicianModel] = [TechnicianModel(avatarURL: "", name: "Tech 1", isFavorite: false),
                                                          TechnicianModel(avatarURL: "", name: "Tech 2", isFavorite: false),
                                                          TechnicianModel(avatarURL: "", name: "Tech 3", isFavorite: false),
                                                          TechnicianModel(avatarURL: "", name: "Tech 4", isFavorite: false),
                                                          TechnicianModel(avatarURL: "", name: "Tech 5", isFavorite: false)]

    var totalAmount: String {
        var count = 0.0
        serviceSelectedInfoList.forEach { count += $0.price }
        return "$\(count)"
    }

    // MARK: - Init
    init(serviceSelectedInfoList: [Service]) {
        self.serviceSelectedInfoList.append(contentsOf: serviceSelectedInfoList)
    }

    // MARK: - Public
    func getServiceList(completion: @escaping APICompletion) {
        completion(.success)
    }

    func viewModelForServicesView() -> ServicesViewModel {
        return ServicesViewModel(services: serviceSelectedInfoList)
    }

    func addNewService(_ serviceInfo: Service) {
        guard serviceSelectedInfoList.count < Config.maxServiceInfo else { return }
        serviceSelectedInfoList.append(serviceInfo)
    }

    func updateServiceDesign(atIndexPath indexPath: IndexPath) {
        guard 0 <= indexPath.row && indexPath.row < designerList.count else { return }
        for _ in 0..<serviceSelectedInfoList.count {
            #warning("Update here when have final api")
            // serviceSelectedInfoList[i].sku = designerList[indexPath.row].design.name
        }
        for i in 0..<designerList.count {
            designerList[i].isSelected = false
        }
        designerList[indexPath.row].isSelected = true
    }

    func updateServiceTechnician(atIndexPath indexPath: IndexPath) {
        guard 0 <= indexPath.row && indexPath.row < technicianList.count else { return }
        for _ in 0..<serviceSelectedInfoList.count {
            #warning("Update here when have final api")
            // serviceSelectedInfoList[i].technician = technicianList[indexPath.row].name
        }
        for i in 0..<technicianList.count {
            technicianList[i].isFavorite = false
        }
        technicianList[indexPath.row].isFavorite = true
    }

    func getBookAppointDesignCellModel(atIndexPath indexPath: IndexPath) -> BookAppointDesignCellModel? {
        guard 0 <= indexPath.row && indexPath.row < designerList.count else { return nil }
        return BookAppointDesignCellModel(design: designerList[indexPath.row].design, isSelected: designerList[indexPath.row].isSelected)
    }

    func getBookAppointTechCellModel(atIndexPath indexPath: IndexPath) -> BookAppointTechCellModel? {
        guard 0 <= indexPath.row && indexPath.row < technicianList.count else { return nil }
        return BookAppointTechCellModel(technician: technicianList[indexPath.row], isFavorite: technicianList[indexPath.row].isFavorite)
    }

    func getConfirmBookingViewModel() -> ConfirmBookingVM? {
        return ConfirmBookingVM(serviceBooked: serviceSelectedInfoList)
    }

    func createCart(completion: @escaping APICompletion) {
        NetworkService.shared.createEmptyCart { result in
            switch result {
            case .success(let cartID):
                AccountManager.shared.cartID = cartID
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getExitsCart(completion: @escaping APICompletion) {
        NetworkService.shared.getCartInfo { result in
            switch result {
            case .success(let cartDetail):
                self.cartDetail = cartDetail
                AccountManager.shared.cartID = cartDetail.id
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addProductToCart(product: Service, completion: @escaping APICompletion) {
        var param: [String: Any] = [:]
        do {
            let tmp = AddCartItemParam(cartItem: CartItem(sku: "service1", qty: 1,
                                                          productOption: ProductOption(extensionAttributes: BookAppointmentVM.ExtensionAttributes())))
            param = try tmp.asDictionary()
        } catch {
            completion(.failure(error))
        }
        NetworkService.shared.addAddProductToCart(productInfo: param) { result in
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func removeService(withName name: String, completion: @escaping APICompletion) {
        guard let index = serviceSelectedInfoList.firstIndex(where: { $0.name == name }) else {
            completion(.failure(NSError(message: "Some thing wrong!")))
            return
        }
        let id = serviceSelectedInfoList[index].id
        APIRequest.getRemoveProductFromCart(productID: "\(id)") { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.serviceSelectedInfoList.remove(at: index)
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Config
extension BookAppointmentVM {
    struct Config {
        static let maxServiceInfo: Int = 10
    }

    // MARK: - Welcome
    struct AddCartItemParam: Codable {
        let cartItem: CartItem
    }

    // MARK: - CartItem
    struct CartItem: Codable {
        let sku: String
        let qty: Int
        let productOption: ProductOption

        enum CodingKeys: String, CodingKey {
            case sku, qty
            case productOption = "product_option"
        }
    }

    // MARK: - ProductOption
    struct ProductOption: Codable {
        let extensionAttributes: ExtensionAttributes

        enum CodingKeys: String, CodingKey {
            case extensionAttributes = "extension_attributes"
        }
    }

    // MARK: - ExtensionAttributes
    struct ExtensionAttributes: Codable {

        let reservationOptions: ReservationOptions = ReservationOptions(retailerID: 1,
                                                                        technicianID: 1,
                                                                        designIDS: [1, 2],
                                                                        date: "2021-10-10",
                                                                        startTime: "07:00:00",
                                                                        endTime: "07:30:00",
                                                                        note: "I want booking services")

        enum CodingKeys: String, CodingKey {
            case reservationOptions = "reservation_options"
        }
    }

    // MARK: - ReservationOptions
    struct ReservationOptions: Codable {
        let retailerID, technicianID: Int
        let designIDS: [Int]
        let date, startTime, endTime, note: String

        enum CodingKeys: String, CodingKey {
            case retailerID = "retailer_id"
            case technicianID = "technician_id"
            case designIDS = "design_ids"
            case date
            case startTime = "start_time"
            case endTime = "end_time"
            case note
        }
    }

}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
