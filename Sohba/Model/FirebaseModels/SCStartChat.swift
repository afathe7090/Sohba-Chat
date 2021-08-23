//
//  SCStartChat.swift
//  Sohba
//
//  Created by Ahmed Fathy on 06/07/2021.
//

import Foundation
import Firebase

//MARK: - restart chat

func restartChatRoom(chatRoomId: String ,memberIds: [String]){
    
    //download user Using MemberIds
    
    FUserListener.shared.downloadUsersFromFirestore(withIds: memberIds) { users in
        
        if users.count > 0 {
            creatChatRooms(chatRoomId: chatRoomId, users: users)
        }
    }
  
}


//MARK: -  Start Chat
func startChat(sender: User, reveiver: User)-> String{
    
    var chatRoomId = ""
    
    let value = sender.id.compare(reveiver.id).rawValue
    
    chatRoomId = value < 0 ? (sender.id + reveiver.id) : (reveiver.id + sender.id)
    
    creatChatRooms(chatRoomId: chatRoomId , users: [sender , reveiver])
    
    return chatRoomId
}


//MARK: - Creat Chat Rooms
func creatChatRooms(chatRoomId: String , users: [User]){
    // if user has ready chat room
    
    
    var usersToCreateChatsFor: [String]
    
    usersToCreateChatsFor = []
    
    for user in users {
        usersToCreateChatsFor.append(user.id)
    }
    
    
    FirestoreReference(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { QuerySnapshot, error in
        guard let snapshot = QuerySnapshot else{return}
        
        if !snapshot.isEmpty {
            
            for chatData in snapshot.documents{
                
                let currentChat = chatData.data() as Dictionary
                
                if let currentUserId = currentChat[kSENDERID] {
                    
                    if usersToCreateChatsFor.contains(currentUserId as! String) {
                        
                        usersToCreateChatsFor.remove(at: usersToCreateChatsFor.firstIndex(of: (currentUserId as! String?)!)!)
                    }
                }
            }
        }
        
        
        for userId in usersToCreateChatsFor {
            
            let senderUser = userId == User.currentId ? User.currentUser!: getRecieverFrom(users: users)
            
            let receverUser = userId == User.currentId ? getRecieverFrom(users: users):User.currentUser!
            
            let chatRoomObject = ChatRoom(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverId: receverUser.id, receiverName: receverUser.username, date: Date(), memberIds: [senderUser.id , receverUser.id], lastMessage: "", unreadCounter: 0, avatarLink: receverUser.avatarLink)
            
            
            
            FChatRoomListener.shared.saveChatRoomFirebase(chatRoomObject)
            
        }
        
        
        
    }
    
    
}


func getRecieverFrom (users: [User])-> User {
    var allUsers = users
    
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    
    return allUsers.first!
}
