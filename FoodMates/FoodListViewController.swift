//
//  FoodListViewController.swift
//  FoodMates
//
//  Created by Priyanka Gopakumar on 7/6/17.
//  Copyright © 2017 Priyanka Gopakumar. All rights reserved.
//

import UIKit
import Firebase

class FoodListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    var foodsList: NSMutableArray?
    var ref: DatabaseReference?
    var selectedFood: Food?
    var menuShowing = false
    
    required init?(coder aDecoder: NSCoder) {
        foodsList = NSMutableArray()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuView.layer.shadowOpacity = 1
        self.menuView.layer.shadowRadius = 6
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        ref = Database.database().reference()
        if let currentUser = Auth.auth().currentUser {
            print("Logged in user is \(currentUser.displayName)")
            print("Logged in user is \(currentUser.email)")
            
        }
        
        retrieveDataFromFirebase()
        
    }
    
    @IBAction func testPush(_ sender: Any) {
        var token = Messaging.messaging().fcmToken
        var message: Messaging

    }

    func retrieveDataFromFirebase()
    {
        // Retrieve the list of foods from Firebase
        ref?.child("Foods").observeSingleEvent(of: .value, with: {(snapshot) in
            
            self.foodsList?.removeAllObjects()
            for current in snapshot.children.allObjects as! [DataSnapshot]
            {
                var userID = current.key
                if (userID != Auth.auth().currentUser?.uid)
                {
                    for currentFood in current.children.allObjects as! [DataSnapshot]
                    {
                        let value = currentFood.value as? NSDictionary
                        let foodName = value?["foodName"] as? String ?? ""
                        let foodDescription = value?["foodDescription"] as? String ?? ""
                        let imageURL = value?["imageURL"] as? String ?? ""
                        let foodDate = value?["foodDate"] as? String ?? ""
                        let newItem = Food(userID: userID, foodName: foodName, foodDescription: foodDescription, foodDate: foodDate, imageURL: imageURL)
                        self.foodsList?.add(newItem)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            if self.foodsList?.count == 0
            {
                self.noItemsLabel.text = "No items to display"
            }
            else
            {
                self.noItemsLabel.text = ""
            }
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (foodsList?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodTableViewCell
        
        let food = foodsList?.object(at: indexPath.row) as! Food
        // Configure the cell...
        cell.labelFoodName.text = food.foodName
        cell.labelFoodDate.text = food.foodDate
        cell.foodImageView.layer.cornerRadius = 25
        cell.foodImageView.layer.masksToBounds = true        
        
        if (food.imageURL == "Blank")
        {
            cell.foodImageView.image = #imageLiteral(resourceName: "smallLogoFoodmates")
        }
        else
        {
            
            cell.foodImageView.loadImageUsingCacheWithUrlString(urlString: food.imageURL)
//            let url = URL(string: food.imageURL)
//            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
//            
//                // download had an error
//                if error != nil {
//                    print (error)
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    cell.foodImageView.image = UIImage(data: data!)
//                }
//                
//            }).resume()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFood = foodsList?.object(at: indexPath.row) as! Food
        performSegue(withIdentifier: "showFoodDetailsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showFoodDetailsSegue")
        {
            let destinationVC: FoodDetailsViewController = segue.destination as! FoodDetailsViewController
            destinationVC.currentFood = selectedFood
        }
    }
    
    
    @IBAction func showMenu(_ sender: Any) {
        if (menuShowing)
        {
            leadingConstraint.constant = -200
        }
        else
        {
            leadingConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        menuShowing = !menuShowing
        
    }

    @IBAction func logoutFromFoodmates(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
