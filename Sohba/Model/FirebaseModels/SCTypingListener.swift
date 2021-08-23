//
//  SCTypingListener.swift
//  Sohba
//
//  Created by Ahmed Fathy on 14/07/2021.
//

import Foundation
import Firebase

class FTypingListener {
    
    static let shared = FTypingListener()
    
    var typingListener: ListenerRegistration!
    
    
    private init(){}
    
    
    func creatTypingIndicator(chatRoomId: String, compeltion: @escaping(_ isTyping: Bool)-> Void){
        
        typingListener = FirestoreReference(.Typing).document(chatRoomId).addSnapshotListener({ documentSnapshot, error in
            
            guard let snapshot = documentSnapshot else{return}
            
            if snapshot.exists{
                
                for data in snapshot.data()!{
                    
                    if data.key != User.currentId{
                        
                        compeltion(data.value as! Bool)
                        
                    }
                }
                
            }else{
                compeltion(false)
                FirestoreReference(.Typing).document(chatRoomId).setData([User.currentId: false])
        }
        })
}


    class func saveTypingCounter(typing:Bool, chatRoomId: String){
        
        FirestoreReference(.Typing).document(chatRoomId).updateData([User.currentId: typing])
    }
    
    
    
    
    func removeTypingListener(){
        self.typingListener.remove()
    }
    
}
