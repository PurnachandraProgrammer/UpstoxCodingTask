//
//  CityListTableViewCell.swift
//  CheqJSONKeepApp
//
//  Created by Purnachandra on 09/09/24.
//

import UIKit

class CryptoCoinDetailsTableViewCell : UITableViewCell {

    private let coinNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let coinTypeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()

    private let coinImageView : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "crypto-coin"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let coinNewImageView : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "new-icon"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()

    
    private let verticalStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        verticalStackView.addArrangedSubview(coinNameLabel)
        verticalStackView.addArrangedSubview(coinTypeLabel)
        
        contentView.addSubview(verticalStackView)
        contentView.addSubview(coinImageView)
        contentView.addSubview(coinNewImageView)

        coinImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        coinImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        coinImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        coinImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        
        coinNewImageView.heightAnchor.constraint(equalTo: coinImageView.heightAnchor).isActive = true
        coinNewImageView.widthAnchor.constraint(equalTo: coinImageView.widthAnchor).isActive = true
        coinNewImageView.centerYAnchor.constraint(equalTo: coinImageView.centerYAnchor).isActive = true
        coinNewImageView.trailingAnchor.constraint(equalTo: coinImageView.trailingAnchor).isActive = true

        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
        verticalStackView.trailingAnchor.constraint(greaterThanOrEqualTo: coinImageView.leadingAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(coinObject:CryptoCoin) {
        
        coinNameLabel.text = coinObject.name
        coinTypeLabel.text = coinObject.symbol
        coinNewImageView.isHidden = !coinObject.isNew
        
        if coinObject.isActive {
            switch coinObject.type {
            case .coin:
                coinImageView.image = UIImage(named: "coin-active")
                
            case .token:
                coinImageView.image = UIImage(named: "token-active")
                
            }
        }
        else {
            coinImageView.image = UIImage(named: "crypto-inactive")
        }
        
    }
}
