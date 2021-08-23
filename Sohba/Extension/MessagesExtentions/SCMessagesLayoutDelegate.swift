//
//  SCMessageVCExtension.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//


import MessageKit
import Foundation

extension SCMessageVC: MessagesLayoutDelegate {
        
    //MARK: - Cell top label Height
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        
        if indexPath.section % 3 == 0{
            // TODO Set Defualt Size
            if (indexPath.section == 0 ) && (allLocalMessage.count > displayingMessageCount) {
                
                return 40
            }
        }
        
        return 20
    }
    
    
    
    //MARK: - cell Statues Buttom label height
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return isFromCurrentSender(message: message) ? 17:0
        
    }
    
    
    //MARK: - cell buttom
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return indexPath.section != mkMessages.count - 1 ? 10:0
    }
    
    //MARK: - Avatar
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
        
    }
    
    
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return UIColor.label
    }
    
}



extension SCMessageChannelVC: MessagesLayoutDelegate {
        
    //MARK: - Cell top label Height
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        
        if indexPath.section % 3 == 0{
            // TODO Set Defualt Size
            if (indexPath.section == 0 ) && (allLocalMessage.count > displayingMessageCount) {
                
                return 40
            }
        }
        
        return 20
    }
    
    
    
    //MARK: - cell Statues Buttom label height
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 10
        
    }
    
    
    //MARK: - Avatar
    
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
        
    }
    
    
    func audioTintColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return UIColor.label
    }
    
}

