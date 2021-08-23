//
//  SCBaseTabBarController.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 02/07/2021.
//

import UIKit

class SCBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBarContoller()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    
    //MARK: - Controllers
    
    
    private func configureTabBarContoller(){
        
        
        let SCChat = SCChatsStoryboard.instantiateViewController(withIdentifier: "SCChatVC") as! SCChatVC
        let chatVC = UINavigationController(rootViewController: SCChat)
        chatVC.tabBarItem.image = UIImage(systemName: "message")
        chatVC.tabBarItem.title = "Chats"
        
        
        let SCchannel = SCChannelStoryboard.instantiateViewController(withIdentifier: "SCChannelsVC") as! SCChannelsVC
        let channelVC = UINavigationController(rootViewController: SCchannel)
        channelVC.tabBarItem.image = UIImage(systemName: "quote.bubble")
        channelVC.tabBarItem.title = "Channels"
        
        
        let users = SCUserStoryboard.instantiateViewController(withIdentifier: "SCUsersVC") as! SCUsersVC
        let usersVC = UINavigationController(rootViewController: users)
        usersVC.tabBarItem.image = UIImage(systemName: "person.2")
        usersVC.tabBarItem.title = "Users"
        
        let settings = SCSettingStorboard.instantiateViewController(withIdentifier: "SCSettingsVC") as! SCSettingsVC
        let settingVC = UINavigationController(rootViewController: settings)
        settingVC.tabBarItem.image = UIImage(systemName: "gear")
        settingVC.tabBarItem.title = "Settings"
        
        
        self.viewControllers = [chatVC ,channelVC , usersVC , settingVC ]
    }
  
 
    
}
