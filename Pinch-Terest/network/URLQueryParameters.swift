//
//  URLQueryParameters.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import Foundation

/**
 Query parameters for HTTP request
 */
enum URLQueryParameter {
    
    /// album id that you are looking forward
    case albumId(Int)
    
    /// page
    case page(Int)
    
    /// limit of itens to be retrieved
    case limit(Int)
    
    /// Filter using ascending order
    case orderAsc
    
    /// FIlter using descending order
    case orderDes
}

extension URLQueryParameter {
    var item: URLQueryItem {
        switch self {
        case .albumId(let id):
            return URLQueryItem(name: "albumId", value: String(id))
        case .page(let page):
            return URLQueryItem(name: "_page", value: String(page))
        case .limit(let quantity):
            return URLQueryItem(name: "_limit", value: String(quantity))
        case .orderAsc: return URLQueryItem(name: "_order", value: "asc")
        case .orderDes: return URLQueryItem(name: "_order", value: "desc")
        }
    }
}

extension URLQueryParameter : CustomStringConvertible {
    
    var description: String {
        return self.item.description
    }
}
