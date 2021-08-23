//
//  SCUsersVC.swift
//  Sohba
//
//  Created by Ahmed Fathy on 02/07/2021.
//

import UIKit

class SCUsersVC: UITableViewController {
    
    //MARK: - Variables
    
    
    var allUsers: [User] = []
    var filterUser: [User] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: -  Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        setNavigation()
        
        spinerRefreshTabelView()
        
        configureDownloadAllUsersFromFirestore()
    }
    
    
    //MARK: - Helper Function
    
    
    private func setNavigation(){
        
        title = "Users"
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchController
        
    }
    
    
    
    private func spinerRefreshTabelView(){
        
        searchController.searchBar.placeholder = "Search Users"
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        
        self.refreshControl = UIRefreshControl()
        self.tableView.refreshControl = refreshControl
    }
    
    
    //MARK: -  tableView Delegates
    
    
    //MARK: - numerOfRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // chack if the search controoller is working or not ToDO Search for user
        return searchController.isActive ? filterUser.count : allUsers.count
        
    }
    
    
    
    //MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCUsersTableViewCells", for: indexPath) as! SCUsersTableViewCells
        
        //data cell for all Users
        let user = searchController.isActive ? filterUser[indexPath.row]:allUsers[indexPath.row]
        
        cell.configureCell(user: user)
        return cell
    }
    
    
    
    //MARK: - heightFooter
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    
    
    
    
    //MARK: -  scrolling
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.refreshControl!.isRefreshing {
            self.configureDownloadAllUsersFromFirestore()
            self.refreshControl!.endRefreshing()
        }
    }
    
    
    
    
    
    //MARK: -  didSelect
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = searchController.isActive ? filterUser[indexPath.row] : allUsers[indexPath.row]
        
        showUserProfile(user)
        
    }
    
    
    
    //MARK: -  Helper Function
    
    
    
    //MARK: - Download All Users
    private func configureDownloadAllUsersFromFirestore(){
        FUserListener.shared.downloadAllUsersFirebase { allUser in
            self.allUsers = allUser
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    private func showUserProfile(_ user: User){
        
        let userStoryboard = SCUserStoryboard.instantiateViewController(identifier: "SCProfileUsersVC") as! SCProfileUsersVC
        
        userStoryboard.user = user
        self.navigationController?.pushViewController(userStoryboard, animated: true)
    }
    
    
}



//MARK: -  Extension


extension SCUsersVC: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterUser = allUsers.filter({ user ->Bool in
            return user.username.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        
        tableView.reloadData()
    }
    
}
