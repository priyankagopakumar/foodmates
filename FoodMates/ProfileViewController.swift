//
//  ProfileViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 7/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var ref: DatabaseReference?
    var storageRef: StorageReference?
    
    var reviews: Int?
    var sumratings: Int?
    var name: String?
    var email: String?
    
    required init?(coder aDecoder: NSCoder) {
        reviews = nil
        sumratings = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        assignLabels()
        retrieveUserInformationFromFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveUserInformationFromFirebase()
    {
        self.ratingLabel.text = "No ratings"
        if let currentUser = Auth.auth().currentUser {
            ref?.child("Ratings").child(currentUser.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let reviews = snapshot.childSnapshot(forPath: "reviews").value as? Int {
                   // self.reviews = reviews
                //}
                
                    if let sumratings = snapshot.childSnapshot(forPath: "sumratings").value as? Int {
                        //self.sumratings = sumratings
                        if ((sumratings != nil) && (reviews != nil))
                        {
                            var rating = sumratings/reviews
                            self.ratingLabel.text = "\(rating)"
                        }
                    }
                }
//                DispatchQueue.main.async(){
//                    self.assignLabels()
//                }
            })
        }

    }
    
    func assignLabels()
    {
        if let currentUser = Auth.auth().currentUser {
            ref?.child("Profile").child(currentUser.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
                if let name = snapshot.childSnapshot(forPath: "name").value as? String {
                    self.name = name
                    self.nameLabel.text = name
                }
            
                if let email = snapshot.childSnapshot(forPath: "email").value as? String {
                    self.email = email
                    self.emailLabel.text = email
                }
                
                if let imageURL = snapshot.childSnapshot(forPath: "imageURL").value as? String {
                    if imageURL == "Blank"
                    {
                        self.profileImageView.image = #imageLiteral(resourceName: "grayprofile")
                    }
                    else
                    {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: imageURL)
                    }

                }
            })
        }
    }
    
    @IBAction func updateProfileImage(_ sender: Any) {
        print("update picture")
        pickImageFromDevice()
    }

    
    func pickImageFromDevice()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            print (editedImage)
            selectedImageFromPicker = editedImage
        }

        else
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            print (originalImage)
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            
            let uploadData = UIImagePNGRepresentation(selectedImage)
            storageRef?.child("Profile").child("\((Auth.auth().currentUser?.uid)!).png").putData(uploadData!, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print (error)
                    return
                }
                
                self.ref?.child("Profile").child((Auth.auth().currentUser?.uid)!).child("imageURL").setValue(metadata?.downloadURL()?.absoluteString)
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("cancelled image picker")
        dismiss(animated: true, completion: nil)
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
