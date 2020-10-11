//
//  APIMock.swift
//  Pinch-TerestTests
//
//  Created by Felipe Florencio Garcia on 11/10/2020.
//

import Foundation
import Moya
@testable import Pinch_Terest

let customEndpointClosure = { (target: PinchApi) -> Endpoint in
    return Endpoint(url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(200 , target.testSampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
}

let customFailedEndpointClosure = { (target: PinchApi) -> Endpoint in
    return Endpoint(url: URL(target: target).absoluteString,
                    sampleResponseClosure: { .networkResponse(404 , target.testSampleData) },
                    method: target.method,
                    task: target.task,
                    httpHeaderFields: target.headers)
}

extension PinchApi {
    
    var testSampleData: Data {
        switch self {
        case .albums(parameter: _):
            return StubData.jsonEncoded(for: StubData.albumStubData())
        case .photos(parameter: _):
            return StubData.jsonEncoded(for: StubData.photosStubData())
        }
    }
}
