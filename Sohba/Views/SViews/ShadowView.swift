//
//  ShadowView.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 02/07/2021.
//

import UIKit

class ShadowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented")}
  
    
    private func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.systemTeal.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
    }
    
    
    
}
