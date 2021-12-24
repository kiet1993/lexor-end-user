//
//  TechnicianListVM.swift
//  Lexor_iOS_EndUser
//
//  Created by Bien Le Q. VN.Danang on 7/10/21.
//

import Foundation

final class TechnicianListVM {

    enum CellType {
        case technicianCell
        case serviceCell
    }

    struct ServiceCellData {
        var serviceInfo: Service?
        var isBeginOfList: Bool
        var isEndOfList: Bool
    }

    typealias TechnicianPresentTupleData = (data: Any?, cellType: CellType)

    // MARK: - Properties
    private(set) var technicianPresentList: [TechnicianPresentTupleData] = []
    private var technicianList: [TechnicianModel] = []

    // MARK: - Public
    func getTechnicianList(completion: @escaping APICompletion) {
        technicianList = [TechnicianModel(avatarURL: "", name: "Tech 1",
                                          services: [], isFavorite: false),
                          TechnicianModel(avatarURL: "", name: "Tech 2",
                                          services: [], isFavorite: false),
                          TechnicianModel(avatarURL: "", name: "Tech 3",
                                          services: [], isFavorite: false),
                          TechnicianModel(avatarURL: "", name: "Tech 4",
                                          services: [], isFavorite: false),
                          TechnicianModel(avatarURL: "", name: "Tech 5",
                                          services: [], isFavorite: false)]
        convertToTechnicianPresent(newTechnicianList: technicianList, isLoadMore: false)
        completion(.success)
    }

    // MARK: - Private
    private func convertToTechnicianPresent(newTechnicianList: [TechnicianModel], isLoadMore: Bool) {
        var presentListTemp: [TechnicianPresentTupleData] = []
        newTechnicianList.forEach { technicianData in
            let technicianPresentData = TechnicianPresentTupleData(data: technicianData, cellType: .technicianCell)
            presentListTemp.append(technicianPresentData)
            technicianData.services.enumerated().forEach { serviceEnumerate in
                let serviceCellData = ServiceCellData(serviceInfo: serviceEnumerate.element,
                                                      isBeginOfList: serviceEnumerate.offset == 0,
                                                      isEndOfList: serviceEnumerate.offset == technicianData.services.count - 1)
                let servicePresentData = TechnicianPresentTupleData(data: serviceCellData, cellType: .serviceCell)
                presentListTemp.append(servicePresentData)
            }
        }
        if isLoadMore {
            technicianPresentList.append(contentsOf: presentListTemp)
        } else {
            technicianPresentList = presentListTemp
        }
    }

    // MARK: - Public
    func getTechnicianListCellModel(atIndexPath indexPath: IndexPath) -> TechnicianListCellModel? {
        guard let presentData = technicianPresentList[safe: indexPath.row]?.data as? TechnicianModel else { return nil }
        let isNoService = technicianPresentList[safe: indexPath.row + 1]?.data as? ServiceCellData == nil
        return TechnicianListCellModel(technicianData: presentData, indexPath: indexPath, isNoService: isNoService )
    }

    func getServiceListCellModel(atIndexPath indexPath: IndexPath) -> TechnicianListServiceChildCellModel? {
        guard let serviceCellData = technicianPresentList[safe: indexPath.row]?.data as? ServiceCellData else { return nil }
        return TechnicianListServiceChildCellModel(serviceCellData: serviceCellData, indexPath: indexPath)
    }

    func updateFavoriteState(ofIndexPath indexPath: IndexPath) {
        guard let technicianModel = (technicianPresentList[safe: indexPath.row]?.data as? TechnicianModel) else { return }
        var tmp = technicianModel
        tmp.isFavorite = !tmp.isFavorite
        technicianPresentList[indexPath.row].data = tmp
    }
}
