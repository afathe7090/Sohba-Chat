//
//  SCChatsUserCell.swift
//  Sohba
//
//  Created by Ahmed Fathy on 06/07/2021.
//

import UIKit

class SCChatsUserCell: UITableViewCell {
    
    
    //MARK: - Outlet
    
    
    @IBOutlet weak var avatarUserImage: UIImageView!
    
    @IBOutlet weak var userChatsLBL: UILabel!
    
    @IBOutlet weak var dateLastMessageLbL: UILabel!
    
    @IBOutlet weak var counterUnReadMessageLbl: UILabel!
    
    @IBOutlet weak var lastMessegeLBL: UILabel!
    
    @IBOutlet weak var backCounterView: UIView!{didSet{
        backCounterView.layer.cornerRadius = 15
        
    }}
    
    
    //MARK: - Life Cicle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
     func getChatInfo(_ chat: ChatRoom){
        
        userChatsLBL.minimumScaleFactor = 0.9
        lastMessegeLBL.text = chat.lastMessage
        userChatsLBL.text = chat.receiverName
        lastMessegeLBL.numberOfLines = 2
        lastMessegeLBL.minimumScaleFactor = 0.9
        
        if chat.unreadCounter != 0 {
            counterUnReadMessageLbl.text = "\(chat.unreadCounter)"
            backCounterView.isHidden = false
        }else {
            backCounterView.isHidden = true
        }
        
        
        if chat.avatarLink != "" {
            FileStorage.downloadImage(imageURL: chat.avatarLink) { image in
                self.avatarUserImage.image = image?.circleMasked
            }
        }else{
            self.avatarUserImage.image = UIImage(named: "avatar")
        }
        
        dateLastMessageLbL.text = timeElapsed(chat.date!)
    }
    
    
    
}
