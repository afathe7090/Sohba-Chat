//
//  SCUser.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 01/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct User: Codable , Equatable{
    var id = ""
    var username: String
    var email: String
    var pushID = ""
    var avatarLink = ""
    var status: String
    
    
    
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    
    
    
    // we save data From user now we will return data that saved
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            
            if let data  = defaults.data(forKey: kCURRENTUSER){
                
                let decoder = JSONDecoder()
                
                do{
                    
                    let userObject = try decoder.decode(User.self, from: data)
                    return userObject
                    
                }catch {
                    
                    print(error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    
    static func == (lhs: User, rhs: User)->Bool {
        lhs.id == rhs.id
    }
    
    
    
}

//Function Save Data User by user Dafaults
func saveUserLocally(_ user: User){
    
    let encoder = JSONEncoder()
    do{
        let data = try encoder.encode(user)
        defaults.setValue(data, forKey: kCURRENTUSER)
        
    }catch{
        print(error.localizedDescription)
    }
}


//Save User Statues
func saveStatues(statues: [String]?){
    defaults.setValue(statues, forKey: kNEWSTATUES)
    defaults.synchronize()
}




//MARK: -  Creat Fake User For firestore
func createDummyUsers() {
    print("creating dummy users...")
    
    let names = ["Iron Man", "Alaa Najmi", "Nawaf Mansour", "Keanu Reeves", "Smeagol"]
    
    var imageIndex = 1
    var userIndex = 1
    
    for i in 0..<5 {
        
        let id = UUID().uuidString
        
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        
        FileStorage.upLoadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { (avatarLink) in
            
            let user = User(id: id, username: names[i], email: "user\(userIndex)@mail.com", pushID: "", avatarLink: avatarLink ?? "", status: "No Status")
            
            userIndex += 1
            FUserListener.shared.saveUserFirestore(user)
        }
        
        imageIndex += 1
        if imageIndex == 5 {
            imageIndex = 1
        }
    }
}
