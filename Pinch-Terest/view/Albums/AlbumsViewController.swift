//
//  AlbumViewController.swift
//  Pinch-Terest
//
//  Created by Felipe Florencio Garcia on 07/10/2020.
//

import UIKit
import RxSwift

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    private let viewModel = AlbumsViewModel(provider: PinchProvider())
    private lazy var router = {
        return AlbumsRoutes(view: self.viewModel)
    }
    
    private var noMoreDataToFecth: Bool = false

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        retrieveData()
    }
    
    private func setupUI() {
        loadingIndicator.hidesWhenStopped = true
        pullToRefresh()
        
        self.viewModel.hasFilter.subscribe { [weak self] _ in
            self?.tableView.refreshControl?.beginRefreshingManually()
            self?.noMoreDataToFecth = false
            self?.retrieveData(nextPage: false)
        }.disposed(by: disposeBag)
    }

    private func retrieveData(nextPage: Bool = false) {
        tableView.showBottomLoading(nextPage, loadingIndicator: self.loadingIndicator)
                
        viewModel.retrieveAlbums(nextPage: nextPage)
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
    
    @IBAction func filter(_ sender: UIButton) {
        self.showFilter()
    }
    
    // MARK: - Table View
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.show(photos: indexPath.row).success { [weak self] _ in
            guard let `self` = self else { return .failure(PinchError.invalidData) }
            return self.router().route(to: .photos, from: self)
        }.failure { [weak self] error in
            /// If we have failure we show
            self?.showError(with: error)
        }
    }
    
    // MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.currentCount
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCountToDisplay = self.viewModel.currentCount - 1
        
        /// We should evaluate that is not 0 otherwise we could end in a loop request situation
        if currentCountToDisplay > 0, indexPath.row >= currentCountToDisplay, !noMoreDataToFecth {
            delay(0.2) {
                self.retrieveData(nextPage: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reusable) as? AlbumTableViewCell else { return UITableViewCell() }
        cell.setup(with: viewModel.album(at: indexPath.row))
        
        return cell
    }
    
    // MARK: - UI
    private func showFilter() {
        let alertController = UIAlertController(title: "Options", message: "Choose one option for filtering", preferredStyle: .actionSheet)
        self.viewModel.filters.forEach { filter in
            let action = UIAlertAction(title: filter.description, style: .default, handler: { action in
                guard let option = self.viewModel.filters.first(where: { $0.description.lowercased() == action.title?.lowercased() }) else { return }
                self.viewModel.filter(using: option)
            })
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Clear", style: .default, handler: { action in
            self.viewModel.filter(using: .none)
        }))

        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func pullToRefresh(){

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

