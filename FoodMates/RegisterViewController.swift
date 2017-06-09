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
import GoogleSignIn

class RegisterViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    
    @IBOutlet weak var registerInputView: UIView!
    @IBOutlet weak var loginRegisterSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var appLogoImageView: UIImageView!
    
    var ref: FIRDatabaseReference?
    var registerInputViewHeightAnchor: NSLayoutConstraint?
    
    lazy var loginContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorLiteralRed: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorLiteralRed: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        textName.delegate = self
        textEmail.delegate = self
        textPassword.delegate = self
        textName.returnKeyType = .done
        textEmail.returnKeyType = .done
        textPassword.returnKeyType = .done
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFoodViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        setupRegisterInputView()
        view.addSubview(loginContainerView)
        loginContainerView.isHidden = true
        loginRegisterButton.layer.cornerRadius = 5
        loginRegisterButton.layer.masksToBounds = true
        //setupLoginRegisterSegmentedControl()
        //setupAppLogoImage()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            do{
                try FIRAuth.auth()?.signOut()
            }
            catch let logoutError {
                print (logoutError)
            }
        }
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in
                print("logged in user is: ", user.email)
                self.performSegue(withIdentifier: "MainPageSegue", sender: self)
            } else {
                // No user is signed in.
                print("user is not logged in")
                
            }
        }
    }


    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func handleLoginRegisterChange()
    {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0
        {
            loginContainerView.isHidden = false
            registerInputView.isHidden = true
            setupLoginContainerView()
        }
        else
        {
            loginContainerView.isHidden = true
            registerInputView.isHidden = false
            setupRegisterInputView()
        }
        
        
    }
    
    func setupLoginContainerView()
    {
        loginContainerView.layer.cornerRadius = 5
        loginContainerView.layer.masksToBounds = true
        
        loginContainerView.translatesAutoresizingMaskIntoConstraints = false
        loginContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginContainerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        loginContainerView.addSubview(textEmail)
        loginContainerView.addSubview(textPassword)
        loginContainerView.addSubview(emailSeparatorView)

        //setup x, y, width and height for email
        textEmail.translatesAutoresizingMaskIntoConstraints = false
        textEmail.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor, constant: 12).isActive = true
        textEmail.topAnchor.constraint(equalTo: loginContainerView.topAnchor).isActive = true
        textEmail.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        textEmail.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor, multiplier: 1/2).isActive = true
        
        // setup x, y, width, height constraints for the separator
        emailSeparatorView.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: textEmail.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        // setup password text field
        textPassword.isSecureTextEntry = true
        //setup x, y, width and height for password
        textPassword.translatesAutoresizingMaskIntoConstraints = false
        textPassword.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor, constant: 12).isActive = true
        textPassword.topAnchor.constraint(equalTo: textEmail.bottomAnchor).isActive = true
        textPassword.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        textPassword.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor, multiplier: 1/2).isActive = true
    }
    

    func setupRegisterInputView()
    {
        registerInputView.layer.cornerRadius = 5
        registerInputView.layer.masksToBounds = true
        
        registerInputView.translatesAutoresizingMaskIntoConstraints = false
        registerInputView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0.0).isActive = true
        registerInputView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        //registerInputView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -24).isActive = true
        registerInputViewHeightAnchor = registerInputView.heightAnchor.constraint(equalToConstant: 150)
        registerInputViewHeightAnchor?.isActive = true

        registerInputView.addSubview(textEmail)
        registerInputView.addSubview(textPassword)
        registerInputView.addSubview(nameSeparatorView)
        registerInputView.addSubview(emailSeparatorView)
        
        // setup x, y, width, height constraints for the textfields
        textName.translatesAutoresizingMaskIntoConstraints = false
        textName.leftAnchor.constraint(equalTo: registerInputView.leftAnchor, constant: 12).isActive = true
        textName.topAnchor.constraint(equalTo: registerInputView.topAnchor).isActive = true
        textName.widthAnchor.constraint(equalTo: registerInputView.widthAnchor).isActive = true
        textName.heightAnchor.constraint(equalTo: registerInputView.heightAnchor, multiplier: 1/3).isActive = true
        
        // setup x, y, width, height constraints for the separator
        nameSeparatorView.leftAnchor.constraint(equalTo: registerInputView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: textName.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: registerInputView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //setup x, y, width and height for email
        textEmail.translatesAutoresizingMaskIntoConstraints = false
        textEmail.leftAnchor.constraint(equalTo: registerInputView.leftAnchor, constant: 12).isActive = true
        textEmail.topAnchor.constraint(equalTo: textName.bottomAnchor).isActive = true
        textEmail.widthAnchor.constraint(equalTo: registerInputView.widthAnchor).isActive = true
        textEmail.heightAnchor.constraint(equalTo: registerInputView.heightAnchor, multiplier: 1/3).isActive = true
        
        // setup x, y, width, height constraints for the separator
        emailSeparatorView.leftAnchor.constraint(equalTo: registerInputView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: textEmail.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: registerInputView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        // setup password text field
        textPassword.isSecureTextEntry = true
        //setup x, y, width and height for password
        textPassword.translatesAutoresizingMaskIntoConstraints = false
        textPassword.leftAnchor.constraint(equalTo: registerInputView.leftAnchor, constant: 12).isActive = true
        textPassword.topAnchor.constraint(equalTo: textEmail.bottomAnchor).isActive = true
        textPassword.widthAnchor.constraint(equalTo: registerInputView.widthAnchor).isActive = true
        textPassword.heightAnchor.constraint(equalTo: registerInputView.heightAnchor, multiplier: 1/3).isActive = true
    }

    func setupLoginRegisterSegmentedControl()
    {
        loginRegisterSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: registerInputView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupAppLogoImage()
    {
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        appLogoImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        appLogoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerWithFoodmates(_ sender: Any) {
        var name: String?
        var email: String?
        var password: String?
        email = textEmail.text
        password = textPassword.text
        name = textName.text
        var chosenOption = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        if ((name?.isEmpty)! && chosenOption == "Register")
        {
            displayAlert(title: "Alert", message: "Please enter a name")
        }
        else
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
            if (chosenOption == "Login")
            {
                FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                    if error != nil
                    {
                        print (error)
                        self.displayAlert(title: "Error", message: "Could not login. Please enter valid details")
                        return
                    }
                    print ("Successfully signed in")
                }

            }
            else
            {
                FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: {(user, error) in
                    
                    if error != nil
                    {
                        print (error)
                        self.displayAlert(title: "Error", message: "Could not register. Please enter valid details")
                        return
                    }
                    print ("Successfully authenticated")
                    let values = ["name": name, "email": email, "imageURL": "Blank", "contact": "Nil"]
                    self.ref?.child("Profile").child((user?.uid)!).updateChildValues(values, withCompletionBlock: {(err, ref) in
                        
                        if (err != nil)
                        {
                            print(err)
                            return
                        }
                        print ("Saved user successfully into Firebase")
                    })
                })
            }
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
                
                var hasEntry: Bool = false
                var ref2: FIRDatabaseReference = FIRDatabase.database().reference()
                ref2.child("Profile").child((user?.uid)!).observe(.value, with: {(snapshot) in
                    // let's try this
                    if (snapshot.hasChildren())
                    {
                        hasEntry = true
                    }
                    if (!hasEntry)
                    {
                        let values = ["name": user?.displayName, "email": user?.email, "imageURL": "Blank", "contact": "Nil"]
                        self.ref?.child("Profile").child((user?.uid)!).updateChildValues(values, withCompletionBlock: {(err, ref) in
                            
                            if (err != nil)
                            {
                                print(err)
                                return
                            }
                            print ("Saved user successfully into Firebase")
                        })
                        self.performSegue(withIdentifier: "MainPageSegue", sender: self)
                    }
                })
            })
        }
    }
    
    
    @IBAction func registerUsingGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
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
