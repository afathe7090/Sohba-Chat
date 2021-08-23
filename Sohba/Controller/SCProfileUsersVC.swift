//
//  SCProfileUsersVC.swift
//  Sohba
//
//  Created by Ahmed Fathy on 06/07/2021.
//

import UIKit

class SCProfileUsersVC: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var statuesUserLbl: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    
    //MARK: -  variabels
    
    var user: User?
    
    
    //MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        configureUserSetUpUI()
    }

    //MARK: - Functions
    
    
    private func configureUserSetUpUI(){
        if user != nil {
            
            self.title = user?.username
            statuesUserLbl.text = user?.status
            userName.text = user?.username
            
            if user?.avatarLink != ""{
                
                FileStorage.downloadImage(imageURL: user!.avatarLink) { avatar in
                    self.avatarImage.image = avatar?.circleMasked
                }
            }
        }
    }
    
    
    
    //MARK: - tabeView delegate
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0:5.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView()
        viewFooter.backgroundColor = UIColor(named: "colorTabelview")
        return viewFooter
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
 
            let chatId = startChat(sender: User.currentUser!, reveiver: user!)
            
            
            let privateMSG = SCMessageVC(chatId: chatId, recipientId: user!.id, recipientName: user!.username, chatAvatar: user!.avatarLink)
            navigationController?.pushViewController(privateMSG, animated: true)
        }
    }

}
