//
//  SCChannelCell.swift
//  Sohba
//
//  Created by Ahmed Fathy on 17/07/2021.
//

import UIKit

class SCChannelCell: UITableViewCell {
    
    //MARK: - Outlets
    
    
    @IBOutlet weak var avatarUser: UIImageView!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var aboutChannelLabel: UILabel!
    @IBOutlet weak var numberMembersOfChannel: UILabel!
    @IBOutlet weak var dateOflastMessage: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureChannel(channel: Channel){
        
        self.channelNameLabel.text = channel.name
        self.aboutChannelLabel.text = channel.aboutChannel
        self.numberMembersOfChannel.text = "\(channel.memberIds.count) members"
        self.dateOflastMessage.text = timeElapsed(channel.lastMessageDate ?? Date())
        
        
        if channel.avatarLink != "" {
            
            FileStorage.downloadImage(imageURL: channel.avatarLink) { avatarImage in
                DispatchQueue.main.async {
                    self.avatarUser.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "avatar")
                }
            }
        }else {
            self.avatarUser.image = UIImage(named: "avatar")
        }
        
        
        
    }
    
    

}
