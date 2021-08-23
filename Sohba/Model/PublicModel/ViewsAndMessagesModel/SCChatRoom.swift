//
//  SCChatRoom.swift
//  Sohba
//
//  Created by Ahmed Fathy on 06/07/2021.
//

import UIKit
import FirebaseFirestoreSwift


struct ChatRoom: Codable {
    
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    
    @ServerTimestamp var date = Date()
    
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
    
}
