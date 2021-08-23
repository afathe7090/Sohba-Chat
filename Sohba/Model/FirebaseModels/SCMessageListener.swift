//
//  SCMessageListener.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FMessageListener{
    
    static let shared  = FMessageListener()
    
    var newMessageListener: ListenerRegistration!
    var updatedMessageListener: ListenerRegistration!
    
    
    private init(){}
    
    
    //MARK: - Add messages Firestore
    
    func addMessageFirestore(_ message: LocalMessage , memberId: String){
        
        do{
            try  FirestoreReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch{
            print("Error Saving Message" , error.localizedDescription)
        }
    }
    
    
    
    //MARK: - Send Channel
    
    func addChannelMessageFirestore(_ message: LocalMessage , channel: Channel){
        
        do{
            try  FirestoreReference(.Message).document(channel.id).collection(channel.id).document(message.id).setData(from: message)
        }catch{
            print("Error Saving Message" , error.localizedDescription)
        }
    }
    
    
    //MARK: - chack old Messages
    
    func checkForOldmessages(_ documentId: String, collectionId: String){
        
        FirestoreReference(.Message).document(documentId).collection(collectionId).getDocuments { snapshots, error in
            guard let documents = snapshots?.documents else{return}
            
            var oldMessages = documents.compactMap { (snapshots) -> LocalMessage? in
                
                return try? snapshots.data(as: LocalMessage.self)
            }
            
            oldMessages.sort(by: {$0.date < $1.date})
            
            for message in oldMessages{
                
                RealmManager.shared.save(message)
            }
        }
    }
    
    
    
    //MARK: - listen To New Messages
    
    func listenForNewMessages(_ documentId: String , collectionId: String , lastMessageDate: Date){
        
        newMessageListener = FirestoreReference(.Message).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ quresnapshot, error in
            
            guard let snapshot = quresnapshot else{return}
            
            for change in snapshot.documentChanges {
                
                if change.type == .added {
                    
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        
                        if let message = messageObject {
                            
                            if message.senderId != User.currentId{
                                
                                RealmManager.shared.save(message)
                            }
                        }
                        
                    case .failure(let error):
                        
                        print(error.localizedDescription)
                    }
                }
            }
            
        })
    }
    
    
    func removeNewMessageListner(){
        
        self.newMessageListener.remove()
        
        if updatedMessageListener != nil {
            self.updatedMessageListener.remove()
        }
        
        
    }
    
    
    
    
    //MARK: - update Message Statues
    
    func updateMessageStatues(_ message: LocalMessage , userId: String){
        
        let values = [kSTATUES: kREAD , kREADDATE: Date()] as [String:Any]
        
        FirestoreReference(.Message).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
        
        
    }
    
    
    //MARK: - listen for read message
    
    func listenForReadStatues(_ documentId: String , collectionId: String, compeletion: @escaping(_ updateMessage: LocalMessage)->Void){
        
        
        updatedMessageListener = FirestoreReference(.Message).document(documentId).collection(collectionId).addSnapshotListener({ querySnapshot, error in
            
            guard let snapshot = querySnapshot else{return}
            
            for change in snapshot.documentChanges {
                
                if change.type == .modified{
                    
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    
                    switch result{
                    
                    case .success(let messageObject):
                        if let message = messageObject {
                            compeletion(message)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                    
                }
            }
            
        })
    }
}
