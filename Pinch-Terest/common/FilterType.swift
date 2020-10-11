//
//  Filter.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 10/10/2020.
//

import Foundation

enum FilterType {
    case sortAscending
    case sortDescend
    case none
    
    var description: String {
        switch self {
        case .sortAscending: return "Ascending"
        case .sortDescend: return "Descending"
        default: return ""
        }
    }
}
