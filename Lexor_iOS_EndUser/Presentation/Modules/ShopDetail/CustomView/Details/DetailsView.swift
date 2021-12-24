//
//  DetailsView.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/2/21.
//

import UIKit
import GoogleMaps

protocol DetailsViewDelegate: AnyObject {
    func view(_ view: DetailsView, needsPerform action: DetailsView.Action)
}

final class DetailsView: UIView {
    
    private struct DefaultLocation {
        static let latitude: Double = 0
        static let longitude: Double = 0
    }
    
    enum Action {
        case seeAllTechnicians
        case call(number: String)
    }
    
    @IBOutlet private weak var mapView: GMSMapView!
    @IBOutlet private weak var descriptionLabel: CollapsableLabel!
    @IBOutlet private var technicianViews: [TechnicianView]!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private var openingHoursLabel: [UILabel]!
    
    weak var delegate: DetailsViewDelegate?
    
    var viewModel: DetailsViewModel? {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.setMinZoom(5, maxZoom: mapView.maxZoom)
        let camera = GMSCameraPosition.camera(withLatitude: DefaultLocation.latitude, longitude: DefaultLocation.longitude, zoom: 10)
        mapView.animate(to: camera)
        
        descriptionLabel.numberOfLines = 3
        let loremText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 1.5
        let attributes: [NSAttributedString.Key: Any] = [
            .font: descriptionLabel.font as Any,
            .paragraphStyle: style
        ]
        descriptionLabel.originText = NSMutableAttributedString(string: loremText, attributes: attributes)
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("DetailsView", owner: self)?.first as? UIView {
            addSubview(view)
            view.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
    }
    
    private func update() {
        guard let viewModel = viewModel else { return }
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude, zoom: 10)
        mapView.animate(to: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: viewModel.coordinates.latitude, longitude: viewModel.coordinates.longitude)
        marker.title = viewModel.name
        marker.snippet = viewModel.address
        marker.map = mapView
        mapView.selectedMarker = marker
        
        technicianViews.forEach { technicianView in
            if let technician = viewModel.technician(at: technicianView.tag) {
                technicianView.isHidden = false
                technicianView.update(technician: technician)
            } else {
                technicianView.isHidden = true
            }
        }
        
        phoneLabel.text = viewModel.phone
        
        openingHoursLabel.forEach { label in
            label.text = viewModel.opening(at: label.tag)
        }
    }
    
    @IBAction private func seeAllButtonTouchUpInside(_ sender: UIButton) {
        delegate?.view(self, needsPerform: .seeAllTechnicians)
    }
    
    @IBAction private func callButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel, let delegate = delegate else {
            return
        }
        delegate.view(self, needsPerform: .call(number: viewModel.phone))
    }
}
