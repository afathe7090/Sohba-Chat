//
//  LocalMessage.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//

import Foundation
import RealmSwift

class LocalMessage: Object , Codable{
    
   @objc dynamic var id = ""
   @objc dynamic var chatRoomId = ""
   @objc dynamic var senderId = ""
   @objc dynamic var senderName = ""
   @objc dynamic var date = Date()
   @objc dynamic var senderInitials = ""
   @objc dynamic var readDate = Date()
   @objc dynamic var type = ""
   @objc dynamic var status = ""
   @objc dynamic var messeage = ""
   @objc dynamic var audioUrl = ""
   @objc dynamic var videoUrl = ""
   @objc dynamic var pictureUrl = ""
   @objc dynamic var latidute = 0.0
   @objc dynamic var longtude = 0.0
   @objc dynamic var audioDuration = 0.0
    
    override class func primaryKey()-> String {
        return "id"
    }
    
}
