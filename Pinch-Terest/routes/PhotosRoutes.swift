//
//  PhotosRoutes.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 09/10/2020.
//

import UIKit

struct PhotosRoutes: Router {
    
    typealias ParameterData = PhotoModel
    typealias ViewModel = PhotosViewModel
    
    private(set) var viewModel: PhotosViewModel?
    
    init(view model: PhotosViewModel?) {
        self.viewModel = model
    }
    
    func route(to routeID: Routes, from context: UIViewController) -> PinchResult<Void> {
        /// For the purpose of the test we only make one scenario
        /// but it's ususeful to create boundaries and enforce a pattern
        
        if case .photo = routeID {
            guard let photoModel = self.viewModel?.photoModel?() else { return .failure(.missingParameter) }
            return PhotoViewController.controller(parameter: photoModel).success { viewController -> PinchResult<Void> in
                context.present(viewController, animated: true, completion: nil)
                return .success(())
            }

        }
        
        return .failure(.noRoute)
    }
}
