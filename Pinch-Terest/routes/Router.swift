//
//  Router.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 09/10/2020.
//

import UIKit

protocol Router {
   
    associatedtype ParameterData
    associatedtype ViewModel
    
    var viewModel: ViewModel? { get }
    
    init(view model: ViewModel?)
    func route(to routeID: Routes, from context: UIViewController) -> PinchResult<Void>
}
