//
//  PhotoTableViewCell.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 08/10/2020.
//

import UIKit
import Kingfisher

class PhotoTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel! // Only used for now to hide or not, in production to localize it
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    override var loading: Bool {
        didSet {
            self.titleLabel.isHidden = loading
            self.titleDescriptionLabel.isHidden = loading
            if loading {
                self.indicatorView.startAnimating()
            } else {
                self.indicatorView.stopAnimating()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImage.kf.cancelDownloadTask()
        setup(with: .none)
    }
    
    static let reusable = String(describing: PhotoTableViewCell.self)
    
    func setup(with album: PhotoModel?) {
        self.loading = album == nil
        
        guard let album = album else { return }
        
        self.titleLabel.text = album.title
        guard let imageUrl = URL(string: album.thumbnailUrl) else { return }
        self.thumbnailImage.setImage(for: imageUrl)
    }
}
