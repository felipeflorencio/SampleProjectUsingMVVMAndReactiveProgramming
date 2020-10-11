//
//  UIRefreshController+Extension.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 10/10/2020.
//

import UIKit

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.endRefreshing()
        }
    }
}
