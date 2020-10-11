//
//  PinchError.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 10/10/2020.
//

import Foundation

enum PinchError: Error {
    
    case appError(string: String)
    case missingParameter
    case invalidData
    case noData
    case noRoute
    
    var description: String {
        switch self {
        case .appError(let message): return message
        case .missingParameter: return "You didn't set a required parameter"
        case .invalidData: return "Sorry we can't find this data"
        case .noData: return "The response return no data"
        case .noRoute: return "💥 dead end :("
        }
    }
}
