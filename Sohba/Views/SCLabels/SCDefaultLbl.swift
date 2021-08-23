//
//  SCDefaultLbl.swift
//  Sohba
//
//  Created by Ahmed Fathy on 14/07/2021.
//

import UIKit

class SCDefaultLbl: UILabel {

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        //configure()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    init(x: CGFloat , y: CGFloat,width: CGFloat, height: CGFloat, fontSize: CGFloat , fontWeight: UIFont.Weight,textAlignment: NSTextAlignment){
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        
        //configure()
        
        self.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        self.adjustsFontSizeToFitWidth = false
        self.textAlignment = textAlignment
        
    }
 
    private func configure(){self.translatesAutoresizingMaskIntoConstraints = false}
}
