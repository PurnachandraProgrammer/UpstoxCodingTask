//
//  SearchFilterView.swift
//  UpstoxCodingTask
//
//  Created by Purnachandra on 12/10/24.
//

import UIKit

class ButtonView : UIView {
    
    var button:UIButton?
    var imageView:UIImageView?
    var stackView:UIStackView?
    var isButtonSelected:Bool = false
    var buttonSelectedClosure:((Bool)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        setUpView()
    }

    required init(title:String, imageName:String = "checkmark", isSelection:Bool = false) {
        
        super.init(frame: CGRect.zero)
        super.backgroundColor = .white
        setUpView()
        button?.setTitle(title, for: .normal)
        imageView?.image = UIImage(named:imageName)
        
        if imageView?.image == nil {
            imageView?.image = UIImage(systemName: imageName)
        }
        
        isButtonSelected = isSelection
        buttonSelected()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeViewWithSelectedStatus))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func buttonSelected() {
        if isButtonSelected {
            imageView?.isHidden = false
            super.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0)
        }
        else {
            imageView?.isHidden = true
            super.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0)
        }
    }
    
    @objc func changeViewWithSelectedStatus() {
        isButtonSelected = !isButtonSelected
        buttonSelected()
        self.buttonSelectedClosure?(isButtonSelected)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpView ()  {
        
        self.backgroundColor = .gray
        self.isUserInteractionEnabled = true
        
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.clipsToBounds = true
        button.isEnabled = false
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.changeViewWithSelectedStatus), for: .touchUpInside)
        let constraint = button.widthAnchor.constraint(equalToConstant: 80)
        constraint.isActive = true
        constraint.priority = .defaultLow
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark")
        imageView.isHidden = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView,button])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.button = button
        self.imageView = imageView
        self.stackView = stackView
        
        self.addSubview(stackView)
        
        self.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo:self.topAnchor, constant:0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }
    
}

