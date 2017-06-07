//
//  FoodDetailsViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 5/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase

class FoodDetailsViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var foodDescriptionText: UITextView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var userContactLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    var currentFood: Food?
    var ref: FIRDatabaseReference?
    var userName: String?
    var userContact: String?
    var userImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        retrieveUserInformationFromFirebase()
    }

    func retrieveUserInformationFromFirebase()
    {
        ref?.child("Profile").child((currentFood?.userID)!).observeSingleEvent(of: .value, with: {(snapshot) in
        
            if let name = snapshot.childSnapshot(forPath: "name").value as? String {
                self.userName = name
            }
            if let number = snapshot.childSnapshot(forPath: "contact").value as? String {
                self.userContact = number
            }
            if let url = snapshot.childSnapshot(forPath: "imageURL").value as? String {
                self.userImageURL = url
                
                DispatchQueue.main.async(){
                    self.assignLabels()
                }
            }
        })
    }
    
    func assignLabels() {
        userIDLabel.text = currentFood?.userID
        foodNameLabel.text = currentFood?.foodName
        foodDescriptionText.text = currentFood?.foodDescription
        userIDLabel.text = userName
        userContactLabel.text = userContact
        
        if (currentFood?.imageURL == "Blank")
        {
            foodImageView.image = #imageLiteral(resourceName: "sampleimage")
        }
        else
        {
            let url = URL(string: (currentFood?.imageURL)!)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                foodImageView.image = image
            }
        }
        
        if (userImageURL == "Blank")
        {
            userImageView.image = #imageLiteral(resourceName: "profile")
        }
        else
        {
            let url = URL(string: userImageURL!)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                userImageView.image = image
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSwapRequest(_ sender: Any) {
    }

    @IBAction func callFoodmate(_ sender: Any) {
        let mobileNumber: String = (userContact?.replacingOccurrences(of: " ", with: ""))!
        guard let number = URL(string: "telprompt://" + mobileNumber) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
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
