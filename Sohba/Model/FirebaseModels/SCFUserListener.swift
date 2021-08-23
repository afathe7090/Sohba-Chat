//
//  SCFUserListener.swift
//  Sohba_Chat
//
//  Created by Ahmed Fathy on 01/07/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FUserListener {
    
    //Selgenton save Us object from this class to one connection With Firestore
    static let shared = FUserListener()
    
    private init (){}
    
    
    //MARK: -  Login
    
    
    //login User Function
    func loginUser(email: String , password: String ,completion: @escaping (_ error: Error?, _ isEmailVerified: Bool?)-> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] authResults, error in
            if error == nil {
                if authResults!.user.isEmailVerified  {
                    
                    completion(error, true)
                    self.downloadUserFromFirebase(userID: authResults!.user.uid)
                    
                }
                
                
                if authResults?.user != nil{
                    let user = User(id: authResults!.user.uid, username: email, email: email, pushID: "", avatarLink: "", status: "Hey, I am Using Sohba")
                    saveUserLocally(user)
                }
                
            }else{
                completion(error,false)
            }
        }
    }
    
    
    
    
    
    //MARK: - Register
    
    func registerUser(email: String , password: String , completion: @escaping (_ authResults: AuthDataResult? ,_ error: Error?)-> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResults, error) in
            
            completion(authResults , error)
            
            if error == nil {
                
                authResults!.user.sendEmailVerification { (error) in
                    
                    completion(authResults, error)
                }
                
            }
            
            
            if authResults?.user != nil {
                let user = User(id: authResults!.user.uid, username: email, email: email, pushID: "", avatarLink: "", status: "Hey, I am Using Sohba")
                
                self.saveUserFirestore(user)
                saveUserLocally(user)
            }
        }
    }
    
    
    
    
    
    //MARK: - resend varification
    
    func resendVarificationEmailWith(email: String ,completion: @escaping(_ error: Error?)->Void){
        
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
        
    }
    
    
    
    
    
    //MARK: - Forget Password
    
    func resetPasswordEmail(email: String ,completion: @escaping (_ error: Error? )-> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    
    
    
    
    //MARK: -  log Out
    
    func logOutCurrentUser(completion: @escaping(_ error: Error?)->Void){
        
        do{
            try Auth.auth().signOut()
            defaults.removeObject(forKey: kCURRENTUSER)
            defaults.synchronize()
            completion(nil)
        }catch let error as NSError {
            completion(error)
        }
        
        
    }
    
    
    
    //MARK: -  Download User
     func downloadUserFromFirebase(userID: String){
        
        FirestoreReference(.User).document(userID).getDocument { document, error in
            guard let userDicument = document else{return}
            
            let result = Result{try? userDicument.data (as: User.self)}
            switch result {
            
            case .success(let userObject):
                
                if let user = userObject {
                    saveUserLocally(user)
                }else{
                    print("document does not exit")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    //MARK: -  download User Using IDs
    
    func downloadUsersFromFirestore(withIds: [String], compeletion: @escaping(_ allUsers: [User]) -> Void){
        
        var count = 0
        var userArray:[User] = []
        
        for userId in withIds {
            
            FirestoreReference(.User).document(userId).getDocument { snapshot, error in
                guard let document = snapshot else{return}
                
                let user = try? document.data(as: User.self)
                
                userArray.append(user!)
                count += 1
                
                if count == withIds.count{
                    compeletion(userArray)
                }
            }
        }
        
        
    }
    
    
    
    //MARK: -  Download all user
    
    func downloadAllUsersFirebase(compeltion: @escaping (_ allUser: [User])->Void){
        
        var users:[User] = []
        
        FirestoreReference(.User).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("No documents Found")
                return}
            
            let allUser = documents.compactMap { snapshot -> User? in
                return try? snapshot.data(as: User.self)
            }
            
            for user in allUser {
                if User.currentId != user.id{
                    users.append(user)
                }
            }
            compeltion(users)
        }
        
    }
    
    
    
    //MARK: - Helper Function
    
    
     func saveUserFirestore(_ user: User){
        do{
            try FirestoreReference(.User).document(user.id).setData(from: user)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    
    
    

    
    
    
}
