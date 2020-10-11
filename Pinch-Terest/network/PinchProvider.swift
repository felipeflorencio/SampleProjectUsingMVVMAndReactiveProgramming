//
//  PinchProvider.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import Foundation
import RxSwift
import Moya

struct PinchProvider {
    
    let provider: MoyaProvider<PinchApi>
    
    /// We will have a default setup but expecting other if you want to change the configuration or test
    init(provider: MoyaProvider<PinchApi> = MoyaProvider<PinchApi>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])) {
        self.provider = provider
    }
    
    func getList<T>(path request: PinchApi,
                    resource: T.Type,
                    parameters: [URLQueryParameter]? = nil) -> Single<[T]> where T: Decodable {
        return provider.rx.request(request).filterSuccessfulStatusCodes().map([T].self)
    }
    
    func get<T>(path request: PinchApi,
                resource: T.Type,
                parameters: [URLQueryParameter]? = nil) -> Single<T> where T: Decodable {
        return provider.rx.request(request).filterSuccessfulStatusCodes().map(T.self)
    }
}
