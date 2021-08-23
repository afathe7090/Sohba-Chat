//
//  SCMessageChannelVC.swift
//  Sohba
//
//  Created by Ahmed Fathy on 22/07/2021.
//


import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class SCMessageChannelVC: MessagesViewController {
    
    
    //MARK: - Views
    
    
    let leftBarButtonView = SCCustomView(width: 200, height: 50)
    

    
    
    //MARK: - Variabels
    
    
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    private var chatAvatar = ""
    
    var channel: Channel!
    private var longPressGesture: UILongPressGestureRecognizer!
    private var refreshController = UIRefreshControl()
    private let micButton = InputBarButtonItem()
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    var mkMessages: [MKMessage] = []
    
    var allLocalMessage: Results<LocalMessage>!
    
    let realm = try! Realm()
    
    let messageCell = MessageContentCell()
    
    var notificationToken: NotificationToken?
    
    var displayingMessageCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
        
    var gallery: GalleryController!
    
    var audioFileName: String = ""
    var audioStartTime:Date = Date()
    
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    
    //MARK: - init
    
    
    
    init(channel: Channel) {
        super.init(nibName: nil, bundle: nil)
        
        self.channel = channel
        self.chatId = channel.id
        self.recipientId = channel.id
        self.recipientName = channel.name
    }
    
    
    
    required init?(coder: NSCoder) {super.init(coder: coder)}
    
    
    
    
    //MARK: -  Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCustomTitle()
        
        configureMessageCollectionView()
        
        configureGestureRecognizer()
        
        configureMessageInputBar()
        
        loadMessages()
        
//        listenForReadStatuesUpdated()
        
        listenForNewMessages()
        
//        creatTypingObserver()
        
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    
    
    
    
    // Save for Hide the tabBar from back if going to the map View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    
    //MARK: -  helper Finction
    
    
    
    private func configureMessageCollectionView(){
        
        messageInputBar.isHidden = channel.adminId != User.currentId
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.showsVerticalScrollIndicator = false
        messagesCollectionView.refreshControl = refreshController
        
        MessageContentCell().backgroundView?.backgroundColor = .black
    }
    
    
    
    
    
    
    //MARK: - configure Custom Title
    
    private func configureCustomTitle(){
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))]
        
        
        self.title = channel.name
