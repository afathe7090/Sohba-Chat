//
//  SCMessagesDataSource.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//

import MessageKit
import UIKit

extension SCMessageVC: MessagesDataSource {
    
    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    
    
    
    
    

    //MARK: - Cell Top Label
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        // before 3 section we will put the data of the messages and Pull to reload and get anuther messages
        if indexPath.section % 3 == 0 {
            
            // return true or fulse for show Load more
            let showLoadMore = (indexPath.section == 0 ) && (allLocalMessage.count > displayingMessageCount)
            
            // the text if the label pull or data of the messages
            let text = showLoadMore ? "Pull To Load More":MessageKitDateFormatter.shared.string(from: message.sentDate)
            
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13):UIFont.systemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue:UIColor.darkGray
            
            return NSAttributedString(string: text, attributes: [.font: font , .foregroundColor: color])
        }
        
        return nil
    }
    
    
    
    
    
    
    //MARK: - statues Message
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        // sender message Statues under the messages
        if isFromCurrentSender(message: message){
            
            let message = mkMessages[indexPath.section]
            
            // put the statues and time For the last message 
            let statues = indexPath.section == mkMessages.count - 1 ? message.status + " " + message.readDate.time():""
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            return NSAttributedString(string: statues, attributes: [.font: font , .foregroundColor: color])
        }
        
        return nil
    }
    
    
    
    
    
    //MARK: - message Buttom
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section != mkMessages.count - 1 {
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.time(), attributes: [.font: font , .foregroundColor: color ])
        }
        return nil
    }
}



//MARK: - Message Channel
extension SCMessageChannelVC: MessagesDataSource {
    
    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    
    
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    
    
    
    
    //MARK: - Cell Top Label Channel
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        // before 3 section we will put the data of the messages and Pull to reload and get anuther messages
        if indexPath.section % 3 == 0 {
            
            // return true or fulse for show Load more
            let showLoadMore = (indexPath.section == 0 ) && (allLocalMessage.count > displayingMessageCount)
            
            // the text if the label pull or data of the messages
            let text = showLoadMore ? "Pull To Load More":MessageKitDateFormatter.shared.string(from: message.sentDate)
            
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13):UIFont.systemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue:UIColor.darkGray
            
            return NSAttributedString(string: text, attributes: [.font: font , .foregroundColor: color])
        }
        
        return nil
    }
    
    
    
    
    
    
    
    //MARK: - message Buttom
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
                    
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.time(), attributes: [.font: font , .foregroundColor: color ])
    }
}
