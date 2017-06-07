//
//  ProfileViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 7/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var ref: FIRDatabaseReference?
    var reviews: Int?
    var sumratings: Int?
    
    required init?(coder aDecoder: NSCoder) {
        reviews = nil
        sumratings = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        retrieveUserInformationFromFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveUserInformationFromFirebase()
    {
        if let currentUser = FIRAuth.auth()?.currentUser {
            ref?.child("Ratings").child((currentUser.displayName)!).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let reviews = snapshot.childSnapshot(forPath: "reviews").value as? Int {
                    self.reviews = reviews
                }
                
                if let sumratings = snapshot.childSnapshot(forPath: "sumratings").value as? Int {
                    self.sumratings = sumratings
                }
                DispatchQueue.main.async(){
                    self.assignLabels()
                }
            })
        }

    }
    
    func assignLabels()
    {
        if let currentUser = FIRAuth.auth()?.currentUser {
            print("Logged in user is \(currentUser.displayName)")
            print("Logged in user is \(currentUser.email)")
            nameLabel.text = currentUser.displayName
            emailLabel.text = currentUser.email
            
            if ((sumratings != nil) && (reviews != nil))
            {
                var rating = sumratings!/reviews!
                ratingLabel.text = "\(rating)"
            }
            else
            {
                ratingLabel.text = "No ratings"
            }
        }
    }
    
    @IBAction func updateProfileImage(_ sender: Any) {
        print("update picture")
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
