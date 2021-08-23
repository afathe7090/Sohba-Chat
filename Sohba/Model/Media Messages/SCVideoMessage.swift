//
//  SCVideoMessage.swift
//  Sohba
//
//  Created by Ahmed Fathy on 14/07/2021.
//


import Foundation
import MessageKit

class VideoMessage: NSObject , MediaItem {
    
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    
    init(url: URL?){
        self.url = url
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
    
}
