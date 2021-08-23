//
//  SCInputBarAccessoryViewDelegate.swift
//  Sohba
//
//  Created by Ahmed Fathy on 07/07/2021.
//

import Foundation
import InputBarAccessoryView

extension SCMessageVC: InputBarAccessoryViewDelegate {
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        configureUpdateMicBtnStatus(show: text == "")
        
        if text != ""{
            startTypingCounter()
        }
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, location: nil, audio: nil)
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
        
    }
}





extension SCMessageChannelVC: InputBarAccessoryViewDelegate {
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        configureUpdateMicBtnStatus(show: text == "")
        
        
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, location: nil, audio: nil)
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
        
    }
}

