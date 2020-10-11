//
//  UIImageView+Extension.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 10/10/2020.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(for url: URL) {
        self.kf.indicatorType = .activity
        let roundCorner = RoundCornerImageProcessor(cornerRadius: 10)
        self.kf.setImage(with: url, options: [.processor(roundCorner), .transition(.fade(0.2))])
    }
}
