//
//  Array+Extension.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import Foundation

extension Array {
    
    // Very helpful helper in order to get a item from array in safe way
    // that you don't need to first check if indice is there and access
    // latter, just set the indice and will return if array have
    /* How to use:
       let exampleArray = ["item1", "item2", "item3", "item4", "item5", "item6"]
       let returnIfExist = exampleArray[safe: 3]
    
      If not there will return nil, so you can use with 'guard' to
     */
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
