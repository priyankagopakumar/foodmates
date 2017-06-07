//
//  RegisterViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 6/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin
import FBSDKLoginKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in
                self.performSegue(withIdentifier: "MainPageSegue", sender: self)
            } else {
                // No user is signed in.
                print("user is not logged in")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerWithFoodmates(_ sender: Any) {
        var email: String?
        var password: String?
        email = textEmail.text
        password = textPassword.text
        
        if (email?.isEmpty)!
        {
            displayAlert(title: "Alert", message: "Please enter an email")
        }
        else
        if (password?.isEmpty)!
        {
            displayAlert(title: "Alert", message: "Please enter a password")
        }
        else
        {
          
        }
    }

    @IBAction func registerUsingFacebook(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.performSegue(withIdentifier: "MainPageSegue", sender: self)
            })
        }
    }
    
    
    @IBAction func registerUsingGoogle(_ sender: Any) {
        
        //TODO
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
    
    
    func displayAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
