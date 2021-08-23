//
//  SCSettingsVC.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 02/07/2021.
//

import UIKit

class SCSettingsVC: UITableViewController {
    //MARK: -  Outlet
    
    @IBOutlet weak var avatarUser: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userStausLabel: UILabel!
    
    @IBOutlet weak var versionOfApplicationLBL: UILabel!
    
    
    
    
    
    
    //MARK: -  Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureUserInfo()
    }
    
    
    
    
    //MARK: - Actions
    
    
    
    
    @IBAction func tellAfriendBtnPressed(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func termsBtnPressed(_ sender: UIButton) {
        
    }
    
    
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        
        configureLogOut()
    }
    
    
    
    
    
    //MARK: - Helper Function
    
    
    
    //MARK: - configure Navigation
    private func configureNavigation(){
        
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }
    
    
    
    
    
    
    
    //MARK: - User Info
    private func configureUserInfo(){
        
        if let user = User.currentUser {
            
            userNameLabel.text = user.username
            userStausLabel.text = user.status
            versionOfApplicationLBL.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            
            if user.avatarLink != ""{
                
                //TODo : Download and Set Avatar
                FileStorage.downloadImage(imageURL: user.avatarLink) { avatarLink in
                    self.avatarUser.image = avatarLink?.circleMasked
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    //MARK: - going to Editing View
    private func goingToEditingView(){
        
        let editVC = SCSettingStorboard.instantiateViewController(identifier: "SCEditProfileVC") as! SCEditProfileVC
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    
    
    
    //MARK: - Log Out From App and Firebase
    
    
    
    private func configureLogOut(){
        FUserListener.shared.logOutCurrentUser { error in
            if error == nil {
                
                self.goingToFirstPageLogin()
                
            }
        }
    }
    
    
    
    
    
    // Log in View page
    private func goingToFirstPageLogin(){
        let login = SCLoginStoryboard.instantiateViewController(identifier: "SCLoginPageVC")
        login.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.async {
            self.present(login, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    //MARK: -  tableView Functions
    
    
    //MARK: - height Header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 5:20
    }
    
    
    
    
    
    
    //MARK: - DidSelect
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0{
            goingToEditingView()
        }
    }
    
    
    
    
    
    
    //MARK: - View Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "colorTableview")
        return headerView
    }
    
}

