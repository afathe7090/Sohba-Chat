//
//  SCStatusEdittingVC.swift
//  Sohba
//
//  Created by Ahmed Fathy on 06/07/2021.
//

import UIKit

class SCStatusEdittingVC: UITableViewController {

    //MARK: -  variables
    
    var statuses = ["Available","Busy","I am sleeping", "Sohba only"]
    let newStatues = defaults.array(forKey: kNEWSTATUES) as? [String]
    
    //MARK: -  life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        setDefaultStatus()
        
        configureStatuesArray()
    }

    
    
    //MARK: - Functions
    
    
    
    //MARK: - Data Statues Array
    private func configureStatuesArray(){
        
        if newStatues != nil{
            statuses = newStatues!
        }
    }
    
    
    
    
    //MARK: - Add Button For NavigationController
    private func setDefaultStatus(){
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addingStutusAction))
        navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    
    
    
    @objc func addingStutusAction(){
        
        let alertStatues = UIAlertController(title: "Statues", message: "Add Statues ", preferredStyle: .alert)
        alertStatues.addTextField { textField in textField.placeholder = "New Statues"}
        
        let alertDone = UIAlertAction(title: "Done", style: .cancel) { alertAction in
            let textField = alertStatues.textFields![0]
            
            if textField.text != ""{
                self.statuses.append(textField.text!)
                
                saveStatues(statues: self.statuses)
                self.tableView.reloadData()
            }else{
                return
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: .none)
        alertStatues.addAction(alertDone)
        alertStatues.addAction(cancelAction)
        
        self.present(alertStatues, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: -  Numer oF rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  statuses.count
    }
    
    
    
    
    //MARK: - Cell for Row At
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SCStatuesCell", for: indexPath ) as! SCStatuesCell
        cell.textLabel?.text = statuses[indexPath.row]
        
        let userStatues = User.currentUser?.status
        cell.accessoryType = userStatues == statuses [indexPath.row] ? .checkmark:.none
        return cell
    }
    
    
    
    
    //MARK: -  didSelect
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userStatues = tableView.cellForRow(at: indexPath)?.textLabel?.text
        
        tableView.reloadData()
        
        var user = User.currentUser
        user?.status = userStatues!
        saveUserLocally(user!)
        FUserListener.shared.saveUserFirestore(user!)
    }
    

}
