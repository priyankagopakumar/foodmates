//
//  FoodDetailsViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 5/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FoodDetailsViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var foodDescriptionText: UITextView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var userContactLabel: UILabel!
    @IBOutlet weak var foodNameLabel: UILabel!
    
    var currentFood: Food?
    var ref: DatabaseReference?
    var userName: String?
    var userContact: String?
    var userImageURL: String?
    var fcm: String?
    
    @IBAction func testPush(_ sender: Any) {
        print("push")
        
        // Just to test, send push to self
        let url = "https://fcm.googleapis.com/fcm/send"
        let headers = ["Content-Type": "application/json",
                       "Authorization": "key=AAAAlpmHQdI:APA91bHSYKnQto0IWtkz49Ln20_MrfpvD6_fL6zSzRQlr_tpbcxjbq4IX1JMdXs0A0W6MjrwB0lDgwMJMhom-F_nycgxGZorPD2mY24r8uaHwuTPDV6Ts7urZqVmheJ5P3Jd5KGDBIN4"]
        let content = ["notification": ["title": "test push", "body": "hello to you", "sound": "default"], "to": self.fcm ?? ""] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: content, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = currentFood?.foodName
        
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.layer.cornerRadius = 25
        self.userImageView.layer.masksToBounds = true
        
        ref = Database.database().reference()
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
            if let fcm = snapshot.childSnapshot(forPath: "fcmToken").value as? String {
                self.fcm = fcm
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
            foodImageView.loadImageUsingCacheWithUrlString(urlString: (currentFood?.imageURL)!)
        }
        
        if (userImageURL == "Blank")
        {
            userImageView.image = #imageLiteral(resourceName: "profile")
        }
        else
        {
            userImageView.loadImageUsingCacheWithUrlString(urlString: userImageURL!)
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
