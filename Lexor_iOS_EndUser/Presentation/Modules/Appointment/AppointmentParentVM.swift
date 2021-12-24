//
//  AppointmentParentVM.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/4/21.
//

import Foundation

final class AppointmentParentVM {

    struct AppointmentData {
        var imageName: String
        var salonName: String
        var address: String
        var isFavorite: Bool
        var serviceName: String
        var serviceCost: Double
        var technician: String
        var technicianSchedule: String
        var design: String
        var designSchedule: String
        var fee: Double
        var bookingDate: String
    }

    // MARK: - Properties
    private(set) var upCommingList: [AppointmentData] = [AppointmentData](repeating: AppointmentData(imageName: "ic-chair",
                                                                                                     salonName: "Veganic Nail Salon",
                                                                                                     address: "490/48 Nam Ky Khoi Nghia, Da Nang",
                                                                                                     isFavorite: false,
                                                                                                     serviceName: "Manicure service",
                                                                                                     serviceCost: 50.0,
                                                                                                     technician: "Anybody",
                                                                                                     technicianSchedule: "07:00 - 07:30",
                                                                                                     design: "Design 1",
                                                                                                     designSchedule: "14/05/2021",
                                                                                                     fee: 20,
                                                                                                     bookingDate: DateFormatter.normalDateFormatter.string(from: Date())), count: 5)
    private(set) var pastList: [AppointmentData] = [AppointmentData](repeating: AppointmentData(imageName: "ic-chair",
                                                                                                     salonName: "Veganic Nail Salon",
                                                                                                     address: "490/48 Nam Ky Khoi Nghia, Da Nang",
                                                                                                     isFavorite: false,
                                                                                                     serviceName: "Manicure service",
                                                                                                     serviceCost: 50.0,
                                                                                                     technician: "Anybody",
                                                                                                     technicianSchedule: "07:00 - 07:30",
                                                                                                     design: "Design 1",
                                                                                                     designSchedule: "14/05/2021",
                                                                                                     fee: 20,
                                                                                                     bookingDate: DateFormatter.normalDateFormatter.string(from: Date())), count: 5)

    // MARK: - Public
    func getAppointmentTableCellModel(ofMenu menu: AppointmentParentVC.MenuType, atIndexPath indexPath: IndexPath) -> AppointmentTableCellModel? {
        var dataTmp: AppointmentData?
        switch menu {
        case .upComming:
            dataTmp = upCommingList[safe: indexPath.row]
        case .past:
            dataTmp = pastList[safe: indexPath.row]
        }
        guard let data = dataTmp else { return nil }
        return AppointmentTableCellModel(appointmentData: data, indexPath: indexPath, screenType: menu)
    }

    func favoriteAppointment(ofMenu menu: AppointmentParentVC.MenuType, atIndexPath indexPath: IndexPath) {
        switch menu {
        case .upComming:
            guard upCommingList[safe: indexPath.row] != nil else { return }
            upCommingList[indexPath.row].isFavorite = !upCommingList[indexPath.row].isFavorite
        case .past:
            guard pastList[safe: indexPath.row] != nil else { return }
            pastList[indexPath.row].isFavorite = !pastList[indexPath.row].isFavorite
        }
    }

    func cancelAppointment(atIndexPath indexPath: IndexPath) {
        guard upCommingList[safe: indexPath.row] != nil else { return }
        upCommingList.remove(at: indexPath.row)
    }
}
