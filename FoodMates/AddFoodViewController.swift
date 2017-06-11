//
//  AddFoodViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 5/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase

class AddFoodViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textFoodName: UITextField!
    @IBOutlet weak var textFoodDescription: UITextField!
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    var ref: DatabaseReference?
    var storageRef: StorageReference?
    var imageURL: String?
    var chosenImage: UIImage?
    var id: String?
    
    required init?(coder aDecoder: NSCoder) {
        
        chosenImage = nil
        imageURL = nil
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        //Looks for single or multiple taps.
        
        self.textFoodName.delegate = self
        self.textFoodDescription.delegate = self
        self.textFoodName.returnKeyType = .done
        self.textFoodDescription.returnKeyType = .done
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddFoodViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addFoodToFirebase(_ sender: Any) {
        
        var foodName: String?
        var foodDescription: String?
        var foodDate: String?
        
        var date = Date()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        foodName = textFoodName.text
        foodDescription = textFoodDescription.text
        
        if (foodName?.isEmpty)!
        {
            displayAlert(title: "Alert", message: "Please add a name")
        }
        else if (foodDescription?.isEmpty)!
        {
            displayAlert(title: "Alert", message: "Please add a description")
        }
        else if (chosenImage == nil)
        {
            displayAlert(title: "Alert", message: "Please add a picture")
        }
        else
        {
            foodDate = dateFormatter.string(from: date)
            
            let values = ["foodName": foodName!, "foodDescription": foodDescription!, "imageURL": "Blank", "foodDate": foodDate]
            
            self.id = NSUUID().uuidString
            self.ref?.child("Foods").child((Auth.auth().currentUser?.uid)!).child(id!).setValue(values)
            saveImageToFirebase()
        }
    }

    
    func displayAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addPhotoUsingCamera(){
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        picker.sourceType = UIImagePickerControllerSourceType.camera
        
        present(picker, animated: true, completion: nil)
    }
    
    func addPhotoUsingLibrary()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as! UIImage?
//        {
//            self.foodImageView.image = editedImage
//        }
//        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as! UIImage?
//        {
//            self.foodImageView.image = originalImage
//        }
//        picker.dismiss(animated: true, completion: nil)
        
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
            foodImageView.image = selectedImage
            self.chosenImage = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageToFirebase()
    {
        var uploadData = UIImagePNGRepresentation(chosenImage!)
        storageRef?.child("Foods").child("\(self.id!).png").putData(uploadData!, metadata: nil, completion: {(metadata, error) in
            if error != nil {
                print (error)
                return
            }
            
            self.imageURL = metadata?.downloadURL()?.absoluteString
        self.ref?.child("Foods").child((Auth.auth().currentUser?.uid)!).child(self.id!).child("imageURL").setValue(self.imageURL)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func addFoodImage(_ sender: Any) {
        //addPhotoUsingCamera()
        addPhotoUsingLibrary()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
