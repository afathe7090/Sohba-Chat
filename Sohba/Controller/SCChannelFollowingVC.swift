//
//  SCChannelFollowingVC.swift
//  Sohba
//
//  Created by Ahmed Fathy on 21/07/2021.
//

import UIKit

class SCChannelFollowingVC: UITableViewController {
    
    
    //MARK: - Outlet
    
    @IBOutlet weak var avatarChannel: UIImageView!
    @IBOutlet weak var nameChannel: UILabel!
    @IBOutlet weak var numberOfMembers: UILabel!
    @IBOutlet weak var aboutChannel: UITextView!
    

    //MARK: - Constants
    
    var channel: Channel!
    
    
    
    //MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureBarButtonItem()
    }

    
    //MARK: - Actions
    
    
    @objc func followingBarButton(){
        
        channel.memberIds.append(User.currentId)
        FChannelListener.shared.saveChannel(channel)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - Functions
    private func configure(){
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        self.title = channel?.name
        self.nameChannel.text = channel?.name
        self.aboutChannel.text = channel?.aboutChannel
        self.numberOfMembers.text = "\(channel!.memberIds.count) members"
        
        if channel?.avatarLink != "" {
            FileStorage.downloadImage(imageURL: channel!.avatarLink) { image in
                
                DispatchQueue.main.async {
                    self.avatarChannel.image = image != nil ? image?.circleMasked : UIImage(named: "avatar")
                }
            }
        }else{
            self.avatarChannel.image = UIImage(named: "avatar")
        }
    }
    
    
    
    //MARK: - configure Following Bar Buttom
     
    
    private func configureBarButtonItem(){
        let followingBtn = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(followingBarButton) )
        
        navigationItem.rightBarButtonItem = followingBtn
    }
    
    
}
