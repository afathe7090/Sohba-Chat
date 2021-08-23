//
//  SCMessagesDisplayDelegate.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//

import Foundation
import MessageKit

extension SCMessageVC: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColorIngoing = UIColor(named: "colorIncomingBubble")
        let bubbleColorOutgoing = UIColor(named: "colorOutgoingBubble")
        
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing! :bubbleColorIngoing!
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight:.bottomLeft
        
        return .bubbleTail(tail, .curved)
    }
}





extension SCMessageChannelVC: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColorIngoing = UIColor(named: "colorIncomingBubble")
        let bubbleColorOutgoing = UIColor(named: "colorOutgoingBubble")
        
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing! :bubbleColorIngoing!
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight:.bottomLeft
        
        return .bubbleTail(tail, .curved)
    }
}
