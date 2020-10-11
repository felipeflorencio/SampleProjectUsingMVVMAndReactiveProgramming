//
//  ViewController.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import UIKit
import RxSwift

class AlbumViewController: UIViewController {

    private let viewModel = PhotosViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test request
        viewModel.retrievePhotos().subscribe { event in
            switch event {
            case .completed:
                print(self.viewModel.photosList)
            case .error(let error):
                print(error.localizedDescription)
            }
        }.disposed(by: disposeBag)
        
    }


}

