//
//  TableView+Extension.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import UIKit

extension UITableView {
    
    func showBottomLoading(_ loading: Bool, loadingIndicator: UIActivityIndicatorView) {
        let bottomInset: CGFloat = loading ? 40.0 : 0.0
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        if loading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        self.isUserInteractionEnabled = !loading // for a better experience we will lock user move the table view
    }
}
