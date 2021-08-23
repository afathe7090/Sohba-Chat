//
//  SCFChannelListener.swift
//  Sohba
//
//  Created by Ahmed Fathy on 21/07/2021.
//

import Foundation
import Firebase

class FChannelListener{
    
    //---> Singlton
    static let shared = FChannelListener()
    
    var usersChannelListener: ListenerRegistration!
    var subscribedChannelListener: ListenerRegistration!
    
    private init(){}
    
    //MARK: - add Channels
    
    
    func saveChannel(_ channel: Channel){
        
        do{
            try FirestoreReference(.channel).document(channel.id).setData(from: channel)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    
    //MARK: - Download Channel
    
    func downloadUserChannels(completion: @escaping(_ userChannel: [Channel])-> Void){
        
        usersChannelListener = FirestoreReference(.channel).whereField(kAdMINID, isEqualTo: User.currentId).addSnapshotListener({ querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{return}
            
            var userChannels = documents.compactMap{ queryDocumenSnapshot -> Channel? in
                return try? queryDocumenSnapshot.data(as: Channel.self)
            }
            
            userChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            
            completion(userChannels)
        })
    }
    
    
    func downloadSubsribedChannels(completion: @escaping(_ userChannel: [Channel])-> Void){
        
        subscribedChannelListener = FirestoreReference(.channel).whereField(kMEMBERIDS, arrayContains: User.currentId).addSnapshotListener({ querySnapshot, error in
            
            guard let documents = querySnapshot?.documents else{return}
            
            var subscribesChannels = documents.compactMap{ queryDocumenSnapshot -> Channel? in
                return try? queryDocumenSnapshot.data(as: Channel.self)
            }
            
            subscribesChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            
            completion(subscribesChannels)
        })
    }
    
    
    func downloadAllChannels(completion: @escaping(_ userChannel: [Channel])-> Void){
        
        FirestoreReference(.channel).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            
            var allChannels = documents.compactMap { queryDocumenSnapshot-> Channel? in
                return try? queryDocumenSnapshot.data(as: Channel.self)
            }
            
            allChannels = self.removeUserChannel(allChannels)
            allChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            
            completion(allChannels)
        }
    }
    
    //MARK: - Helper
    
    func removeUserChannel(_ allChannels: [Channel])-> [Channel]{
        var newChannel: [Channel] = []
        
        for channel in allChannels{
            if !channel.memberIds.contains(User.currentId){
                
                newChannel.append(channel)
            }
        }
        return newChannel
    }
      
    
}
