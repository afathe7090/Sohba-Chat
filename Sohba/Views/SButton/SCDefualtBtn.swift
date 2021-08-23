//
//  SCDefualtBtn.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 02/07/2021.
//

import UIKit

class SCDefualtBtn: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
    
    
    init(title: String , imageBtn: String  , backgroundColor: UIColor , tintColor: UIColor , width: CGFloat ,height: CGFloat,cornerRadius: CGFloat ){
        super.init(frame: .zero)
        configure()
        
        self.setImage(UIImage(systemName: imageBtn), for: .normal)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.layer.opacity = 1
        self.layer.cornerRadius = cornerRadius
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        
    }
    
    private func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
