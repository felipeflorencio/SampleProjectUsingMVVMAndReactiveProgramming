//
//  PhotoViewController.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 09/10/2020.
//

import UIKit
import RxSwift

class PhotoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
    
    var viewModel: PhotoViewModel?
    
    /// This is to show how we can create a initializer, in a upgraded version that uses
    /// dependency injection this would be there
    class func controller(parameter data: PhotoModel) -> PinchResult<PhotoViewController> {
        guard let vc = PhotoViewController.loadController() as? PhotoViewController else {
            return .failure(.appError(string: "Can't load your image view"))
        }
        vc.viewModel = PhotoViewModel(dataModel: data)
        return .success(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.photoImage.kf.cancelDownloadTask()
    }
    
    private func setupUI() {
        guard let viewModel = self.viewModel else { return }
        self.titleLabel.text = viewModel.dataModel.title
        guard let imageUrl = URL(string: viewModel.dataModel.url) else { return }
        self.photoImage.setImage(for: imageUrl)
    }
}
