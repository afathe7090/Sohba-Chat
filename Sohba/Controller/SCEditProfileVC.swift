//
//  SCEditProfileVC.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 04/07/2021.
//

import UIKit
import Gallery
import ProgressHUD

class SCEditProfileVC: UITableViewController {

    
    //MARK: -  Outlets
    @IBOutlet weak var avatarUserEditing: UIImageView!
    
    @IBOutlet weak var statusLabelOutlet: UILabel!
    
    @IBOutlet weak var nameUserEditting: UITextField!
    
    
    //MARK: - Variables
    
    var gallery: GalleryController!
    
    //MARK: -  Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        showUserInfo()
        
        configureTabelView()
        
        configureTextField()
        
    }
    
    
    //MARK: -  Action
    
    @IBAction func editAvatarUserBtnPressed(_ sender: UIButton) {
        
        showImageGalary()
    }
    
    
    // MARK: - Helper Function
    
    

    private func configureTabelView(){
        tableView.tableFooterView = UIView()
        
    }
    
    
    private func showUserInfo(){
        
        
        if let user = User.currentUser {
            
            statusLabelOutlet.text = user.status
            nameUserEditting.text = user.username
            
            if user.avatarLink != "" {
                
                //Set avatar Image
                
                FileStorage.downloadImage(imageURL: user.avatarLink) { avatarImage in
                    self.avatarUserEditing.image = avatarImage?.circleMasked
                }
            }
            
        }
        
    }
    
    
    private func showImageGalary(){
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab ,.cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        
        self.present(gallery, animated: true, completion: nil)
    }
    
    
    private func configureUpLoadAvatarImageFirebaseStorage(_ image: UIImage){
        
        let fileDirectory = kAVATARS + "_\(User.currentId)" + kJPG
        
        FileStorage.upLoadImage(image,directory: fileDirectory) { avatarLink in
            
            if var user =  User.currentUser {
                
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FUserListener.shared.saveUserFirestore(user)
            }
            
            
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData, fileName: User.currentId)
            
            
        }
    }
    
    
    
    
    
    //MARK: -  configure TextField
    
    private func configureTextField(){
        
        nameUserEditting.delegate = self
        nameUserEditting.clearButtonMode = .whileEditing
    }
    
    
    
    
    
    //MARK: -  Delegate tableview
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 || section == 1 ? 0.0:30.0
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(named: "colorTableview")
        return view
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
            
            let story = SCSettingStorboard.instantiateViewController(identifier: "SCStatusEdittingVC")
            self.navigationController?.pushViewController(story, animated: true)
        }
        
    }
    
    
    
}


//MARK: -  Extention



//MARK: - textField Delegate
extension SCEditProfileVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameUserEditting{
            
            if textField.text != "" {
                
                if var user = User.currentUser {
                    
                    user.username = textField.text!
                    saveUserLocally(user)
                    FUserListener.shared.saveUserFirestore(user)
                }
            }
            
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
}






//MARK: -  Gallery Delegate

extension SCEditProfileVC: GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first!.resolve { avatar in
                if avatar != nil {
                    
                    self.configureUpLoadAvatarImageFirebaseStorage(avatar!)
                    self.avatarUserEditing.image = avatar
                }
            }
        }else{
            ProgressHUD.showError("Could not select image ")
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
