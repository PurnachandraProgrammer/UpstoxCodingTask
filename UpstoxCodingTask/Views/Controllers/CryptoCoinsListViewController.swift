//
//  CryptoCoinsListViewController.swift
//
//  Created by Purnachandra on 11/10/24.
//

import UIKit

let cryptoCoinCellIdentifier = "CryptoCoinCellIdentifier"

class CryptoCoinsListViewController: UIViewController {
    
    let cryptoCoinsList:Dynamic<[CryptoCoin]?> = Dynamic([])
    var isSearchBarShown = false
    var cryptoCoinsListViewModel = CryptoCoinsListViewModel(cryptoCoinRepository: CryptoCoinRepository(apiService: CryptoCoinApiListService(), coreDataService:CryptoDataService(), networkManager: NetworkManager()))
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        return refreshControl
    }()
    
    lazy var cryptoCoinsListTableView: UITableView =  {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = nil
        tableView.allowsSelection = false
        tableView.register(CryptoCoinDetailsTableViewCell.self, forCellReuseIdentifier: cryptoCoinCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var searchController:UISearchController = {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .gray
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.searchTextField.backgroundColor = .white
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    
    
    override func loadView() {
        super.loadView()
        setUpView()
    }
    
    func setUpView() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search-icon"), style: .plain, target: self, action:#selector(CryptoCoinsListViewController.showHideSearchBar))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action:#selector(CryptoCoinsListViewController.showSearchFilterView))
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        cryptoCoinsListTableView.addSubview(refreshControl) // not required when using UITableViewController

        view.addSubview(cryptoCoinsListTableView)
        view.addSubview(activityIndicator)
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            .isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            .isActive = true
        
        cryptoCoinsListTableView.topAnchor.constraint(equalTo: self.view.topAnchor)
            .isActive = true
        cryptoCoinsListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            .isActive = true
        cryptoCoinsListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            .isActive = true
        cryptoCoinsListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            .isActive = true
    }
    
    @objc func refresh(_ sender: AnyObject) {
        Task {
            await cryptoCoinsListViewModel.fetchCryptoCoinsList()
        }
    }
    @objc func showHideSearchBar() {
        UIView.animate(withDuration: 0) { [unowned self] in
            
            if isSearchBarShown {
                cryptoCoinsListTableView.tableHeaderView = nil
            }
            else {
                //navigationItem.searchController = self.searchController
                cryptoCoinsListTableView.tableHeaderView = self.searchController.searchBar
                self.searchController.searchBar.isHidden = false

                UIView.animate(withDuration: 0.3) {
                    self.cryptoCoinsListTableView.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
                }
            }
            isSearchBarShown = !isSearchBarShown
        }
        return
    }
    
    
    
    fileprivate func initWithBinding() {
        cryptoCoinsListViewModel.filteredCryptoCoinsList.bind { cryptoCoinsList in
            
            DispatchQueue.main.async { [weak self] in
                self?.cryptoCoinsListTableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                self?.activityIndicator.isHidden = true
            }
            return
        }
        
        cryptoCoinsListViewModel.apiFetchError.bind { error in
            
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(for: (error as NSError))
                    self?.cryptoCoinsListTableView.tableHeaderView = nil
                    self?.refreshControl.endRefreshing()
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                }
                return
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
        
        Task {
            await cryptoCoinsListViewModel.fetchCryptoCoinsList()
        }
    }
    
    override func viewDidLoad() {
        
        initTitle()
        initWithBinding()
        super.viewDidLoad()
    }
    
    private func initTitle() {
        self.title = AppConstants.rootViewControllerTitle
        navigationController?.navigationBar.tintColor = AppConstants.orangeColor
    }
    
    func showAlert(for error: NSError) {
        // Present the alert on the main thread
        let alert = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showSearchFilterView() {
        let vc = CryptoSearchFilterViewController()
        //vc.filterModel = cryptoCoinsListViewModel.filterModel
        vc.cryptoCoinsListViewModel = cryptoCoinsListViewModel
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: false)
    }
}

extension CryptoCoinsListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoCoinsListViewModel.getNumberOfCoins()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cryptoCoinCellIdentifier) as! CryptoCoinDetailsTableViewCell
        let object = cryptoCoinsListViewModel.getCryptoCoin(index: indexPath.row)
        cell.configure(coinObject: object)
        return cell
    }
}

extension CryptoCoinsListViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.cryptoCoinsListViewModel.filterContentForSearchText(searchBar.text!)
    }
}

extension CryptoCoinsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        self.cryptoCoinsListViewModel.filterContentForSearchText(searchBar.text!)
    }
}

extension CryptoCoinsListViewController : UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.cryptoCoinsListTableView.tableHeaderView = nil
            self?.isSearchBarShown = false
            self?.cryptoCoinsListTableView.reloadData()
        }
    }

}