//
//        leftBarButtonView.addSubview(titleLabel)
//        leftBarButtonView.addSubview(subTitleLabel)
//
//
//        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
//        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
//
//        titleLabel.text = recipientName
//
    }
    
    
    
    
    @objc func backButtonPressed(){
        
        removeListeners()
        FChatRoomListener.shared.clearUnReadCounterUsingChatRoomId(chatRoomId: chatId)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    

    
    
    
    //MARK: - remove Listener
    
    
    
    private func removeListeners(){
                
       // FTypingListener.shared.removeTypingListener()
        FMessageListener.shared.removeNewMessageListner()
    }
    
    
    
    
    
    
    //MARK: - Message InputBar
    
    
    private func configureMessageInputBar(){
        
        messageInputBar.delegate = self
        
        let attachButtonBer = InputBarButtonItem()
        attachButtonBer.image = UIImage(systemName: "paperclip" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButtonBer.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButtonBer.onTouchUpInside { _ in
            
            self.actionAttachMessage()
        }
        
        
        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        // add gestureRecoganuizer
        micButton.addGestureRecognizer(longPressGesture)
        
        messageInputBar.setStackViewItems([attachButtonBer], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
        // ToDO : - Update mic button
        
        
        configureUpdateMicBtnStatus(show: true)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
        
        messageInputBar.sendButton.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        messageInputBar.sendButton.setTitle("", for: .normal)
        
    }
    
    
    
    //MARK: - Long Press Mic
    
    
    
    
    private func configureGestureRecognizer(){
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAndSend))
        
    }
    
    
    
    
    
    
    @objc func recordAndSend(){
        
        switch longPressGesture.state {
        
        case .began:
            
            
            // record and start recording
            print("Recourding")
            
            audioFileName = Date().stringDate()
            audioStartTime = Date()
            
            AudioRecorder.shared.startRecording(fileName: audioFileName)
            
        case .ended:
            
            //ending recoud and send
            print("Stop Recording ")
            
            
            AudioRecorder.shared.finishRecourding()
            
            if fileExistAtPath(path: audioFileName + ".m4a"){
                
                let audioDuration = audioStartTime.interval(ofComponent: .second, to: Date())
                send(text: nil, photo: nil, video: nil, location: nil, audio: audioFileName ,audioDuration: audioDuration )
            }
            
            
            
        case .possible:
            print("Possibble")
        case .changed:
            print("changed")
        case .cancelled:
            print("cancelled")
        case .failed:
            print("Faild")
            
        @unknown default:
            print("unKown")
        }
        
    }
    
    
    
    
    
    
    
    
    //MARK: - MiC Statues
    func configureUpdateMicBtnStatus(show: Bool){
        
        if show {
            
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            
        }else {
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Actions
    
    func send(text: String? , photo: UIImage? , video: Video? , location: String? , audio: String? , audioDuration: Float = 0.0 ){
        
        Outgoing.sendChannelMessage(channel: channel, text: text, photo: photo, audio: audio, video: video, audioDuration: Double(audioDuration), location: location)
    }
    
    
    
    
    
    
    private func actionAttachMessage(){
        
        messageInputBar.inputTextView.resignFirstResponder()
        
        let optionMenue = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoOrVideo = UIAlertAction(title: "Camera", style: .default) { alert in
            self.showImageGallery(camera: true)
        }
        
        let showMedia = UIAlertAction(title: "Library", style: .default) { alert in
            self.showImageGallery(camera: false)
        }
        
        let shareLocation = UIAlertAction(title: "Share Location", style: .default) { alert in
            if let _ = LocationMannager.shared.currentLocation{
                
                self.send(text: nil, photo:  nil, video: nil, location: kLOCATION, audio: nil)
            }
            
        }
        
        
        
        let caneclAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        takePhotoOrVideo.setValue(UIImage(systemName: "camera"), forKey: "image")
        showMedia.setValue(UIImage(systemName: "photo.fill"), forKey: "image")
        shareLocation.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        
        optionMenue.addAction(takePhotoOrVideo)
        optionMenue.addAction(showMedia)
        optionMenue.addAction(shareLocation)
        optionMenue.addAction(caneclAction)
        
        self.present(optionMenue, animated: true, completion: nil   )
    }
    
    
    
    
    
    
    
    //MARK: - UIScroll delegate Function
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing {
            
            if displayingMessageCount < allLocalMessage.count {
                
                self.insertMoreMKMessages()
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            
            refreshController.endRefreshing()
        }
    }
    
    
    
    
    
    
    
    //MARK: - Load Messages
    private func loadMessages(){
        
        // we creat var predicate For get  data from realm as Format // NOTE:- chatRoomId shoud be correct like writen in realm class and %@ that are known in realm dataBase To can put the value OF the chatId
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessage = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE, ascending: true)
        
        
        
        //check if the all data that back from database is not Empty
        if allLocalMessage.isEmpty {
            checkForOldMessages()
        }
        
        
        // this var is used to listen and observe at same secand the data changed
        notificationToken = allLocalMessage.observe({(change: RealmCollectionChange) in
            
            switch change{
            		
            //this is first case initial
            case.initial:
                
                // insert Data Of messages
                self.insertMKMessages()
                
                // reload the collection to show data
                self.messagesCollectionView.reloadData()
                
                // To Scroll down at last message
                self.messagesCollectionView.scrollToLastItem(animated: true)
                
                
            // this case when update in data
            case .update(_, deletions: _, insertions: let insertions, modifications: _):
                for index in insertions {
                    
                    // insert data that changed from realm by index
                    self.insertMKMessage(localMessage:  self.allLocalMessage[index])
                    
                    // reload data
                    self.messagesCollectionView.reloadData()
                    
                    // scroll to last messages
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                    self.messagesCollectionView.scrollToBottom()
                    
                }
                
            // if we have error we can print it to know what the error
            case .error(let error):
                print(error)
            }
        })
        
        
    }
    
    
    
    
    
    
    
    //MARK: -  insertMessage
    
    private func insertMKMessage(localMessage: LocalMessage){
        
        // we take instance from the class Incoming to creat message Kit For Users
        let incoming = InComing(messageViewController: self)
        let mkMessage = incoming.creatMessageKit(localMessage: localMessage)
        
//        markMessageAsRead(localMessage)
        self.mkMessages.append(mkMessage)
        
        displayingMessageCount += 1
    }
    
    
    
    
    
    
    
    
    //MARK: - Insert Older Message
    
    private func insertOlderMKMessage(localMessage: LocalMessage){
        
        // we take instance from the class Incoming to creat message Kit For Users
        let incoming = InComing(messageViewController: self)
        let mkMessage = incoming.creatMessageKit(localMessage: localMessage)
        
        // we use insert For handel array mkMessage for insert message at index 0 To Show first Message at A first Index
        self.mkMessages.insert(mkMessage, at: 0)
        
        displayingMessageCount += 1
    }
    
    
    
    
    
    
    
    
    //MARK: - insert Messages
    
    
    // this is first case that insert Data
    private func insertMKMessages(){
        
        
        // We use max and min of message for show the Number Of message And Pull to reload Anuther
        maxMessageNumber = allLocalMessage.count - displayingMessageCount
        minMessageNumber = maxMessageNumber - 12
        
        // for save min to make the crash app becouse, not found -1 messages
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        // We will insert the number of messages Are alawed To show
        for item in minMessageNumber ..< maxMessageNumber {
            insertMKMessage(localMessage: allLocalMessage[item])
        }
        
    }
    
    
    
    
    
    
    private func insertMoreMKMessages(){
        
        
        // we had sum of messages we inserted it before it ..insertMKMessages() ,so we will update Number of the max
        maxMessageNumber = minMessageNumber - 1
        minMessageNumber = maxMessageNumber - 12
        
        // for save min to make the crash app becouse, not found -1 messages
        if minMessageNumber < 0 {
            minMessageNumber = 0
        }
        
        // We will insert the number of messages Are alawed To show After reload/Pull the viewController For Reload and get More messages //NOTE:- We user reversed for insert the message arrang that saved (last message First Show)
        for item in (minMessageNumber ... maxMessageNumber).reversed() {
            insertOlderMKMessage(localMessage: allLocalMessage[item])
        }
        
    }
    
    
    
    
    
    
    
    //MARK: - check For Old Messages
    private func checkForOldMessages(){
        
        // check if found any Messages in firebase and download it if we have an acount and delete app
        FMessageListener.shared.checkForOldmessages(User.currentId, collectionId: chatId)
    }
    
    
    
    
    
    
    
    //MARK: - listen For new messages
    
    
    private func listenForNewMessages(){
        
        // listen For the new messages that sent if we open the chat and the user sent message we can't show it untel back and open chat again
        FMessageListener.shared.listenForNewMessages(User.currentId, collectionId: chatId, lastMessageDate: lastMessageDate())
    }
    
    
    
    
    
    
    private func lastMessageDate() ->Date {
        
        // we handel the time last message Sent
        let lastMessageDate = allLocalMessage.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second,value: 1, to: lastMessageDate) ?? lastMessageDate
    }
    
    
    
    
    
    //MARK: - Gallery
    
    private func showImageGallery(camera: Bool){
        
        gallery = GalleryController()
        gallery.delegate = self
        
        Config.tabsToShow = camera ? [.cameraTab]:[.imageTab , .videoTab]
        Config.Camera.imageLimit = 30
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 60 * 60 * 3
        
        self.present(gallery, animated: true, completion: nil)
        
    }
    
    
}







extension SCMessageChannelVC: GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        
        Image.resolve(images: images) { imagesArray in
            
            if imagesArray.count > 0 {
                for image in imagesArray {
                    self.send(text: nil, photo:  image, video: nil, location: nil, audio: nil)
                }
            }
        }
        
        //        if images.count > 0 {
        //
        //
        //            for item in 0...images.count - 1 {
        //
        //                images[item].resolve { image in
        //
        //                    print(item)
        //                    self.send(text: nil, photo:  image, video: nil, location: nil, audio: nil)
        //                }
        //
        //            }
        //
        //
        //                        for sentImage in images {
        //
        //                                sentImage.resolve { image in
        //                                    self.send(text: nil, photo:  image, video: nil, location: nil, audio: nil)
        //                            }
        //                        }
        //        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        self.send(text: nil, photo:  nil, video: video, location: nil, audio: nil)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
}
