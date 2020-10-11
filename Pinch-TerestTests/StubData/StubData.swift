//
//  StubData.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 10/10/2020.
//

import Foundation
@testable import Pinch_Terest

struct StubData {
    
    static func albumStubData(size: Int = 20) -> [AlbumModel] {
        
        var albumResponse = [AlbumModel]()
        for index in 0..<size {
            albumResponse.append(AlbumModel(userId: index, id: Int.random(in: 1...100), title: "Item number \(index)"))
        }
        return albumResponse
    }
    
    static func photosStubData(size: Int = 20) -> [PhotoModel] {
        
        var photoResponse = [PhotoModel]()
        for index in 0..<size {
            photoResponse.append(PhotoModel(albumId: index, id: Int.random(in: 1...100), title: "Item number \(index)", url: "http://www.pinch/\(index)", thumbnailUrl: "http://www.pinch/thumbnail\(index)"))
        }
        return photoResponse
    }
    
    static func jsonEncoded<T: Encodable>(for data: [T]) -> Data {
        let jsonData = try! JSONEncoder().encode(data)
        return jsonData
    }
}
