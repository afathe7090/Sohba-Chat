//
//  SCAddChannelVC.swift
//  Sohba
//
//  Created by Ahmed Fathy on 20/07/2021.
//

import UIKit
import Gallery
import ProgressHUD

class SCAddChannelVC: UITableViewController {
    
    
    //MARK: - Variables
    
    
    var channelId = UUID().uuidString
    var gallery: GalleryController!
    var avatarLink = ""
    var tapGesture = UITapGestureRecognizer()
    var channelToEdit: Channel?
    
    
    //MARK: - Outlet
    
    @IBOutlet weak var channelAvatar: UIImageView!
    
    @IBOutlet weak var nameChannelTextField: UITextField!
    
    @IBOutlet weak var aboutChannelTextView: UITextView!
    
    
    
    
    
    //MARK: - Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureGesture()
        
        configureEditingView()
        
        
    }
    
    
    
    //MARK: - Actions
    
    @IBAction func saveChannelButtonPressed(_ sender: UIBarButtonItem) {
        
        if nameChannelTextField.text != "" {
            // save Channel
            saveChannel()
            
        }else {
            ProgressHUD.showError("Channel name is required")
        }
    }
    
    
    @objc func avatarImageTap(){
        
        showGallary()
    }
    
    
    
    //MARK: - Functions
    private func configureNav(){
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
    }
    
    
    
    private func configureGesture(){
        
        tapGesture.addTarget(self, action: #selector(avatarImageTap))
        channelAvatar.isUserInteractionEnabled = true
        channelAvatar.addGestureRecognizer(tapGesture)
    }
    
    
    private func showGallary(){
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.imageTab , .cameraTab]
        Config.Camera.imageLimit = 1
        Config.initialTab  = .imageTab
        
        self.present(gallery, animated: true, completion: nil)
        
    }
    
    
    
    
    //MARK: - Configure Edit View
    
    private func configureEditingView(){
        
        if channelToEdit != nil{
            self.aboutChannelTextView.text = channelToEdit?.aboutChannel
            self.nameChannelTextField.text = channelToEdit?.name
            self.channelId = channelToEdit!.id
            self.avatarLink = channelToEdit!.avatarLink
            self.title = "Editing Channel"
            
            
            if channelToEdit?.avatarLink != nil {
                FileStorage.downloadImage(imageURL: channelToEdit!.avatarLink) { imageChannel in
                    
                    DispatchQueue.main.async {
                        self.channelAvatar.image = imageChannel!.circleMasked
                    }
                }
            }else{
                self.channelAvatar.image = UIImage(named: "avatar")
            }
        }
        
    }
    //MARK: - Avatar
    
    private func uploadAvatarImage(_ image: UIImage){
        let fileDirectory = "Avatars/" + "_\(channelId)" + ".jpg"
        
        FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.7)! as NSData, fileName: self.channelId)
        
        FileStorage.upLoadImage(image, directory: fileDirectory) { avatarLink in
            self.avatarLink = avatarLink ?? ""
        }
    }
    
    
    
    
    //MARK: - save Channel
    
    
    private func saveChannel(){
        
        let channel = Channel(id: channelId, name: nameChannelTextField.text!, adminId: User.currentId, memberIds: [User.currentId], avatarLink: avatarLink, aboutChannel: aboutChannelTextView.text)
        
        
        // save Channel To Firestore
        FChannelListener.shared.saveChannel(channel)
        self.navigationController?.popViewController(animated: true)
    }
    
}



//MARK: - Extension
extension SCAddChannelVC: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first!.resolve { icon in
                if icon != nil {
                    
                    //Upload Image
                    self.uploadAvatarImage(icon!)
                    //setAvatar  Image
                    self.channelAvatar.image = icon!.circleMasked
                }else{
                    ProgressHUD.showError("Could not select Image")
                }
            }
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
