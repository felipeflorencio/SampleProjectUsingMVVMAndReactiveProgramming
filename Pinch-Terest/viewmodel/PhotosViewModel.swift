//
//  PhotosViewModel.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import Foundation
import RxSwift

class PhotosViewModel {
    
    private var pagination: Int = 1
    private var isFetchinInProgress: Bool = false
    private var photosId: Int?
    
    private(set) var photosList: [PhotoModel]?
    private(set) var photoModel: (() -> (PhotoModel))?

    private let provider: PinchProvider
    
    init(id photosId: Int, provider: PinchProvider) {
        self.photosId = photosId
        self.provider = provider
    }
    
    var currentCount: Int {
        return self.photosList?.count ?? 0
    }
    
    /// We will use this to get last 20 itens that were download / appended to prefetch the images url
    var lastPhotos: [PhotoModel]? {
        return self.photosList?.suffix(20)
    }
    
    func retrievePhotos(nextPage: Bool = false) -> Completable {
        
        guard !isFetchinInProgress, let id = self.photosId else { return .empty() }
        
        isFetchinInProgress = true
        
        // For now we are setting the rule of how many will be fetch here
        // can be upgraded to receive as parameter
        var parameters: [URLQueryParameter] = [.limit(20), .albumId(id)]
        
        if nextPage {
            self.pagination += 1
        } else {
            // doing this we can reset when user use pull-to-refresh
            self.pagination = 0
        }
        
        parameters.append(URLQueryParameter.page(self.pagination))
        
        return .create { [unowned self] observer -> Disposable in

            self.provider.getList(path: .photos(parameter: parameters),
                                  resource: PhotoModel.self).subscribe { listOfPhotos in
                                    self.isFetchinInProgress = false
                                            
                                    guard listOfPhotos.count != 0 else {
                                        observer(.error(PinchError.noData))
                                        return
                                    }
                                    
                                    if self.pagination != 0 {
                                        self.photosList?.append(contentsOf: listOfPhotos)
                                    } else {
                                        self.photosList = listOfPhotos
                                    }
                                    observer(.completed)
                                  } onError: { error in
                                    self.isFetchinInProgress = false
                                    observer(.error(error))
                                  }

        }
    }
    
    func photo(at index: Int) -> PhotoModel? {
        return self.photosList?[safe: index]
    }
    
    func show(photos index: Int) -> PinchResult<Void> {
        if let model = self.photosList?[safe: index] {
            photoModel = { return model }
            return .success(())
        }
        
        return .failure(.invalidData)
    }
}
