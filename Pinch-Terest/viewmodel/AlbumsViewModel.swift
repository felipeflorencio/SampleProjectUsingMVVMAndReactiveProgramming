//
//  AlbumsViewModel.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import Foundation
import RxSwift
import Moya

class AlbumsViewModel {
    
    private var pagination: Int = 1
    private var isFetchinInProgress: Bool = false
    private var customFilter: FilterType? {
        didSet {
            guard let filter = self.customFilter else { return }
            hasFilter.onNext(filter)
        }
    } // For now we will allow only one at the time
    
    private(set) var albumList: [AlbumModel]?
    private(set) var photoAlbumId: (() -> (Int))?
    private(set) var filters: [FilterType] = [.sortAscending, .sortDescend]
    private(set) var hasFilter = PublishSubject<FilterType>()
    
    var currentCount: Int {
        return self.albumList?.count ?? 0
    }
    
    private let provider: PinchProvider
    
    init(provider: PinchProvider) {
        self.provider = provider
    }
    
    func retrieveAlbums(nextPage: Bool = false) -> Completable {
        
        guard !isFetchinInProgress else { return .empty() } // Avoid user request multiple times
        
        isFetchinInProgress = true
        
        // For now we are setting the rule of how many will be fetch here
        // can be upgraded to receive as parameter
        var parameters: [URLQueryParameter] = [.limit(20)]
        
        if let customFilter = self.customFilter,
           let queryFilter = self.filterUrlQueryOption(for: customFilter) {
            parameters.append(queryFilter)
        }
        
        if nextPage {
            self.pagination += 1
        } else {
            // doing this we can reset when user use pull-to-refresh
            self.pagination = 0
        }
        
        parameters.append(URLQueryParameter.page(self.pagination))
        
        return .create { [unowned self] observer -> Disposable in

            self.provider.getList(path: .albums(parameter: parameters),
                                  resource: AlbumModel.self).subscribe { listOfAlbums in
                                    self.isFetchinInProgress = false
                                           
                                    guard listOfAlbums.count != 0 else {
                                        observer(.error(PinchError.noData))
                                        return
                                    }
                                    
                                    if self.pagination != 0 {
                                        self.albumList?.append(contentsOf: listOfAlbums)
                                    } else {
                                        self.albumList = listOfAlbums
                                    }
                                    observer(.completed)
                                  } onError: { error in
                                    self.isFetchinInProgress = false
                                    observer(.error(error))
                                  }

        }
    }
    
    func album(at index: Int) -> AlbumModel? {
        return self.albumList?[safe: index]
    }
    
    func show(photos index: Int) -> PinchResult<Void> {
        if let item = self.albumList?[safe: index] {
            photoAlbumId = { return item.id }
            return .success(())
        }
        
        return .failure(.invalidData)
    }
    
    func filter(using option: FilterType) {
        self.customFilter = option != .none ? option : nil
    }
    
    private func filterUrlQueryOption(for filter: FilterType) -> URLQueryParameter? {
        switch filter {
        case .sortAscending: return .orderAsc
        case .sortDescend: return .orderDes
        default: return nil
        }
    }
}
