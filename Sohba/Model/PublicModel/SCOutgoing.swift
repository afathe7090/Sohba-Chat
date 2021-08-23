//
//  SCOutgoing.swift
//  Sohba
//
//  Created by Ahmed Fathy on 09/07/2021.
//

import Foundation
import UIKit
import Gallery
import FirebaseFirestoreSwift

class Outgoing{
    
    class func sendMessage(chatId: String , text: String? , photo: UIImage? , audio: String? , video: Video? , audioDuration: Double = 0.0,location: String? ,memberIds: [String]){
        
        
        //1. creat local Message from the data we have
        
        let currantUser = User.currentUser!
        
        let message = LocalMessage()
        
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currantUser.id
        message.senderName = currantUser.username
        message.senderInitials = String(currantUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        //2. check the type of the message
        
        if text != nil {
            
            sendText(message: message , text: text!, memberIds: memberIds)
        }
        
        if photo != nil {
            
            sendPhoto(message: message, photo: photo!, memberIds: memberIds)
        }
        
        if video != nil {
            sendVideo(message: message, video: video!, memberIds: memberIds)
        }
        
        if location != nil {
            sendLocation(message: message, memberIds: memberIds)
        }
        
        if audio != nil {
            sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: memberIds)
        }
        
        
        //3. Save data Locally
        //4. Save data Firestore
        
                
        //TODO send Notification
        
        FChatRoomListener.shared.updateChatRooms(chatRoomId: chatId, lastMessage: message.messeage)
        
    }
    
    
    //MARK: -  Channel
    
    
    class func sendChannelMessage(channel: Channel, text: String? , photo: UIImage? , audio: String? , video: Video? , audioDuration: Double = 0.0,location: String? ){
        
        
        //1. creat local Message from the data we have
        
        let currantUser = User.currentUser!
        
        let message = LocalMessage()
        var channel = channel
        
        message.id = UUID().uuidString
        message.chatRoomId = channel.id
        message.senderId = currantUser.id
        message.senderName = currantUser.username
        message.senderInitials = String(currantUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        //2. check the type of the message
        
        if text != nil {
            
            sendText(message: message , text: text!, memberIds: channel.memberIds, channel: channel)
        }
        
        if photo != nil {
            
            sendPhoto(message: message, photo: photo!, memberIds: channel.memberIds, channel: channel)
        }
        
        if video != nil {
            sendVideo(message: message, video: video!, memberIds: channel.memberIds, channel: channel)
        }
        
        if location != nil {
            sendLocation(message: message, memberIds: channel.memberIds, channel: channel)
        }
        
        if audio != nil {
            sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: channel.memberIds, channel: channel)
        }
        
        
        //3. Save data Locally
        //4. Save data Firestore
        
                
        //TODO send Notification
        
        channel.lastMessageDate = Date()
        FChannelListener.shared.saveChannel(channel)
        
    }
    
    
    
    
    
    class func saveMessage(message: LocalMessage , memberIds: [String]){
        
        RealmManager.shared.save(message)
        
        for memberId in memberIds {
            FMessageListener.shared.addMessageFirestore(message, memberId: memberId)
        }
    }
    
    
    class func saveChannelMessages(message: LocalMessage , channel: Channel){
        
        RealmManager.shared.save(message)
        FMessageListener.shared.addChannelMessageFirestore(message,channel: channel)
    }
    
    
}



func sendText( message: LocalMessage , text: String , memberIds: [String], channel: Channel? = nil){
    
    message.messeage = text
    message.type = kTEXT
    
    if channel != nil {
        Outgoing.saveChannelMessages(message: message, channel: channel!)
    }else{
        Outgoing.saveMessage(message: message, memberIds: memberIds)
    }
    
    
}





func sendPhoto(message: LocalMessage , photo: UIImage , memberIds: [String], channel: Channel? = nil){
    
    message.messeage = "Photo Message"
    message.type = kPHOTO
    
    let fileName = Date().stringDate()
    let directory = "MediaMessage/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"
    
    FileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
    
    
    FileStorage.upLoadImage(photo, directory: directory) { imageUrl in
        
        if imageUrl != nil {
            message.pictureUrl = imageUrl!
            if channel != nil {
                Outgoing.saveChannelMessages(message: message, channel: channel!)
            }else{
                Outgoing.saveMessage(message: message, memberIds: memberIds)
            }
        }
    }
}






func sendVideo(message: LocalMessage , video: Video, memberIds: [String], channel: Channel? = nil){
    
    message.messeage = "Video Message"
    message.type = kVIDEO
    
    let fileName = Date().stringDate()
    let thumpnailDirectory = "MediaMessage/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"
    let videoDirectory = "MediaMessage/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".mov"
    
    let editor = VideoEditor()
    editor.process(video: video) { procced, videoUrl in
        
        if let tempPath = videoUrl{
            
            let thumbnail = videoThumbnail(videoURL: tempPath)
            
            FileStorage.saveFileLocally(fileData: thumbnail.jpegData(compressionQuality: 1.0 )! as NSData, fileName: fileName)
            
            FileStorage.upLoadImage(thumbnail, directory: thumpnailDirectory) { imageLink in
                
                if imageLink != nil{
                    
                    let videoData = NSData(contentsOfFile: tempPath.path)
                    FileStorage.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                    FileStorage.upLoadVideo(videoData!, directory: videoDirectory) { videoLink in
                        
                        message.videoUrl = videoLink ?? ""
                        message.pictureUrl = imageLink ?? ""
                        
                        
                        if channel != nil {
                            Outgoing.saveChannelMessages(message: message, channel: channel!)
                        }else{
                            Outgoing.saveMessage(message: message, memberIds: memberIds)
                        }
                    }
                }
            }
        }
    }
    
}


func sendLocation(message: LocalMessage , memberIds: [String], channel: Channel? = nil){
    
    let currantLocation = LocationMannager.shared.currentLocation
    message.messeage = "Location Message"
    message.type = kLOCATION
    
    message.latidute = currantLocation?.latitude ?? 0
    message.longtude = currantLocation?.longitude ?? 0
    
    Outgoing.saveMessage(message: message, memberIds: memberIds)
}


func sendAudio(message: LocalMessage ,audioFileName: String , audioDuration: Double , memberIds: [String], channel: Channel? = nil){
    
    message.messeage = "Audio Message"
    message.type = kAOUDIO
    
    let fileDirectory = "MediaMessage/Audio/" + "\(message.chatRoomId)" + "_\(audioFileName)" + ".m4a"
    
    FileStorage.uploadAudio(audioFileName, directory: fileDirectory) { audioLink in
        
        if audioLink != nil {
            message.audioUrl = audioLink ?? ""
            message.audioDuration = Double(audioDuration)
            
            if channel != nil {
                Outgoing.saveChannelMessages(message: message, channel: channel!)
            }else{
                Outgoing.saveMessage(message: message, memberIds: memberIds)
            }
        }
    }
    
    
    
}
