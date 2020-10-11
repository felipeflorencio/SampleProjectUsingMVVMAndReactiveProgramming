//
//  AlbumsViewModelTests.swift
//  Pinch-TerestTests
//
//  Created by Felipe Florencio Garcia on 10/10/2020.
//

import XCTest
import RxSwift
import RxTest
import Moya
@testable import Pinch_Terest

class AlbumsViewModelTests: XCTestCase {

    var scheduler: TestScheduler!
    
    var viewModel: AlbumsViewModel!
    
    override func setUp() {
        super.setUp()
        let moyaProvider = MoyaProvider<PinchApi>(endpointClosure: customEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let pinchProvider = PinchProvider(provider: moyaProvider)
        self.viewModel = AlbumsViewModel(provider: pinchProvider)
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testRequestCompleted() throws {
        /// Given
        var events: [CompletableEvent] = []
        
        /// When
        _ = self.viewModel.retrieveAlbums().subscribe { event in
            events.append(event)
        }
        
        /// Then
        XCTAssertEqual(events, [.completed])
    }
    
    func testRequestInitialDataReceived() {
        /// Given
        let response = scheduler.createObserver([AlbumModel].self)
        
        /// When
        _ = self.viewModel.retrieveAlbums().subscribe({ event in
            if event == .completed, let content = self.viewModel.albumList {
                response.onNext(content)
            }
        })
        
        /// Then
        scheduler.start()
        
        XCTAssertEqual(response.events.count, 1)
        XCTAssertEqual(response.events.first?.value.element?.count, 20)
    }
    
    func testRequestPaginationDataReceived() {
        /// Given
        let response = scheduler.createObserver([AlbumModel].self)
        
        /// When
        _ = self.viewModel.retrieveAlbums().subscribe()
        _ = self.viewModel.retrieveAlbums(nextPage: true).subscribe({ event in
            if event == .completed, let content = self.viewModel.albumList {
                response.onNext(content)
            }
        })
        
        /// Then
        scheduler.start()
        
        XCTAssertEqual(response.events.count, 1)
        XCTAssertEqual(response.events.first?.value.element?.count, 40)
    }

    func testHasParameterDataReceived() {
        /// Given
        let response = scheduler.createObserver(FilterType.self)
        
        /// When
        _ = self.viewModel.hasFilter.subscribe { event in
            response.on(event)
        }
        self.viewModel.filter(using: .sortAscending)

        /// Then
        scheduler.start()
        
        XCTAssertEqual(response.events.first?.value.element, .sortAscending)
    }
    
    func testSetNoParameterDataReceived() {
        /// Given
        let response = scheduler.createObserver(FilterType.self)
        
        /// When
        _ = self.viewModel.hasFilter.subscribe { event in
            response.on(event)
        }
        self.viewModel.filter(using: .none)

        /// Then
        scheduler.start()
        
        XCTAssertNil(response.events.first?.value.element)
    }
    
    func testRequestInitialDataWithoutParameterAlwaysReceived() {
        /// Given
        let response = scheduler.createObserver([AlbumModel].self)
        let responseFilter = scheduler.createObserver(FilterType.self)

        /// When
        _ = self.viewModel.hasFilter.subscribe(onNext: { event in
            responseFilter.onNext(event)
        })
        _ = self.viewModel.retrieveAlbums().subscribe({ event in
            if event == .completed, let content = self.viewModel.albumList {
                response.onNext(content)
            }
        })
        
        /// Then
        scheduler.start()
        
        XCTAssertEqual(response.events.count, 1)
        XCTAssertEqual(response.events.first?.value.element?.count, 20)
        XCTAssertTrue(responseFilter.events.isEmpty)
    }
    
    func testIfTheFilterTypesAreInPlace() {
        /// Given
        let filters = self.viewModel.filters
        
        /// Then
        XCTAssertTrue(filters.contains(.sortAscending))
        XCTAssertTrue(filters.contains(.sortDescend))
    }
    
    func testIfCurrentCountIsGettingValueRight() {
        /// Given
        let response = scheduler.createObserver([AlbumModel].self)
        
        /// When
        _ = self.viewModel.retrieveAlbums().subscribe({ event in
            if event == .completed, let content = self.viewModel.albumList {
                response.onNext(content)
            }
        })
        
        /// Then
        scheduler.start()
        
        XCTAssertEqual(self.viewModel.currentCount, 20)
    }
    
    func testAlbumObjectPick() {
        /// Given
        let response = scheduler.createObserver([AlbumModel].self)
        
        /// When
        _ = self.viewModel.retrieveAlbums().subscribe({ event in
            if event == .completed, let content = self.viewModel.albumList {
                response.onNext(content)
            }
        })
        
        /// Then
        scheduler.start()
        
        XCTAssertEqual(self.viewModel.album(at: 4)?.userId, 4)
    }
    
    func testPhotoListShowForId() {
        /// Given
        let response = scheduler.createObserver([AlbumModel].self)
        
        /// When
        _ = self.viewModel.retrieveAlbums().subscribe({ event in
            if event == .completed, let content = self.viewModel.albumList {
                response.onNext(content)
            }
        })
        
        /// Then
        scheduler.start()
        
        let result = self.viewModel.show(photos: 4)
        var successResult = false
        if case .success = result {
            successResult = true
        }
        XCTAssertTrue(successResult)
        XCTAssertNotNil(self.viewModel.photoAlbumId?())
    }
    
    func testRequestFailed() {
        let moyaProvider = MoyaProvider<PinchApi>(endpointClosure: customFailedEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let pinchProvider = PinchProvider(provider: moyaProvider)
        let viewModel = AlbumsViewModel(provider: pinchProvider)
        
        let response = scheduler.createObserver([AlbumModel].self)
        
        /// When
        _ = viewModel.retrieveAlbums().subscribe({ event in
            if case .error(let error) = event {
                response.onError(error)
            }
        })
        
        /// Then
        scheduler.start()
        
        XCTAssertNotNil(response.events.first?.value.error)
    }
}
