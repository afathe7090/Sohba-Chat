//
//  SCChatRoomListener.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//

import Foundation


class FChatRoomListener {
    
    static let shared = FChatRoomListener()
    
    private init() {}
    
    
    //MARK: -  save Chat Room  Firebase
    
    func saveChatRoomFirebase(_ chatRoom: ChatRoom){
        
        do{
            try FirestoreReference(.Chat).document(chatRoom.id).setData(from: chatRoom)
        }catch {
            print("No able to save chatRoom ")
        }
        
    }
    
    
    
    
    //MARK: -  download All users chatRoom
    
    func downloadChatRooms(compeletion:@escaping (_ allFBChatRooms : [ChatRoom])-> Void ){
        
        FirestoreReference(.Chat).whereField(kSENDERID , isEqualTo: User.currentId).addSnapshotListener { snapshot, error in
            
            var chatRooms: [ChatRoom] = []
            
            guard let documents = snapshot?.documents else{
                print("No Documents Found")
                return
            }
            
            let allFBChatRooms  = documents.compactMap { snapshot -> ChatRoom? in
                return try? snapshot.data(as: ChatRoom.self)
            }
            
            for chatRoom in allFBChatRooms {
                
                if chatRoom.lastMessage != "" {
                    chatRooms.append(chatRoom)
                }
            }
            
            chatRooms.sort(by: {$0.date! > $1.date!})
            
            compeletion(chatRooms)
        }
    }
    
    //MARK: - Delete function
    
    
    func deleteChatRoom(_ chatRoom: ChatRoom){
        
        FirestoreReference(.Chat).document(chatRoom.id).delete()
    }
    
    
    
    //MARK: - reset unread Counter
    
    func clearUnReadCounter(chatRoom: ChatRoom){
        
        var newChatRoom = chatRoom
        
        newChatRoom.unreadCounter = 0
        self.saveChatRoomFirebase(newChatRoom)
    }
    
    
    
    
    func clearUnReadCounterUsingChatRoomId(chatRoomId: String){
        
        FirestoreReference(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentId).getDocuments { querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{return}
            
            let allChatRooms = documents.compactMap {querySnapshot -> ChatRoom?  in
                
                return try? querySnapshot.data(as: ChatRoom.self)
            }
            
            if allChatRooms.count > 0 {
                self.clearUnReadCounter(chatRoom: allChatRooms.first!)
            }
        }
    }
    
    
    
    //MARK: - Updata chat room with New message
    
    private func updateChatRoomWithNewMessage(chatRoom: ChatRoom, lastMessage: String){
        
        var tempChatRoom = chatRoom
        
        if tempChatRoom.senderId != User.currentId{
            
            tempChatRoom.unreadCounter += 1
        }
        
        tempChatRoom.lastMessage = lastMessage
        tempChatRoom.date = Date()
        self.saveChatRoomFirebase(tempChatRoom)
    }
    
    
    func updateChatRooms(chatRoomId: String , lastMessage: String ){
        
        FirestoreReference(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { querySnaphot, error in
            guard let documents = querySnaphot?.documents else{return}
            
            let allChatRoom = documents.compactMap { querySnaphot -> ChatRoom? in
                return try? querySnaphot.data(as: ChatRoom.self)
            }
            
            for chatRoom in allChatRoom{
                self.updateChatRoomWithNewMessage(chatRoom: chatRoom, lastMessage: lastMessage)
            }
        }
    }
    
}
