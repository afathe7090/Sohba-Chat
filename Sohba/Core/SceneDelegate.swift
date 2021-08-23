//
//  SceneDelegate.swift
//  Sohba
//
//  Created by Ahmed Fathy on 05/07/2021.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener: AuthStateDidChangeListenerHandle?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        configureAutoLogin()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        LocationMannager.shared.startUpdating()

    }

    func sceneWillResignActive(_ scene: UIScene) {
        LocationMannager.shared.stopUpdating()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationMannager.shared.stopUpdating()

    }

    
    
    func configureAutoLogin(){
        
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil &&  defaults.object(forKey: kCURRENTUSER) != nil {
                self.goingToApp()
            }
        })
        
    }
    
    
    private func goingToApp(){
        let vc = SCBaseTabBarController()
        self.window?.rootViewController = vc
    }
    
}

