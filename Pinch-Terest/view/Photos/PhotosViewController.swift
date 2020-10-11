//
//  PhotosViewController.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 08/10/2020.
//

import UIKit
import RxSwift
import Kingfisher

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    private var viewModel: PhotosViewModel?
    private lazy var router = {
        return PhotosRoutes(view: self.viewModel)
    }
    private let disposeBag = DisposeBag()

    private var noMoreDataToFecth: Bool = false // We avoid continuous request when there's not data to fetch
    
    /// This is to show how we can create a initializer, in a upgraded version that uses
    /// dependency injection this would be there
    class func controller(parameter id: Int, provider: PinchProvider) -> PinchResult<PhotosViewController> {
        guard let vc = PhotosViewController.loadController() as? PhotosViewController else {
            return .failure(.appError(string: "Can't load your photos list"))
        }
        vc.viewModel = PhotosViewModel(id: id, provider: provider)
        return .success(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        retrieveData()
    }
    
    private func setupUI() {
        loadingIndicator.hidesWhenStopped = true
        pullToRefresh()
    }

    private func retrieveData(nextPage: Bool = false) {
        tableView.showBottomLoading(nextPage, loadingIndicator: self.loadingIndicator)
        
        viewModel?.retrievePhotos(nextPage: nextPage)
            .subscribe { event in
            self.tableView.showBottomLoading(false, loadingIndicator: self.loadingIndicator)
            switch event {
            case .completed:
                self.tableView.reloadData()
            case .error(let error):
                self.noMoreDataToFecth = true
                guard let pinchError = error as? PinchError else { return }
                self.showError(with: pinchError)
            }
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Table View
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.viewModel?.show(photos: indexPath.row).success { [weak self] _ in
            guard let `self` = self else { return .failure(PinchError.invalidData) }
            return self.router().route(to: .photo, from: self)
        }.failure { [weak self] error in
            /// If we have failure we show
            self?.showError(with: error)
        }
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.currentCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = self.viewModel else { return }
        let currentCountToDisplay = viewModel.currentCount - 1
        
        /// We should evaluate that is not 0 otherwise we could end in a loop request situation
        if currentCountToDisplay > 0, indexPath.row >= currentCountToDisplay, !noMoreDataToFecth {
            // A small delay it's good to avoid to fast user scroll and continous calls
            delay(0.2) {
                self.retrieveData(nextPage: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let viewModel = self.viewModel, let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.reusable) as? PhotoTableViewCell else { return UITableViewCell() }
        cell.setup(with: viewModel.photo(at: indexPath.row))
        
        return cell
    }
    
    // MARK: Table View Prefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let urls = viewModel?.lastPhotos?.compactMap({ URL(string: $0.thumbnailUrl) }) else { return }
        ImagePrefetcher(urls: urls).start()
    }
    
    // MARK: UI
    func pullToRefresh(){

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleTopRefresh(_:)), for: .valueChanged )
        refresh.tintColor = UIColor.green
        self.tableView.refreshControl = refresh
    }
    
    @objc func handleTopRefresh(_ sender:UIRefreshControl){
        self.noMoreDataToFecth = false
        self.retrieveData()
        sender.endRefreshing()
    }
    
}
