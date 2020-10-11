//
//  UIViewController+Extension.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 09/10/2020.
//

import UIKit

extension UIViewController {
    /// Loads a `UIViewController` of type `T` with storyboard.
    /// - Parameter storyboardName: Name of the storyboard without
    static func loadController<T: UIViewController>(_ storyboardName: String = "Main") -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T {
            return vc
        }
        return nil
    }
    
    /// Just a simple helper
    func showError(with message: PinchError, completed: (() -> ())? = nil){
        let alert = UIAlertController(title: "😩", message: message.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true) {
            completed?()
        }
    }
}
