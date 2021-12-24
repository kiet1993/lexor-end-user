//
//  ReviewViewController.swift
//  Lexor_iOS_EndUser
//
//  Created by Cuong Doan M. VN.Danang on 7/3/21.
//

import UIKit
import Photos
import MobileCoreServices
import SVProgressHUD

final class ReviewViewController: UIViewController {
    
    @IBOutlet private weak var shopNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private var imageViews: [UIImageView]!
    @IBOutlet private var deleteButtons: [UIButton]!
    @IBOutlet private weak var postButton: UIButton!
    
    lazy final private var rightBarButtonItem: UIBarButtonItem = { [unowned self] in
        return UIBarButtonItem(
            image: UIImage(named: "ic-xmark"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTouchUpInside)
        )
    }()
    var viewModel: ReviewViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Review"
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        shopNameLabel.text = viewModel.shopName
        dateLabel.text = Date().toString(withFormat: .dMsYSpace)
        textView.delegate = self
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: addButton.bounds).cgPath
        layer.strokeColor = UIColor.darkGray.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineDashPattern = [4, 4]
        layer.frame = addButton.bounds
        addButton.layer.addSublayer(layer)
        
        deleteButtons.forEach {
            $0.addShadow(ofColor: .white)
        }
        
        viewModel.imagesDidChangeHandler = {
            self.handleImagesChanged()
        }
        viewModel.images = []
    }
    
    @objc private func rightBarButtonTouchUpInside(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func handleImagesChanged() {
        addButton.isEnabled = viewModel.images.count < 5
        let imageOrNils: [UIImage?] = (0..<5).map { self.viewModel.images[safe: $0] }
        zip(imageViews, imageOrNils).forEach { (imageView, image) in
            imageView.image = image
            imageView.superview?.isHidden = image == nil
        }
    }
    
    @IBAction private func addButtonTouchUpInside(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    @IBAction private func deleteButtonTouchUpInside(_ sender: UIButton) {
        viewModel.removeImages(at: sender.tag)
    }
    
    @IBAction private func postButtonTouchUpInside(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Posting...")
        SVProgressHUD.dismiss(withDelay: 1.5) {
            SVProgressHUD.showSuccess(withStatus: "Success!")
            SVProgressHUD.dismiss(withDelay: 1.5) {
                self.dismiss(animated: true)
            }
        }
    }
}

extension ReviewViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let isEmpty: Bool = textView.text.isNilOrEmpty
        placeholderLabel.isHidden = !isEmpty
        postButton.isEnabled = !isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let proposedText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return proposedText.count < 500
    }
}

extension ReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let mediaType = info[.mediaType] as? String else { return }
        switch mediaType {
        case String(describing: kUTTypeImage):
            if let image = info[.originalImage] as? UIImage {
                viewModel.images.append(image)
            }
        default:
            break
        }
    }
}
