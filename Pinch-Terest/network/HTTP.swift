//
//  API.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import Foundation

class HTTP {
    
    private init() {} // We dont't want to be a initializable class
    
    static let baseUrl = URL(string: "http://testapi.pinch.nl:3000/")
    
    static let photosPath = "photos"
    static let albumsPath = "albums"
    
    // Default header configuration
    static let header = ["Content-Type": "application/json"]
}
