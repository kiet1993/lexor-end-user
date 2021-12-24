//
//  ConfirmBookingVM.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 6/3/21.
//

import Foundation

final class ConfirmBookingVM {

    // MARK: - Properties
    var serviceBooked: [Service] = []
    private var cartDetail: CartOrderResult?

    var totalAmount: String {
        var count = 0.0
        serviceBooked.forEach { count += $0.price }
        return "$\(count)"
    }

    // MARK: - Init
    init(serviceBooked: [Service]) {
        self.serviceBooked = serviceBooked
    }

    // MARK: - Public
    func removeService(withName name: String) {
        guard let index = serviceBooked.firstIndex(where: { $0.name == name }) else { return }
        serviceBooked.remove(at: index)
    }

    func orderCart(completion: @escaping APICompletionValue<String>) {
        var param: [String: Any] = [:]
        do {
            param = try Dummy.orderInfo.asDictionary()
        } catch {
            completion(.failure(error))
        }
        NetworkService.shared.bookingOrder(orderInfo: param) { result in
            switch result {
            case .success(let orderID):
                completion(.success(orderID))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPaymentMethod(completion: @escaping APICompletion) {
        NetworkService.shared.getPaymentMethod { result in
            switch result {
            case .success:
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func removeService(withName name: String, completion: @escaping APICompletion) {
        guard let index = serviceBooked.firstIndex(where: { $0.name == name }) else {
            completion(.failure(NSError(message: "Some thing wrong!")))
            return
        }
        let id = serviceBooked[index].id
        APIRequest.getRemoveProductFromCart(productID: "\(id)") { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                this.serviceBooked.remove(at: index)
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
}

extension ConfirmBookingVM {
    struct Dummy {
        static let orderInfo: CartOrder = CartOrder(email: "hiep@gmail.com",
                                                    paymentMethod: PaymentMethod(poNumber: "111111111111111111",
                                                                                 method: "checkmo",
                                                                                 additionalData: ["string"]),
                                                    billingAddress: CartBillingAddress(region: "Michigan",
                                                                                        regionID: 33,
                                                                                        regionCode: "MI",
                                                                                        countryID: "US",
                                                                                        street: ["V7 A01 The Tera An Hung"],
                                                                                        company: "string",
                                                                                        telephone: "432443243423",
                                                                                        fax: "3432423432434",
                                                                                        postcode: "12121",
                                                                                        city: "Ohio",
                                                                                        firstname: "Hiep",
                                                                                        lastname: "Tran",
                                                                                        middlename: "",
                                                                                        billingAddressPrefix: "",
                                                                                        suffix: "",
                                                                                        vatID: "",
                                                                                        customerID: 0,
                                                                                        email: "hiep@gmail.com",
                                                                                        sameAsBilling: 1,
                                                                                        customerAddressID: 0,
                                                                                        saveInAddressBook: 0))

    }
}
