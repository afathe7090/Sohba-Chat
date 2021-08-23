//
//  SCCustomView.swift
//  Sohba
//
//  Created by Ahmed Fathy on 14/07/2021.
//

import UIKit

class SCCustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        //configure()
    }
    
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    init(width: CGFloat, height: CGFloat){
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
       // configure()
        
    }
    
    
    private func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
