//
//  SCIncoming.swift
//  Sohba
//
//  Created by Ahmed Fathy on 09/07/2021.
//

import Foundation
import MessageKit
import CoreLocation

class InComing{
    
    var messageViewController: MessagesViewController
    
    init(messageViewController: MessagesViewController) {
        self.messageViewController = messageViewController
    }
    
    
    func creatMessageKit(localMessage: LocalMessage) -> MKMessage{
        
        let mkMessage = MKMessage(message: localMessage)
        
        if localMessage.type == kPHOTO{
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FileStorage.downloadImage(imageURL: localMessage.pictureUrl) { image in
                mkMessage.photoItem?.image = image
                
            }
            self.messageViewController.messagesCollectionView.reloadData()
        }
        
        
        if localMessage.type == kVIDEO{
            
            FileStorage.downloadImage(imageURL: localMessage.pictureUrl) { tumpnail in
                
                FileStorage.downloadVideo(videoUrl: localMessage.videoUrl) { readyToPlay, filename in
                    
                    let videoLink = URL(fileURLWithPath: fileInDocumentsDirecutury(fileName: filename))
                    let videoItem = VideoMessage(url: videoLink)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    
                    mkMessage.videoItem?.image = tumpnail
                    
                    self.messageViewController.messagesCollectionView.reloadData()
                    
                }
            }
        }
        
        
        if localMessage.type == kLOCATION{
            
            let locationItem = LocationMessage(location: CLLocation(latitude: localMessage.latidute, longitude: localMessage.longtude))
            
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
        }
        
        
        
        if localMessage.type == kAOUDIO {
            
            let audioMessage = AudioMessage(duration: Float(localMessage.audioDuration))
            
            mkMessage.audioItem = audioMessage
            mkMessage.kind = MessageKind.audio(audioMessage)

            FileStorage.downloadAudio(audioUrl: localMessage.audioUrl) { (fileName) in
                
                let audioURL = URL(fileURLWithPath: fileInDocumentsDirecutury(fileName: fileName))

                mkMessage.audioItem?.url = audioURL
                
                
            }
            self.messageViewController.messagesCollectionView.reloadData()
            
            
        }
        
        
        return mkMessage
    }
    
}
