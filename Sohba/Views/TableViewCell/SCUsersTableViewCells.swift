//
//  SCUsersTableViewCells.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 04/07/2021.
//

import UIKit

class SCUsersTableViewCells: UITableViewCell {
    //MARK: - OUtlet
    
    @IBOutlet weak var usersNames: UILabel!
    
    @IBOutlet weak var statusLabelOutlet: UILabel!
    @IBOutlet weak var avatarUsers: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(user: User){
        
        usersNames.text = user.username
        statusLabelOutlet.text = user.status
        
        if user.avatarLink != "" {
            FileStorage.downloadImage(imageURL: user.avatarLink) { avatarImage in
                self.avatarUsers.image = avatarImage?.circleMasked
            }
        }else{
            self.avatarUsers.image = UIImage(named: "avatar")
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
