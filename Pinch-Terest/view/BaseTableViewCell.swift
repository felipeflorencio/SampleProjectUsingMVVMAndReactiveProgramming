//
//  BaseTableViewCell.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var loading: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.hidesWhenStopped = true
        indicatorView.color = UIColor.blue
    }
}
