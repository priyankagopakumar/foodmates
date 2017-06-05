//
//  AddFoodViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 5/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase

class AddFoodViewController: UIViewController {

    @IBOutlet weak var textFoodName: UITextField!
    @IBOutlet weak var textFoodDescription: UITextField!
    
    var ref: FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()
        
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
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        foodName = textFoodName.text
        foodDescription = textFoodDescription.text
        foodDate = dateFormatter.string(from: date)
        
        var values = ["foodname": foodName, "foodDescription": foodDescription, "imageURL": "blank", "foodDate": foodDate]
        
        var id = "\(foodName)_\(foodDate)"
        self.ref?.child("Foods").child("testuser1").child(id).setValue(values)
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
