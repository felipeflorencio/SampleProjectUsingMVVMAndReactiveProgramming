//
//  AlbumsRoutes.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 09/10/2020.
//

import UIKit
import Moya

struct AlbumsRoutes: Router {
    
    typealias ParameterData = Int
    typealias ViewModel = AlbumsViewModel
    
    private(set) var viewModel: AlbumsViewModel?
    
    init(view model: AlbumsViewModel?) {
        self.viewModel = model
    }
    
    func route(to routeID: Routes, from context: UIViewController) -> PinchResult<Void>  {
        /// For the purpose of the test we only make one scenario
        /// but it's ususeful to create boundaries and enforce a pattern
        if case .photos = routeID {
            guard let photosId = self.viewModel?.photoAlbumId?() else { return .failure(.missingParameter) }
            return PhotosViewController.controller(parameter: photosId,
                                                   provider: PinchProvider())
                .success { viewController -> PinchResult<Void> in
                context.navigationController?.pushViewController(viewController, animated: true)
                return .success(())
            }
        }
        
        return .failure(.noRoute)
    }
}

