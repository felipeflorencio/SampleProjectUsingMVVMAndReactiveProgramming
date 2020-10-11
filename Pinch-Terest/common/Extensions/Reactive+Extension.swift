//
//  Reactive+Extension.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 10/10/2020.
//

import Foundation

typealias PinchResult<T> = Result<T, PinchError>

extension Result {
    
    func success(_ success: (Success) -> PinchResult<Void>) -> PinchResult<Void> {
        if case .success(let data) = self {
            return success(data)
        } else {
            return PinchResult.failure(PinchError.invalidData)
        }
    }
    
    func failure(_ failure: (PinchError) -> ()) {
        _ = self.mapError { error -> Error in
            if let pinchError = error as? PinchError {
                failure(pinchError)
            }
            return error
        }
    }
}
