//
//  CryptoCoinsListViewController.swift
//
//  Created by Purnachandra on 11/10/24.
//

import UIKit

let cryptoCoinCellIdentifier = "CryptoCoinCellIdentifier"

class CryptoCoinsListViewController: UIViewController {
    
    let cryptoCoinsList:Dynamic<[CryptoCoin]?> = Dynamic(nil)
    var cryptoCoinsListViewModel = CryptoCoinsListViewModel(cryptoCoinListService: CryptoCoinsApiListService())
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
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
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Crypto Coins"
        searchBar.delegate = self
        tableView.tableHeaderView = searchBar
        
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        setUpView()
    }
    
    func setUpView() {
        
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
    
    override func viewDidLoad() {
        
        initTitle()
        Task {
            await fetchCryptoCoinsList()
        }
        
        super.viewDidLoad()
    }
    
    private func initTitle() {
        self.title = AppConstants.rootViewControllerTitle
        navigationController?.navigationBar.tintColor = AppConstants.orangeColor
    }
    
    func fetchCryptoCoinsList() async {
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        let (_,error) = await cryptoCoinsListViewModel.fetchCryptoCoinsList()
        
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.cryptoCoinsListTableView.reloadData()
        }
        
        if let error = error {
            self.showAlert(for: (error as NSError))
            return
        }
    }
    
    func showAlert(for error: NSError) {
        
        let alert = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert on the main thread
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
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
        cryptoCoinsListViewModel.getCryptoCoin(index: 0)
    }
}



