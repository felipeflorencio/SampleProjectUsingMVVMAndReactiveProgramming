//
//  Util.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 11/10/2020.
//

import Foundation


public func delay(_ delay: Double, closure: @escaping () -> Void) {
    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(
        deadline: deadline,
        execute: closure
    )
}
