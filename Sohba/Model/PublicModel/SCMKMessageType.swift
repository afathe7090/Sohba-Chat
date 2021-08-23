//
//  SCMessageType.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//

import CoreLocation
import Foundation
import MessageKit

class  MKMessage: NSObject, MessageType {
    
    
    var messageId: String
    
    var kind: MessageKind
    
    var sentDate: Date
    
    var mkSender: MKSender
    
    var sender: SenderType {return mkSender}
    
    var senderInitials: String
    
    var status: String
    
    var readDate: Date
        
    var inComing: Bool
    
    var photoItem: PhotoMessage?
    var videoItem: VideoMessage?
    var locationItem: LocationItem?
    var audioItem: AudioMessage?
    
    init(message: LocalMessage){
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = MessageKind.text(message.messeage)
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.inComing = User.currentId != mkSender.senderId
        
        
        
         
        
        switch message.type {
        
        case kTEXT:
            
            self.kind = MessageKind.text(message.messeage)
        case kPHOTO:
            
            let photoItem = PhotoMessage(path: message.pictureUrl)
            self.kind = MessageKind.photo(photoItem)
            self.photoItem = photoItem
            
        case kVIDEO:
            
            let videoItem = VideoMessage(url: nil)
            self.kind = MessageKind.video(videoItem)
            self.videoItem = videoItem
            
        case kLOCATION:
            
            let locationItem = LocationMessage(location: CLLocation(latitude: message.latidute, longitude: message.longtude))
            
            self.kind = MessageKind.location(locationItem)
            self.locationItem = locationItem
                        
            
        case kAOUDIO:
            
            let audioItem = AudioMessage(duration: 2.0)
            self.kind = MessageKind.audio(audioItem)
            self.audioItem = audioItem
            
            
        default:
            
            self.kind = MessageKind.text(message.messeage)
            print("Unkown Error")
        }
        
    }
    
}

