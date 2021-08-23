//
//  SCChatVC.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 02/07/2021.
//

import UIKit

class SCChatVC: UITableViewController {
    
    //MARK: -  vars
    
    var allChatRooms: [ChatRoom] = []
    var filterChatRoom: [ChatRoom] = []
    
    
    //---> creat searchBar To Find Users Chat
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: -  Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        
        downloadAllChatRooms()
        setSearchController()
    }

    

    //MARK: - Action
    
    @IBAction func composeButtonPressed(_ sender: UIBarButtonItem) {
        
        // ----> Insatance From Storyboard To Going To the Users
        let userChats = SCUserStoryboard.instantiateViewController(identifier: "SCUsersVC") as! SCUsersVC
        navigationController?.pushViewController(userChats, animated: true)
    }
    
    
    
    //MARK: -search Controller
    
    
    func setSearchController(){
        
        // ----> to make the tableView that have users -----> same table
        searchController.obscuresBackgroundDuringPresentation = false
        
        // ----> placeHolder
        searchController.searchBar.placeholder = "Search User"
        
        // ----> hide scroll
        navigationItem.hidesSearchBarWhenScrolling = true
        
        // ----> adding the searchBar that we Creat it to the navigation Item
        navigationItem.searchController = searchController
        
        definesPresentationContext = false
        // ----> the Delegate/Protocol search
        searchController.searchResultsUpdater = self
        
        // ----> creat refreshControl
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl
    }
    
    
    
    //MARK: - Helper Function 
    
    
    
    
    // Download all Chat Rooms
    private func downloadAllChatRooms(){
        
        // ----> we call the class Of chat room that have Func to download the chat room
        FChatRoomListener.shared.downloadChatRooms { allFBChatRooms in
            
            //  ----> the chat room that back from the firebase is storied in the var we creat
            self.allChatRooms = allFBChatRooms
            
            // ----> we use the Dispatch To save app from crash
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    // we will going to the message Controller
    private func goingToMessege(_ chatRoom: ChatRoom){
        
        // restart chat room by chat room id , member Ids //NoTe: Without it the chat room we will take space from memory
        restartChatRoom(chatRoomId: chatRoom.chatRoomId, memberIds: chatRoom.memberIds)
        
        // instsne from message VC with send the data
        let messegeVC = SCMessageVC(chatId: chatRoom.chatRoomId, recipientId: chatRoom.receiverId, recipientName: chatRoom.receiverName, chatAvatar: chatRoom.avatarLink)
        
        navigationController?.pushViewController(messegeVC, animated: true)
    }
    
    
    
    //MARK: - tableView Delegate
    
    // number of section of users
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //MARK: - number OF Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // when the search controoler --> active the table will back the num of filter of search ---> not Active will return  num of all users
        return searchController.isActive ? filterChatRoom.count : allChatRooms.count
    }
    
    
    
    //MARK: - cell for Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // the cell of table View // NOTE:- it have the data user in the class
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCChatsUserCell", for: indexPath) as! SCChatsUserCell
        
        // when the search controoler --> active the table will back the filter of search ---> not Active will return all users Data to the cell
        cell.getChatInfo(searchController.isActive ? filterChatRoom[indexPath.row]:allChatRooms[indexPath.row])
        return cell
    }
    
    
    
    //MARK: - Height Row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    

    //MARK: - scroll down tabelView
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // if refresh controller is active Refresh ----> Download all Users ----> ending the refresh
        if refreshControl!.isRefreshing {
            self.downloadAllChatRooms()
            self.refreshControl!.endRefreshing()
        }
    }
    
    
    //MARK: -  did Select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //  ----> chat Room object have the user that we will chat with him
        let chatRoomObject = searchController.isActive ? filterChatRoom[indexPath.row]:allChatRooms[indexPath.row]
        
        // ----> func go to the message vc and send the data of the Object
        goingToMessege(chatRoomObject)
    }
    
    
    //MARK: - Delete ChatRoom
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //MARK: - swap delete
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // creat delete action with swap to controll for swap
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, complation) in
            
            // we check for the statues of the searchController
            let chatRoom = self.searchController.isActive ? self.filterChatRoom[indexPath.row]:self.allChatRooms[indexPath.row]
            
            // ----> delete from the firebase
            FChatRoomListener.shared.deleteChatRoom(chatRoom)
            
            // ----> delete from the local array
              _ = self.searchController.isActive ? self.filterChatRoom.remove(at: indexPath.row):self.allChatRooms.remove(at: indexPath.row)
            
            // ---> that delete the row from tabelView ------> Save the memory
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        // ---> delete backgroundColor
        delete.backgroundColor = .systemRed
        
        // -------> we creat swap that shoud returm ----> add the delete action
        let swip = UISwipeActionsConfiguration(actions: [delete])
        
        // ----> the style/Animation of swap
        swip.performsFirstActionWithFullSwipe = false
        
        return swip
    }
   
}


//MARK: -  Extension

// -----> the protocol Search
extension SCChatVC: UISearchResultsUpdating {
    
    // ---> update the results search
    func updateSearchResults(for searchController: UISearchController) {
        
        // ---> when search ----> the filterChatRoom carry the users ----> note:- we search by users
        filterChatRoom = allChatRooms.filter({ chatRoom in
            
            // ---> return the out Search ---> the lowercased() - use to filter the name of user (uper or lower)
            return chatRoom.receiverName.lowercased().contains(searchController.searchBar.text!.lowercased())
            
        })
        tableView.reloadData()
    }
    
    
}
