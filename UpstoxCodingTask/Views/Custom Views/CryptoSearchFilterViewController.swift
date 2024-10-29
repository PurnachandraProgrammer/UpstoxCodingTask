//
//  CryptoSearchFilterViewController.swift
//
//  Created by Purnachandra on 11/10/24.
//

import UIKit

class CryptoSearchFilterViewController: UIViewController {

    // Have Model class to preserve
    var cryptoCoinsListViewModel: CryptoCoinsListViewModel!
    
    // Create the search filter button in modal view.
    let activeCoinsButtonView = ButtonView(title: "Active Coins")
    let inActiveCoinsButtonView = ButtonView(title: "InActive Coins")
    let onlyTokensButtonView = ButtonView(title: "Only Tokens")
    let onlyCoinsButtonView = ButtonView(title: "Only Coins")
    let newCoinsButtonView = ButtonView(title: "New Coins")

    func setUpView() {
     
        view.backgroundColor = .clear
        
        let filterModel = cryptoCoinsListViewModel.filterModel
        
        let topStackView = UIStackView(arrangedSubviews:[activeCoinsButtonView,inActiveCoinsButtonView,onlyTokensButtonView])
        topStackView.axis = .horizontal
        topStackView.distribution = .fillProportionally
        topStackView.spacing = 10.0
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomStackView = UIStackView(arrangedSubviews:[onlyCoinsButtonView ,newCoinsButtonView])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillProportionally
        bottomStackView.spacing = 10.0
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalStackView = UIStackView(arrangedSubviews: [topStackView,bottomStackView])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 10.0
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(verticalStackView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set static constraints
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
            verticalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            verticalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            verticalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        // Set dynamic constraints
        // First, set container to default height
        // after panning, the height can expand
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        
        // By setting the height to default height, the container will be hide below the bottom anchor view
        // Later, will bring it up by set it to 0
        // set the constant to default height to bring it down again
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        activeCoinsButtonView.isButtonSelected = filterModel.isActiveCoin
        activeCoinsButtonView.buttonSelected()
        
        inActiveCoinsButtonView.isButtonSelected = filterModel.isInActiveCoin
        inActiveCoinsButtonView.buttonSelected()

        onlyTokensButtonView.isButtonSelected = filterModel.isOnlyTokens
        onlyTokensButtonView.buttonSelected()

        onlyCoinsButtonView.isButtonSelected = filterModel.isOnlyCoins
        onlyCoinsButtonView.buttonSelected()

        newCoinsButtonView.isButtonSelected = filterModel.isNewCoins
        newCoinsButtonView.buttonSelected()
        
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // Constants
    let defaultHeight: CGFloat = 150
    let dismissibleHeight: CGFloat = 200
    let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    // keep current new height, initial is default height
    var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)

    }
    
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
    
    // MARK: Present and dismiss animation
    func animatePresentContainer() {
        // update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide blur view
        
        cryptoCoinsListViewModel.filterModel.isActiveCoin = activeCoinsButtonView.isButtonSelected
        cryptoCoinsListViewModel.filterModel.isInActiveCoin = inActiveCoinsButtonView.isButtonSelected
        cryptoCoinsListViewModel.filterModel.isOnlyTokens = onlyTokensButtonView.isButtonSelected
        cryptoCoinsListViewModel.filterModel.isOnlyCoins = onlyCoinsButtonView.isButtonSelected
        cryptoCoinsListViewModel.filterModel.isNewCoins = newCoinsButtonView.isButtonSelected
        
        cryptoCoinsListViewModel.updateSearchFilters()

        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
}
