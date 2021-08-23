//
//  SCChannelsVC.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 02/07/2021.
//

import UIKit

class SCChannelsVC: UITableViewController {
    
    //MARK: - Constants
    
    
    var myChannels: [Channel] = []
    var allChannels: [Channel] = []
    var subscribedChannels: [Channel] = []
    
    
    //MARK: - Outlet
    
    
    @IBOutlet weak var channelSegmentOutlet: UISegmentedControl!
    
    
    
    //MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        downloadAllCahnnel()
        downloadSubscribesChannels()
        downloadMyChannel()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.downloadAllCahnnel()
    }
    
    //MARK: - Action
    @IBAction func channelSegmentOutlet(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBAction func addChannelBarButtonPressed(_ sender: UIBarButtonItem){
        
        let channelStoryboard = SCChannelStoryboard.instantiateViewController(identifier: "SCAddChannelVC") as! SCAddChannelVC
        self.navigationController?.pushViewController(channelStoryboard, animated: true)
    }
    
    
    
    
    
    //MARK: - Helper Function
    
    
    private func configure(){
        
        title = "Channels"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
    }

    //MARK: - Download Channel
    
    private func downloadAllCahnnel(){
        FChannelListener.shared.downloadAllChannels { allChannels in
            self.allChannels = allChannels
            
            if self.channelSegmentOutlet.selectedSegmentIndex == 1 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    
    private func downloadSubscribesChannels(){
        
        FChannelListener.shared.downloadSubsribedChannels { subscribedChannels in
            self.subscribedChannels = subscribedChannels
            
            if self.channelSegmentOutlet.selectedSegmentIndex == 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
  
    
    
    
    private func downloadMyChannel(){
        FChannelListener.shared.downloadUserChannels { myChannels in
            self.myChannels = myChannels
            
            if self.channelSegmentOutlet.selectedSegmentIndex == 2 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    
    
    //MARK: - Show Chat
    private func showChat(channel: Channel){
        
        let goTOmessage = SCMessageChannelVC(channel: channel)
        self.navigationController?.pushViewController(goTOmessage, animated: true)
    }
    
    
    
    
    //MARK: - Editing Channel
    
    private func showEditingChannelView(channel: Channel){
        
        let channelVC = SCChannelStoryboard.instantiateViewController(identifier: "SCAddChannelVC") as! SCAddChannelVC
        
        channelVC.channelToEdit = channel
        self.navigationController?.pushViewController(channelVC, animated: true)
    }
    
    
    
    
    
    //MARK: - Following Channel View
    
    private func showFollowingPageController(channel: Channel){
        let followChannel = SCChannelStoryboard.instantiateViewController(identifier: "SCChannelFollowingVC") as! SCChannelFollowingVC
        
        followChannel.channel = channel
        self.navigationController?.pushViewController(followChannel, animated: true)
    }
    
    
    
    
    //MARK: - Delegate TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let segmentIndex = channelSegmentOutlet.selectedSegmentIndex
        
        switch segmentIndex {
        case 0:
            return subscribedChannels.count
        case 1 :
            return allChannels.count
        case 2:
            return myChannels.count
        default:
            return 0
        }
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCChannelCell", for: indexPath) as! SCChannelCell
        
        var channel = Channel()
        
        let segmentIndex = channelSegmentOutlet.selectedSegmentIndex
        
        switch segmentIndex {
        case 0:
            channel = subscribedChannels[indexPath.row]
        case 1 :
            channel = allChannels[indexPath.row]
        case 2:
            channel = myChannels[indexPath.row]
        default:
            channel = Channel()
        }
        
        cell.configureChannel(channel: channel)
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        if channelSegmentOutlet.selectedSegmentIndex == 0{
            
            showChat(channel: subscribedChannels[indexPath.row])
            
        }else if channelSegmentOutlet.selectedSegmentIndex == 1{
            
            showFollowingPageController(channel: allChannels[indexPath.row])
            
        }else {
            showEditingChannelView(channel: myChannels[indexPath.row])
        }
        
    }
    
    

    
    //MARK: - Swap Delete
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // creat delete action with swap to controll for swap
        let delete = UIContextualAction(style: .normal, title: "Delete") { [self] (action, view, complation) in
            
            // ----> Following Channel
            if channelSegmentOutlet.selectedSegmentIndex == 0 {
                
                // ----> If the channel Not belongs To the User ---> Not Swaping
                if subscribedChannels[indexPath.row].adminId != User.currentId{
                    
                    // ---> Sellected the index of the row that Will deleted
                    var channelToUnfollow = subscribedChannels[indexPath.row]
                    subscribedChannels.remove(at: indexPath.row)
                    
                    // ----> remove the member that Un Following
                    if let index = channelToUnfollow.memberIds.firstIndex(of: User.currentId) {
                        channelToUnfollow.memberIds.remove(at: index)
                    }
                    
                    // ----> Remaove/Sava the Editting Channels
                    FChannelListener.shared.saveChannel(channelToUnfollow)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        
        // ---> delete backgroundColor
        delete.backgroundColor = .systemRed
        
        
        // ---> If the cell of the Channel belongs To the User ----> Not Swaping To Un Follow
        if subscribedChannels[indexPath.row].adminId != User.currentId{
            // -------> we creat swap that shoud returm ----> add the delete action
            let swip = UISwipeActionsConfiguration(actions: [delete])
            // ----> the style/Animation of swap
            swip.performsFirstActionWithFullSwipe = false
            return swip
        }else{
            return UISwipeActionsConfiguration()
        }
        
    }
   
    
    //MARK: - Scroll ViewDelgate
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshControl!.isRefreshing {
            self.downloadAllCahnnel()
            refreshControl!.endRefreshing()
        }
    }
    
    
}
