//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Timothy Liew on 3/17/18.
//  Copyright © 2018 Tim Liew. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFBUserData()
        self.logoutButton.isEnabled = false
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    self.loginButton.isEnabled = false
                    self.logoutButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func facebookLogout(_ sender: Any) {
        FBSDKLoginManager().logOut()
        self.loginButton.isEnabled = true
        self.logoutButton.isEnabled = false
    }
    
    
    private func getFBUserData(){
        if ( FBSDKAccessToken.current() != nil ) {
            // User is logged in, use 'accessToken' here.
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("error with auth: \(error.localizedDescription)")
                    return
                }
                if let user = user {
                    print("login success")
                    // Get the storyboard and HomeTableViewController
                    let storyboard = UIStoryboard (name: "Main", bundle: nil)
                    let home = storyboard.instantiateViewController(withIdentifier: "TarBarController") as! UITabBarController
                    
                    self.present(home, animated: true, completion: nil)
                }
            }
        }
    }

}
