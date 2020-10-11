//
//  PinchApi.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import Foundation
import Moya

enum PinchApi {
    case photos(parameter: [URLQueryParameter]?)
    case albums(parameter: [URLQueryParameter]?)
}

extension PinchApi: TargetType {
    var baseURL: URL {
        guard let url = HTTP.baseUrl else { fatalError() } // if is not possible to generate will fail when we run for first time
        return url
    }
    
    var path: String {
        switch self {
        case .albums(parameter: _): return HTTP.albumsPath
        case .photos(parameter: _): return HTTP.photosPath
        }
    }
    
    var method: Moya.Method {
        return .get // For this test purpose we only support get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        // In order to Moya remove optional parameter and don't set if nil need to declare first as var
        case .albums(let parameters):
            var params: [String: Any] = [:]
            parameters?.forEach({ params[$0.item.name] = $0.item.value })
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .photos(let parameters):
            var params: [String: Any] = [:]
            parameters?.forEach({ params[$0.item.name] = $0.item.value })
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return HTTP.header
    }
}
