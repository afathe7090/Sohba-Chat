//
//  SCAudioMessage.swift
//  Sohba
//
//  Created by Ahmed Fathy on 16/07/2021.
//

import Foundation
import MessageKit

class  AudioMessage: NSObject , AudioItem{
    var url: URL
    var duration: Float
    var size: CGSize
    
    init(duration: Float) {
        
        self.url = URL(fileURLWithPath: "")
        self.size = CGSize(width: 200, height: 40)
        self.duration = duration
    }
    
}
