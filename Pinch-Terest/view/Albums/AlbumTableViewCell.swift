//
//  AlbumTableViewCell.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import UIKit

class AlbumTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel! // Only used for now to hide or not, in production to localize it
    
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
        
        setup(with: .none)
    }
    
    static let reusable = String(describing: AlbumTableViewCell.self)
    
    func setup(with album: AlbumModel?) {
        self.loading = album == nil
        
        guard let album = album else { return }
        
        self.titleLabel.text = album.title
    }
    
}
