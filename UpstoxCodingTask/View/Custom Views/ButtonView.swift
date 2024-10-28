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

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        setUpView()
    }

    required init(title:String, imageName:String) {
        
        super.init(frame: CGRect.zero)
        super.backgroundColor = .gray
        setUpView()
        button?.setTitle(title, for: .normal)
        imageView?.image = UIImage(named:imageName)
        
        if imageView?.image == nil {
            imageView?.image = UIImage(systemName: imageName)
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeViewWithSelectedStatus))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func changeViewWithSelectedStatus() {
        
        isButtonSelected = !isButtonSelected
        
        if isButtonSelected {
            imageView?.isHidden = false
        }
        else {
            imageView?.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func buttonSelected() {
        print("the button selected")
    }
    
    func setUpView ()  {
        
        self.backgroundColor = .gray
        self.isUserInteractionEnabled = true
        
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.clipsToBounds = true
        button.isEnabled = false
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.changeViewWithSelectedStatus), for: .touchUpInside)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark")
        imageView.isHidden = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView,button])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
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

